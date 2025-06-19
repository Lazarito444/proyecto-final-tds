namespace FinancIA.Core.Domain.Settings
{
    public class JwtSettings
    {
        public string Issuer { get; set; }
        public string Audience { get; set; }
        public string Key { get; set; }
        public string ExpirationTimeInMinutes { get; set; }
        public string RefreshTokenExpirationTimeInDays { get; set; }
    }
}
