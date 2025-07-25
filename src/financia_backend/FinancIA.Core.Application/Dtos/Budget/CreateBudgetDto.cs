namespace FinancIA.Core.Application.Dtos.Budget;
public class CreateBudgetDto
{
    public Guid? CategoryId { get; set; }
    public DateTime StartDate { get; set; }
    public DateTime EndDate { get; set; }
    public bool IsRecurring { get; set; }
    public decimal MaximumAmount { get; set; }
}
