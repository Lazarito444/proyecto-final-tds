using System.Text.Json.Serialization;

namespace FinancIA.Core.Domain.Entities;

public class Category
{
    public Guid Id { get; set; } = Guid.NewGuid();
    public Guid UserId { get; set; }
    public required string Name { get; set; }
    public bool IsEarningCategory { get; set; }
    public string ColorHex { get; set; } = "#000000";
    public string IconName { get; set; } = "circle";
    [JsonIgnore]
    public ICollection<Transaction>? Transactions { get; set; }
    [JsonIgnore]
    public ICollection<Budget>? Budgets { get; set; }
}
