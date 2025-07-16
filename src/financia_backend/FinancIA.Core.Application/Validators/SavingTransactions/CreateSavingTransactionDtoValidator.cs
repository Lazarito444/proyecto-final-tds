using FinancIA.Core.Application.Dtos.SavingTransactions;
using FluentValidation;

namespace FinancIA.Core.Application.Validators.SavingTransactions;
public class CreateSavingTransactionDtoValidator : AbstractValidator<CreateSavingTransactionDto>
{
    public CreateSavingTransactionDtoValidator()
    {
        RuleFor(dto => dto.Note)
            .MaximumLength(255)
            .When(dto => dto.Note is not null)
            .WithMessage("Si se especifica una nota, no debe exceder de los 255 caracteres.");

        RuleFor(dto => dto.Amount)
            .NotNull()
            .WithMessage("La cantidad es requerida.")
            .InclusiveBetween(1m, 1_000_000_000m)
            .WithMessage("La cantidad debe estar entre 1 y 1,000,000,000.");

        DateTime minDate = DateTime.Today.AddYears(-1);
        DateTime maxDate = DateTime.Today.AddYears(1);

        RuleFor(dto => dto.Date)
            .NotNull()
            .WithMessage("La fecha objetivo es requerida.")
            .InclusiveBetween(minDate, maxDate)
            .WithMessage("La fecha objetivo no está dentro del rango.");
    }
}
