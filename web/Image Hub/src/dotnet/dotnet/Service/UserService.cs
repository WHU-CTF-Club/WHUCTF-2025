using System.Security.Cryptography;
using System.Text;
using dotnet.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;

namespace dotnet.Service;

public class UserService
{
    readonly AuthConfig _options;
    private readonly AppDbContext _context;

    public UserService(AppDbContext context, IOptions<AuthConfig> options)
    {
        _context = context;
        _options = options.Value;
    }

    public async Task<bool> CheckUser(string username, string password)
    {
        Users? users = await _context.Users.FirstOrDefaultAsync(u => u.Name == username);
        if (users == null)
        {
            return false;
        }
        
        var source = ASCIIEncoding.ASCII.GetBytes(password + _options.PassKey);
        var hash = BitConverter.ToString(MD5.Create().ComputeHash(source)).Replace("-", "");
        return hash == users.Password;
    }
}