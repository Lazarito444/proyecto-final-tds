namespace FinancIA.Core.Application.Dtos.Transactions;

public class CreateTransactionDto
{
    public Guid CategoryId { get; set; }
    public required string Description { get; set; }
    public decimal Amount { get; set; }
    public DateTime DateTime { get; set; }
    public bool IsEarning { get; set; }
}
