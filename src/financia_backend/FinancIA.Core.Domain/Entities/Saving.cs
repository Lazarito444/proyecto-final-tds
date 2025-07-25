namespace FinancIA.Core.Domain.Entities;
public class Saving
{
    public Guid Id { get; set; } = Guid.NewGuid();
    public Guid UserId { get; set; }
    public required string Name { get; set; }
    public decimal TargetAmount { get; set; }
    public decimal CurrentAmount { get; set; }
    public DateOnly? TargetDate { get; set; }
    public bool Finished => CurrentAmount >= TargetAmount;
    public ICollection<SavingTransaction> Transactions { get; set; } = new List<SavingTransaction>();
}
