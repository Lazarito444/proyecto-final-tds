using AutoMapper;
using FinancIA.Core.Application.Dtos.Budget;
using FinancIA.Core.Domain.Entities;

namespace FinancIA.Core.Application.Profiles;
public class BudgetProfile : Profile
{
    public BudgetProfile()
    {
        CreateMap<Budget, CreateBudgetDto>()
            .ReverseMap();
    }
}
