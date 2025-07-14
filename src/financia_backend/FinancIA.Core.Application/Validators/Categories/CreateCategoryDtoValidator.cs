using FinancIA.Core.Application.Dtos.Category;
using FluentValidation;

namespace FinancIA.Core.Application.Validators.Categories;
public class CreateCategoryDtoValidator : AbstractValidator<CreateCategoryDto>
{
    public CreateCategoryDtoValidator()
    {
        RuleFor(dto => dto.Name)
            .NotEmpty()
            .WithMessage("El nombre es requerido")
            .MaximumLength(200)
            .WithMessage("El nombre no puede exceder los 200 caracteres");

        RuleFor(dto => dto.IconName)
            .NotEmpty()
            .WithMessage("El nombre de ícono es requerido");

        RuleFor(dto => dto.ColorHex)
            .NotEmpty()
            .WithMessage("El color hexadecimal es requerido");
    }
}
