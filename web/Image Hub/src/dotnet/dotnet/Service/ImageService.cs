using dotnet.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;
using SixLabors.ImageSharp;
using SixLabors.ImageSharp.Formats.Jpeg;
using SixLabors.ImageSharp.Processing;

namespace dotnet.Service;

public class ImageService
{
    readonly UploadsConfig _options;
    readonly AppDbContext _context;
    
    public ImageService(IOptions<UploadsConfig> options, AppDbContext context)
    {
        _options = options.Value;
        _context = context;
        
        if (!Directory.Exists(_options.Path))
        {
            Directory.CreateDirectory(_options.Path);
        }
    }

    public async Task<List<Images>> List(Form.ImageRequest request)
    {
        string? sort = string.IsNullOrEmpty(request.Sort) ? "id" : request.Sort;
        int? limit = request.Limit ?? 50;
        int? page = request.Page ?? 1;
        page = page > 0 ? page : 1;
        
        List<Images> imageList = await _context.Images
            .FromSqlRaw(
                @"SELECT * FROM Images 
                  WHERE Name LIKE @p0 OR Desc LIKE @p0
                  ORDER BY " + sort + " " + request.Order + @" 
                LIMIT @p1 OFFSET @p2",
                $"%{request.Rules}%", // @p0
                limit,        // @p1
                limit * (page - 1) // @p2
            )
            .ToListAsync();
        return imageList;
    }

    public async Task<bool> Upload(IFormFile file, string desc)
    {
        try
        {
            if (!file.FileName.EndsWith(".jpg"))
            {
                return false;
            }
            if (file.FileName.Contains("..") || file.FileName.Contains("/"))
            {
                return false;
            }
            
            var filePath = Path.Combine(_options.Path, file.FileName);
            using (var stream = new FileStream(filePath, FileMode.Create))
            {
                await file.CopyToAsync(stream);
            }
            // 插入数据库
            Images images = new Images();
            images.Name = file.FileName;
            images.Path = Path.Combine(_options.Path, file.FileName);
            images.Desc = desc;
            images.TimeStamp = (int)DateTimeOffset.UtcNow.ToUnixTimeSeconds();
            images.Size = file.Length;
            try
            {
                using (var image = await Image.LoadAsync(filePath))
                {
                    images.Width = image.Width;
                    images.Height = image.Height;
                }
            }
            catch
            {
                images.Width = 0;
                images.Height = 0;
            }
            _context.Images.Add(images);
            await _context.SaveChangesAsync();
        } 
        catch
        {
            return false;
        }
        return true;
    }

    public async Task<byte[]?> GetImage(int id, bool thumbnail, bool crypto)
    {
        Images? images = await _context.Images.FindAsync(id);
        if (images == null)
        {
            return null;
        }
        
        if (!System.IO.File.Exists(images.Path))
        {
            return null;
        }

        byte[] imageData;
        // 略缩图
        if (thumbnail)
        {
            using (var image = await Image.LoadAsync(images.Path))
            {
                image.Mutate(x => x.Resize(300, 0));

                using (var ms = new MemoryStream())
                {
                    await image.SaveAsync(ms, new JpegEncoder());
                    imageData = ms.ToArray();
                }
            }
        }
        else
        {
            imageData = await System.IO.File.ReadAllBytesAsync(images.Path);
        }
        // 高斯模糊
        if (crypto)
        {
            using (var image = await Image.LoadAsync(new MemoryStream(imageData)))
            {
                // 对图片应用高斯模糊，5 是模糊的强度，数值越大模糊效果越强
                image.Mutate(x => x.GaussianBlur(20));

                // 转换图像为字节数组
                using (var ms = new MemoryStream())
                {
                    await image.SaveAsync(ms, new JpegEncoder());
                    return ms.ToArray();
                }
            }
        }
        else
        {
            return imageData;
        }
    }

    public async Task<Int32> GetImageCount()
    {
        var count = await _context.Images.CountAsync();
        return count;
    }
    
}