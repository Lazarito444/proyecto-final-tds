using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using AutoMapper;
using FinancIA.Core.Application.Dtos.Transactions;
using FinancIA.Core.Domain.Entities;
using FinancIA.Infrastructure.Persistence;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace FinancIA.Presentation.Api.Controllers;

[Authorize]
[ApiController]
[Route("api/transaction")]
public class TransactionController : ControllerBase
{
    // TODO: APLICAR LOS PATRONES REPOSITORY/SERVICE LO ANTES POSIBLE
    private readonly ApplicationDbContext _context;
    private readonly IMapper _mapper;

    public TransactionController(ApplicationDbContext context, IMapper mapper)
    {
        _context = context;
        _mapper = mapper;
    }

    [HttpGet]
    public async Task<IActionResult> GetAllUserTransactions()
    {
        Guid userId = Guid.Parse(User.FindFirstValue(JwtRegisteredClaimNames.Sub)!);
        List<Transaction> transactions = await _context.Transactions
            .Include(t => t.Category)
            .Where(t => t.UserId == userId)
            .ToListAsync();

        return Ok(transactions);
    }

    [HttpGet("{id}")]
    public async Task<IActionResult> GetTransactionById([FromQuery] Guid id)
    {
        Transaction? transaction = await _context.Transactions
            .Include(t => t.Category)
            .FirstOrDefaultAsync(c => c.Id == id);

        if (transaction is null) return NotFound();

        return Ok(transaction);
    }

    [HttpPost]
    public async Task<IActionResult> CreateTransaction([FromBody] CreateTransactionDto transactionDto)
    {
        Transaction transaction = _mapper.Map<Transaction>(transactionDto);
        transaction.UserId = Guid.Parse(User.FindFirstValue(JwtRegisteredClaimNames.Sub)!);

        await _context.Transactions.AddAsync(transaction);
        await _context.SaveChangesAsync();

        return Ok(transaction);
    }

    [HttpPut("{id}")]
    public async Task<IActionResult> UpdateTransaction([FromRoute] Guid id, [FromBody] CreateTransactionDto transactionDto)
    {
        Transaction? transaction = await _context.Transactions.FindAsync(id);
        if (transaction is null) return NotFound();

        _mapper.Map(transactionDto, transaction);
        await _context.SaveChangesAsync();

        return Ok(transaction);
    }

    [HttpDelete("{id}")]
    public async Task<IActionResult> DeleteTransaction([FromRoute] Guid id)
    {
        Transaction? transaction = await _context.Transactions.FirstOrDefaultAsync(c => c.Id == id);
        if (transaction is null) return NotFound();

        _context.Transactions.Remove(transaction);
        await _context.SaveChangesAsync();
        return NoContent();
    }

}
