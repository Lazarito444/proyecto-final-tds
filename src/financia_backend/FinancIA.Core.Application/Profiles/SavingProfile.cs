using AutoMapper;
using FinancIA.Core.Application.Dtos.Saving;
using FinancIA.Core.Domain.Entities;

namespace FinancIA.Core.Application.Profiles;
public class SavingProfile : Profile
{
    public SavingProfile()
    {
        CreateMap<Saving, CreateSavingDto>()
            .ReverseMap();
    }
}
