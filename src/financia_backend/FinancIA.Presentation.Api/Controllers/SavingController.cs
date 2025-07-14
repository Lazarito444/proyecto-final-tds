using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using AutoMapper;
using FinancIA.Core.Application.Dtos.Saving;
using FinancIA.Core.Domain.Entities;
using FinancIA.Infrastructure.Persistence;
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
    public async Task<IActionResult> GetSavings()
    {
        Guid userId = Guid.Parse(User.FindFirstValue(JwtRegisteredClaimNames.Sub)!);

        List<Saving> savings = await _context.Savings
            .Where(c => c.UserId == userId)
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

    [HttpPost]
    public async Task<IActionResult> CreateSaving([FromBody] CreateSavingDto savingDto)
    {
        Saving saving = _mapper.Map<Saving>(savingDto);
        saving.UserId = Guid.Parse(User.FindFirstValue(JwtRegisteredClaimNames.Sub)!);

        await _context.Savings.AddAsync(saving);
        await _context.SaveChangesAsync();

        return Ok(saving);
    }

    [HttpPut("{id}")]
    public async Task<IActionResult> UpdateSaving([FromRoute] Guid id, [FromBody] CreateSavingDto savingDto)
    {
        Saving? saving = await _context.Savings.FindAsync(id);
        if (saving is null) return NotFound();

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
