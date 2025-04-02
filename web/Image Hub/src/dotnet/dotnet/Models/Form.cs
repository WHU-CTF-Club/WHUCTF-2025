namespace dotnet.Models;

public class Form
{
    public class LoginRequest
    {
        public required string Username { get; set; }
        public required string Password { get; set; }
    }

    public class ImageRequest
    {
        public int? Page { get; set; }
        public int? Limit { get; set; }
        public string? Rules { get; set; }
        public string? Order { get; set; }
        public string? Sort { get; set; }
    }
}