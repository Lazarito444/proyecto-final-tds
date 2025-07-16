namespace FinancIA.Core.Application.Dtos.SavingTransactions;
public class CreateSavingTransactionDto
{
    public decimal Amount { get; set; }
    public DateTime Date { get; set; }
    public string? Note { get; set; }
}
