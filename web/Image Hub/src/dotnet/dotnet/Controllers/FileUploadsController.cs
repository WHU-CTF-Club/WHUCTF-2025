using dotnet.Service;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace dotnet.Controllers;

[ApiController]
[Route("api")]
public class FileUploadsController : Controller
{
    private readonly ImageService _imageService;
    
    public FileUploadsController(ImageService imageService)
    {
        _imageService = imageService;

    }

    [Authorize]
    [HttpGet("test")]
    public IActionResult Test()
    {
        return Ok();
    }
    
    [Authorize]
    [HttpPost("uploads")]
    public async Task<IActionResult> UploadFile([FromForm] IFormFile file, [FromForm] string desc)
    {
        
        if (file == null || file.Length == 0)
        {
            return BadRequest("请选择要上传的文件。");
        }
        
        var res = await _imageService.Upload(file, desc);
        
        if (res)
        {
            return Ok(new { Message = "文件上传成功", FileName = file.FileName });
        }
        return BadRequest("上传失败");
    }
}