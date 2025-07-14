namespace FinancIA.Core.Application.Dtos.Budget;
public class CreateBudgetDto
{
    public Guid UserId { get; set; }
    public Guid CategoryId { get; set; }
    public DateOnly Month { get; set; }
    public decimal MaximumAmount { get; set; }
}
