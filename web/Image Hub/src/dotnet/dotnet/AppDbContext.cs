using dotnet.Models;
using Microsoft.EntityFrameworkCore;
namespace dotnet;

public class AppDbContext: DbContext
{
    public DbSet<Users> Users { get; set; }
    public DbSet<Images> Images { get; set; }

    public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }
    
    // protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
    // {
    //     if (!optionsBuilder.IsConfigured)
    //     {
    //         var connection = new SqliteConnection("Data Source=mydatabase.db");
    //         connection.Open();
    //
    //         // 允许扩展加载
    //         connection.EnableExtensions(true);
    //
    //         // 例如，加载 SpatiaLite 扩展
    //         connection.LoadExtension("mod_spatialite");
    //
    //         optionsBuilder.UseSqlite(connection);
    //     }
    // }
}