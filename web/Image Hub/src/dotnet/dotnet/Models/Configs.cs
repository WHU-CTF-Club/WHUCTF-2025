namespace dotnet.Models;

#region Uploads Config

public class UploadsConfig
{
    public String Path { get; set; }  = "./uploads";
}

#endregion


#region Auth Config

public class AuthConfig
{
    public required String JwtKey { get; set; }
    public String PassKey { get; set; } = "w1ll_siesta_b3come_a_j0ker?";
}
#endregion

