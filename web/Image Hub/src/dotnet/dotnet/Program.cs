using System.Data;
using System.Text;
using dotnet.Models;
using dotnet.Service;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.Data.Sqlite;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;


namespace dotnet
{
    public class Program
    {
        public static void Main(string[] args)
        {
            WebApplicationBuilder builder = WebApplication.CreateBuilder(args);
            
            if (!builder.Configuration.GetSection("ConnectionStrings").GetSection("Database").Exists())
            {
                Console.Error.WriteLine("The database configuration file could not be found.");
                Thread.Sleep(30000);
                Environment.Exit(1);
            }
            var connection = new SqliteConnection(builder.Configuration.GetConnectionString("Database"));
            connection.Open();
            connection.EnableExtensions(true);
            
            builder.Services.AddDbContext<AppDbContext>(options => options.UseSqlite(connection));
            if (!builder.Configuration.GetSection("AuthConfig").GetSection("JwtKey").Exists())
            {
                Console.Error.WriteLine("The Jwt Key configuration file could not be found.");
                Thread.Sleep(30000);
                Environment.Exit(1);
            }
            var key = Encoding.ASCII.GetBytes(builder.Configuration.GetSection("AuthConfig").GetSection("JwtKey").Value);
            builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
                .AddJwtBearer(options =>
                {
                    options.TokenValidationParameters = new TokenValidationParameters
                    {
                        ValidateIssuer = false,
                        ValidateAudience = false,
                        ValidateLifetime = true,
                        ValidateIssuerSigningKey = true,
                        IssuerSigningKey = new SymmetricSecurityKey(key)
                    };
                });
            
            builder.Services.AddScoped<ImageService>();
            builder.Services.AddScoped<UserService>();
            builder.Services.Configure<AuthConfig>(builder.Configuration.GetSection("AuthConfig"));
            builder.Services.Configure<UploadsConfig>(builder.Configuration.GetSection("UploadsConfig"));

            
            builder.Services.AddControllers();
            WebApplication app = builder.Build();
            app.UseHttpsRedirection();
            app.MapControllers();
            app.MapFallbackToFile("index.html"); 
            app.UseStaticFiles();
            app.Run();
        }
    }
}
