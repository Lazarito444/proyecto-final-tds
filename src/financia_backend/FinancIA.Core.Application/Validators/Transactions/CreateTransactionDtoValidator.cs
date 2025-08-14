using FinancIA.Core.Application.Dtos.Transactions;
using FluentValidation;
using Microsoft.AspNetCore.Http;

namespace FinancIA.Core.Application.Validators.Transactions;
public class CreateTransactionDtoValidator : AbstractValidator<CreateTransactionDto>
{
    public CreateTransactionDtoValidator()
    {
        RuleFor(dto => dto.CategoryId)
            .NotEmpty()
            .WithMessage("La categoría es requerida.");

        RuleFor(dto => dto.Amount)
            .GreaterThan(0)
            .WithMessage("El monto debe ser mayor que cero.");

        RuleFor(dto => dto.DateTime)
            .NotEmpty()
            .LessThanOrEqualTo(DateTime.Today.AddDays(1))
            .WithMessage("La fecha no puede ser futura.");

        RuleFor(dto => dto.Description)
            .MaximumLength(255)
            .WithMessage("La descripción no debe superar los 255 caracteres.");

        RuleFor(dto => dto.Image)
            .Must(HaveValidExtension)
            .WithMessage("Solo se permiten archivos .jpg, .jpeg, .png")
            .Must(WeighLessThanTenMegaBytes)
            .When(dto => dto.Image is not null)
            .WithMessage("Los archivos deben pesar menos de 10 MBs.");
    }

    private bool WeighLessThanTenMegaBytes(IFormFile file)
    {
        int maxSize = 10 * 1024 * 1024; // 10 MBs
        return file.Length <= maxSize;

    }

    private bool HaveValidExtension(IFormFile file)
    {
        string[] validExtensions = [".jpg", ".jpeg", ".png"];
        string extension = Path.GetExtension(file.FileName).ToLowerInvariant();
        return validExtensions.Contains(extension);
    }
}
