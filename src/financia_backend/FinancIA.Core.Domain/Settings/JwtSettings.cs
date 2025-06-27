namespace FinancIA.Core.Domain.Settings;
public class JwtSettings
{
    public required string Issuer { get; set; }
    public required string Audience { get; set; }
    public required string Key { get; set; }
    public int AccessTokenExpirationTimeInMinutes { get; set; }
    public int RefreshTokenExpirationTimeInMinutes { get; set; }
    public byte[] KeyBytes { get; set; }
}
