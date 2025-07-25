using AutoMapper;
using FinancIA.Core.Application.Dtos.Transactions;
using FinancIA.Core.Domain.Entities;

namespace FinancIA.Core.Application.Profiles;
public class TransactionProfile : Profile
{
    public TransactionProfile()
    {
        CreateMap<Transaction, CreateTransactionDto>()
            .ReverseMap();

        CreateMap<Transaction, UpdateTransactionDto>()
            .ReverseMap();
    }
}
