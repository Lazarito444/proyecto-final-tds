}using FinancIA.Core.Application.Dtos.Auth;
using FluentValidation;

namespace FinancIA.Api.Validators.Auth
{
    public class LoginRequestValidator : AbstractValidator<LoginRequest>
    {
        public LoginRequestValidator()
        {
            RuleFor(req => req.Email)
                .NotEmpty()
                .WithMessage("Email is requireed")
                .EmailAddress()
                .WithMessage("Enter a valid email address");

            RuleFor(req => req.Password)
                .NotEmpty()
                .WithMessage("Password is required");
        }
    }
}
