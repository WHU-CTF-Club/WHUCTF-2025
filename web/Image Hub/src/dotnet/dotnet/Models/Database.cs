namespace dotnet.Models;

public class Users
{
    public Int32 Id { get; set; }
    public String Name { get; set; }
    public String Password { get; set; }
}

public class Images
{
    public Int32 Id { get; set; }
    public String Path { get; set; }
    public String Name { get; set; }
    public String Desc { get; set; }
    public Int32 TimeStamp { get; set; }
    public Int32 Height { get; set; }
    public Int32 Width { get; set; }
    public Int64 Size { get; set; }
}
