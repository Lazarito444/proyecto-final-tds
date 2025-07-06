using FinancIA.Core.Application.Dtos.Account;
using FluentValidation;

namespace FinancIA.Core.Application.Validators.Account;
public class UpdateAccountRequestValidator : AbstractValidator<UpdateAccountRequest>
{
    public UpdateAccountRequestValidator()
    {
        RuleFor(dto => dto.FullName).NotEmpty();
    }
}
