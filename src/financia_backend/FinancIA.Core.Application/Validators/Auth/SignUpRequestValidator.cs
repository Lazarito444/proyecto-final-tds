using FinancIA.Core.Application.Dtos.Auth;
using FinancIA.Core.Application.Identity;
using FluentValidation;
using Microsoft.AspNetCore.Identity;

namespace FinancIA.Core.Application.Validators.Auth;
public class SignUpRequestValidator : AbstractValidator<SignUpRequest>
{
    private readonly UserManager<ApplicationUser> _userManager;
    public SignUpRequestValidator(UserManager<ApplicationUser> userManager)
    {
        _userManager = userManager;

        RuleFor(req => req.FullName)
            .NotEmpty().WithMessage("El nombre completo es requerido")
            .MinimumLength(5).WithMessage("El nombre completo debe tener 5 caracteres mínimo")
            .MaximumLength(120).WithMessage("El nombre completo no debe exceder los 120 caracteres");

        RuleFor(req => req.Email)
            .NotEmpty().WithMessage("El correo electrónico es requerido")
            .EmailAddress().WithMessage("El correo electrónico es inválido")
            .MustAsync(BeUniqueEmail).WithMessage("Ese correo electrónico ya está registrado");

        RuleFor(req => req.Password)
            .NotEmpty().WithMessage("La contraseña es requerida")
            .MinimumLength(5).WithMessage("La contraseña debe tener 5 caracteres mínimo")
            .Must(HaveLowercase);

        RuleFor(req => req.PasswordConfirmation)
            .Equal(req => req.Password).WithMessage("Las contraseñas no coinciden");
        _userManager = userManager;
    }

    private async Task<bool> BeUniqueEmail(string email, CancellationToken token)
    {
        ApplicationUser? user = await _userManager.FindByEmailAsync(email);
        return user == null;
    }

    private bool HaveLowercase(string arg)
    {
        return arg.Any(ch => ch == char.ToLower(ch));
    }
}
