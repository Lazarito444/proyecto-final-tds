using AutoMapper;
using FinancIA.Core.Application.Dtos.Category;
using FinancIA.Core.Domain.Entities;

namespace FinancIA.Core.Application.Profiles;
public class CategoryProfile : Profile
{
    public CategoryProfile()
    {
        CreateMap<Category, CreateCategoryDto>()
            .ReverseMap();
    }
}
