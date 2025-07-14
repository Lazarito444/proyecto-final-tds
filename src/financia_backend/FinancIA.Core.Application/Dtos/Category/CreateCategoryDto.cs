namespace FinancIA.Core.Application.Dtos.Category;
public class CreateCategoryDto
{
    public required string Name { get; set; }
    public bool IsEarningCategory { get; set; }
    public string ColorHex { get; set; } = "#000000";
    public string IconName { get; set; } = "circle";
}
