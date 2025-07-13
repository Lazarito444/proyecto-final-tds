namespace FinancIA.Core.Application.Dtos.Saving;
public class CreateSavingDto
{
    public Guid UserId { get; set; }
    public required string Name { get; set; }
    public decimal GoalAmount { get; set; }
    public decimal CurrentAmount { get; set; }
    public DateOnly? Deadline { get; set; }
}
