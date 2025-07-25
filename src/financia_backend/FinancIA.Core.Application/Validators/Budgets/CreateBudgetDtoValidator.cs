using FinancIA.Core.Application.Dtos.Budget;
using FluentValidation;

namespace FinancIA.Core.Application.Validators.Budgets;
public class CreateBudgetDtoValidator : AbstractValidator<CreateBudgetDto>
{
    public CreateBudgetDtoValidator()
    {
        RuleFor(dto => dto.MaximumAmount)
            .NotNull()
            .WithMessage("La cantidad máxima del presupuesto es requerida.")
            .InclusiveBetween(1m, 1_000_000_000m)
            .WithMessage("La cantidad máxima está fuera del rango");


        DateTime minDate = DateTime.Today.AddYears(-1);
        DateTime maxDate = DateTime.Today.AddYears(1);

        RuleFor(dto => dto.StartDate)
            .NotNull()
            .WithMessage("La fecha de inicio es requerida.")
            .InclusiveBetween(minDate, maxDate)
            .WithMessage("La fecha de inicio está fuera del rango");

        RuleFor(dto => dto.EndDate)
            .NotNull()
            .WithMessage("La fecha de inicio es requerida.")
            .InclusiveBetween(minDate, maxDate)
            .When(dto => !dto.IsRecurring)
            .WithMessage("La fecha de inicio está fuera del rango");

    }
}
