using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using AutoMapper;
using FinancIA.Core.Application.Dtos.Saving;
using FinancIA.Core.Application.Dtos.SavingTransactions;
using FinancIA.Core.Domain.Entities;
using FinancIA.Infrastructure.Persistence;
using FluentValidation;
using FluentValidation.Results;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace FinancIA.Presentation.Api.Controllers;

[Authorize]
[ApiController]
[Route("api/saving")]
public class SavingController : ControllerBase
{
    // TODO: APLICAR LOS PATRONES REPOSITORY/SERVICE LO ANTES POSIBLE
    private readonly ApplicationDbContext _context;
    private readonly IMapper _mapper;
    public SavingController(ApplicationDbContext context, IMapper mapper)
    {
        _context = context;
        _mapper = mapper;
    }

    [HttpGet]
    public async Task<IActionResult> GetUserSavings()
    {
        Guid userId = Guid.Parse(User.FindFirstValue(JwtRegisteredClaimNames.Sub)!);

        List<Saving> savings = await _context.Savings
            .Where(s => s.UserId == userId)
            .Include(s => s.Transactions)
            .ToListAsync();

        return Ok(savings);
    }

    [HttpGet("{id}")]
    public async Task<IActionResult> GetSavingById([FromRoute] Guid id)
    {
        Saving? saving = await _context.Savings
            .FirstOrDefaultAsync(c => c.Id == id);

        if (saving is null) return NotFound();

        return Ok(saving);
    }

    [HttpGet("{id}/progress")]
    public async Task<IActionResult> GetSavingProgress([FromRoute] Guid id)
    {
        Saving? saving = await _context.Savings.FirstOrDefaultAsync(s => s.Id == id);

        if (saving is null) return NotFound();

        decimal percentage = (saving.CurrentAmount / saving.TargetAmount) * 100;

        return Ok(new
        {
            saving.CurrentAmount,
            saving.TargetAmount,
            percentage
        });
    }

    [HttpGet("{id}/transactions")]
    public async Task<IActionResult> GetAportes([FromRoute] Guid id)
    {
        Guid userId = Guid.Parse(User.FindFirstValue(JwtRegisteredClaimNames.Sub)!);

        bool exists = await _context.Savings.AnyAsync(s => s.Id == id && s.UserId == userId);
        if (!exists) return NotFound();

        List<SavingTransaction> savingTransactions = await _context.SavingTransactions
            .Where(t => t.SavingId == id)
            .OrderByDescending(t => t.DateTime)
            .ToListAsync();

        return Ok(savingTransactions);
    }

    [HttpPost("{id}/deposit")]
    public async Task<IActionResult> AddContribution([FromRoute] Guid id, [FromBody] CreateSavingTransactionDto dto, [FromServices] IValidator<CreateSavingTransactionDto> validator)
    {
        ValidationResult validationResult = await validator.ValidateAsync(dto);
        if (!validationResult.IsValid)
        {
            return BadRequest(new
            {
                StatusCode = StatusCodes.Status400BadRequest,
                Message = string.Join(", ", validationResult.Errors.Select(e => e.ErrorMessage))
            });
        }

        Saving? saving = await _context.Savings.FirstOrDefaultAsync(s => s.Id == id);

        if (saving is null) return NotFound();

        SavingTransaction savingTransaction = new SavingTransaction
        {
            SavingId = id,
            Amount = dto.Amount,
            DateTime = dto.Date,
            Note = dto.Note
        };

        saving.CurrentAmount += dto.Amount;

        await _context.SavingTransactions.AddAsync(savingTransaction);
        await _context.SaveChangesAsync();

        return Ok();
    }

    [HttpPost]
    public async Task<IActionResult> CreateSaving([FromBody] CreateSavingDto savingDto, [FromServices] IValidator<CreateSavingDto> validator)
    {
        ValidationResult validationResult = await validator.ValidateAsync(savingDto);
        if (!validationResult.IsValid)
        {
            return BadRequest(new
            {
                StatusCode = StatusCodes.Status400BadRequest,
                Message = string.Join(", ", validationResult.Errors.Select(e => e.ErrorMessage))
            });
        }

        Saving saving = _mapper.Map<Saving>(savingDto);
        saving.UserId = Guid.Parse(User.FindFirstValue(JwtRegisteredClaimNames.Sub)!);

        await _context.Savings.AddAsync(saving);
        await _context.SaveChangesAsync();

        return Ok(saving);
    }

    [HttpPut("{id}")]
    public async Task<IActionResult> UpdateSaving([FromRoute] Guid id, [FromBody] CreateSavingDto savingDto, IValidator<CreateSavingDto> validator)
    {
        ValidationResult validationResult = await validator.ValidateAsync(savingDto);
        if (!validationResult.IsValid)
        {
            return BadRequest(new
            {
                StatusCode = StatusCodes.Status400BadRequest,
                Message = string.Join(", ", validationResult.Errors.Select(e => e.ErrorMessage))
            });
        }

        Saving? saving = await _context.Savings.FindAsync(id);
        if (saving is null) return NotFound();
        savingDto.CurrentAmount = saving.CurrentAmount;
        _mapper.Map(savingDto, saving);
        await _context.SaveChangesAsync();

        return Ok(saving);
    }

    [HttpDelete("{id}")]
    public async Task<IActionResult> DeleteSaving([FromRoute] Guid id)
    {
        Saving? saving = await _context.Savings.FirstOrDefaultAsync(c => c.Id == id);
        if (saving is null) return NotFound();

        _context.Savings.Remove(saving);
        await _context.SaveChangesAsync();
        return NoContent();
    }

}
