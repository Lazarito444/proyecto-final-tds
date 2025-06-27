using FinancIA.Core.Application.Dtos.Auth;
using FluentValidation;

namespace FinancIA.Core.Application.Validators.Auth;
public class AuthenticateRequestValidator : AbstractValidator<AuthenticateRequest>
{
    public AuthenticateRequestValidator()
    {
        RuleFor(req => req.Email)
            .NotEmpty().WithMessage("El correo electrónico es requerido")
            .EmailAddress().WithMessage("El correo electrónico no es válido");

        RuleFor(req => req.Password)
            .NotEmpty().WithMessage("La contraseña es requerida");
    }
}
