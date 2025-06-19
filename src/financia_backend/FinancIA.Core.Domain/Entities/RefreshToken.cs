namespace FinancIA.Core.Domain.Entities
{
    public class RefreshToken
    {
        public int UserId { get; set; }
        public string Token { get; set; }
        public DateTime Created { get; set; }
        public DateTime Expires { get; set; }
        public DateTime? Revoked { get; set; }
        public bool IsValid => Revoked == null && Expires >= DateTime.Now;
    }
}
