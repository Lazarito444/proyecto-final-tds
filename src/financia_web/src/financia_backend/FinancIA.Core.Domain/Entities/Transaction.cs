namespace FinancIA.Core.Domain.Entities
{
    public class Transaction
    {
        public Guid Id { get; set; } = Guid.NewGuid();
        public Guid UserId { get; set; }
        public Guid CategoryId { get; set; }
        public string Description { get; set; }
        public decimal Amount { get; set; }
        public DateTime DateTime { get; set; }
        public Category Category { get; set; }
        public bool IsEarning { get; set; }
    }
}
