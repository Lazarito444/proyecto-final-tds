namespace FinancIA.Core.Application.Dtos.Saving;
public class CreateSavingDto
{
    public required string Name { get; set; }
    public decimal TargetAmount { get; set; }
    public decimal CurrentAmount { get; set; }
    public DateOnly? TargetDate { get; set; }
}
