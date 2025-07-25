namespace FinancIA.Core.Application.Dtos.Transactions;
public class TransactionQueryFilterParameters
{
    public Guid? CategoryId { get; set; }
    public bool? Earning { get; set; }
    public DateTime? FromDate { get; set; }
    public DateTime? ToDate { get; set; }
}
