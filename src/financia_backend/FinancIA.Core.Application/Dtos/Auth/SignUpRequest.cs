namespace FinancIA.Core.Application.Dtos.Auth;
public class SignUpRequest
{
    public required string FullName { get; set; }
    public required string Email { get; set; }
    public required string Password { get; set; }
    public required string PasswordConfirmation { get; set; }
}
