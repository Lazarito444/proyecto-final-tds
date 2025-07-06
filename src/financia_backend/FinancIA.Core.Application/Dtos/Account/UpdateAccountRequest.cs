using FinancIA.Core.Domain.Enums;
using Microsoft.AspNetCore.Http;

namespace FinancIA.Core.Application.Dtos.Account;
public class UpdateAccountRequest
{
    public string? FullName { get; set; }
    public DateOnly? DateOfBirth { get; set; }
    public Gender? Gender { get; set; }
    public string? Password { get; set; }
    public string? CurrentPassword { get; set; }
    public IFormFile? PhotoFile { get; set; }
}
