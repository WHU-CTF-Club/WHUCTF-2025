using dotnet.Models;
using dotnet.Service;
using Microsoft.AspNetCore.Mvc;

namespace dotnet.Controllers;

[ApiController]
[Route("api")]
public class ImageController : ControllerBase
{
    private readonly ImageService _imageService;
    
    public ImageController(ImageService imageService)
    {
        _imageService = imageService;

    }

    [HttpPost("list")]
    public async Task<IActionResult> ImageList([FromBody] Form.ImageRequest request)
    {
        var imageList = _imageService.List(request);
        var totalCount = _imageService.GetImageCount();
        return Ok(new {
            images = imageList.Result,
            totalCount = totalCount.Result
        });
    }

    [HttpGet("image/{id}")]
    public async Task<IActionResult> GetImage([FromRoute] int id, [FromQuery] int thumbnail)
    {
        var imageFile = _imageService.GetImage(id, thumbnail != 0, false);
        if (imageFile.Result == null)
        {
            return NotFound();
        }
        return File(imageFile.Result, "image/jpeg");
    }
}
