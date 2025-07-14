namespace FinancIA.Core.Domain.Entities;
public class Budget
{
    public Guid Id { get; set; } = Guid.NewGuid();
    public Guid UserId { get; set; }
    public Guid? CategoryId { get; set; }
    public DateTime StartDate { get; set; }
    public DateTime EndDate { get; set; }
    public bool IsRecurring { get; set; }
    public decimal MaximumAmount { get; set; }
    public Category Category { get; set; }
}
