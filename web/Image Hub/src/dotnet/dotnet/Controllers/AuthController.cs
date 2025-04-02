using System.Text;
using dotnet.Models;
using dotnet.Service;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using Microsoft.Extensions.Options;

namespace dotnet.Controllers;

[ApiController]
[Route("api")]
public class AuthController : ControllerBase
{
    readonly AuthConfig _options;
    private readonly UserService _userService;

    public AuthController(UserService userService, IOptions<AuthConfig> options)
    {
        _userService = userService;
        _options = options.Value;
    }
    
    [HttpPost("login")]
    public async  Task<IActionResult> Login([FromBody] Form.LoginRequest request)
    {
        if (await _userService.CheckUser(request.Username, request.Password))
        {
            var tokenHandler = new JwtSecurityTokenHandler();
            var tokenKey = Encoding.UTF8.GetBytes(_options.JwtKey);
            var tokenDescriptor = new SecurityTokenDescriptor
            {
                Subject = new ClaimsIdentity(new Claim[] { new Claim(ClaimTypes.Name, request.Username) }),
                Expires = DateTime.UtcNow.AddHours(2),
                SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(tokenKey), SecurityAlgorithms.HmacSha256)
            };
            var token = tokenHandler.CreateToken(tokenDescriptor);
            return Ok(new { token = tokenHandler.WriteToken(token) });
        }
        
        return Unauthorized(new { message = "Invalid username or password" });
    }
}