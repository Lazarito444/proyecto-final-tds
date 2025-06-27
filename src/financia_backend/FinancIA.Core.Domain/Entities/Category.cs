using System.Text.Json.Serialization;

namespace FinancIA.Core.Domain.Entities;

public class Category
{
    public Guid Id { get; set; } = Guid.NewGuid();
    public Guid UserId { get; set; }
    public required string Name { get; set; }
    [JsonIgnore]
    public ICollection<Transaction>? Transactions { get; set; }
}
