using FinancIA.Core.Domain.Enums;
using Microsoft.AspNetCore.Identity;

namespace FinancIA.Core.Application.Identity;
public class ApplicationUser : IdentityUser<Guid>
{
    public required string FullName { get; set; }
    public Gender Gender { get; set; } = Gender.Unspecified;
    public string? ImagePath { get; set; }
    public DateOnly? DateOfBirth { get; set; }
}
