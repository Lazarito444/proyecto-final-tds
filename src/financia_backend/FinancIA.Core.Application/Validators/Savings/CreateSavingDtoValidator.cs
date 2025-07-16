using FinancIA.Core.Application.Dtos.Saving;
using FluentValidation;

namespace FinancIA.Core.Application.Validators.Savings;
public class CreateSavingDtoValidator : AbstractValidator<CreateSavingDto>
{
    public CreateSavingDtoValidator()
    {
        RuleFor(dto => dto.Name)
            .NotEmpty()
            .WithMessage("El nombre es requerido.")
            .Length(1, 120)
            .WithMessage("El nombre debe estar entre 1 y 120 caracteres.");

        RuleFor(dto => dto.CurrentAmount)
            .NotNull()
            .WithMessage("La cantidad actual es requerida.")
            .InclusiveBetween(1m, 1_000_000_000m)
            .WithMessage("La cantidad actual debe estar entre 1 y 1,000,0000,000.");

        RuleFor(dto => dto.TargetAmount)
            .NotNull()
            .WithMessage("La cantidad meta es requerida.")
            .InclusiveBetween(1m, 1_000_000_000m)
            .WithMessage("La cantidad meta debe estar entre 1 y 1,000,000,000.");

        DateOnly minDate = DateOnly.FromDateTime(DateTime.Today.AddYears(-1));
        DateOnly maxDate = DateOnly.FromDateTime(DateTime.Today.AddYears(1));

        RuleFor(dto => dto.TargetDate)
            .NotNull()
            .WithMessage("La fecha objetivo es requerida.")
            .InclusiveBetween(minDate, maxDate)
            .WithMessage("La fecha objetivo no está dentro del rango.");
    }
}
