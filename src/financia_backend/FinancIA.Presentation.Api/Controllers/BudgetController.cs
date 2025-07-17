using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using AutoMapper;
using FinancIA.Core.Application.Dtos.Budget;
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
[Route("api/bugdet")]
public class BudgetController : ControllerBase
{
    // TODO: APLICAR LOS PATRONES REPOSITORY/SERVICE LO ANTES POSIBLE
    private readonly ApplicationDbContext _context;
    private readonly IMapper _mapper;

    public BudgetController(ApplicationDbContext context, IMapper mapper)
    {
        _context = context;
        _mapper = mapper;
    }

    [HttpGet]
    public async Task<IActionResult> GetBudgets()
    {
        Guid userId = Guid.Parse(User.FindFirstValue(JwtRegisteredClaimNames.Sub)!);

        List<Budget> budgets = await _context.Budgets
            .Where(c => c.UserId == userId)
            .ToListAsync();

        return Ok(budgets);
    }

    [HttpGet("{id}")]
    public async Task<IActionResult> GetBudgetById([FromRoute] Guid id)
    {
        Budget? budget = await _context.Budgets
            .FirstOrDefaultAsync(c => c.Id == id);

        if (budget is null) return NotFound();

        return Ok(budget);
    }

    [HttpPost]
    public async Task<IActionResult> CreateBudget([FromBody] CreateBudgetDto budgetDto, [FromServices] IValidator<CreateBudgetDto> validator)
    {
        ValidationResult validationResult = await validator.ValidateAsync(budgetDto);
        if (!validationResult.IsValid)
        {
            return BadRequest(new
            {
                StatusCode = StatusCodes.Status400BadRequest,
                Message = string.Join(", ", validationResult.Errors.Select(e => e.ErrorMessage))
            });
        }

        Budget budget = _mapper.Map<Budget>(budgetDto);
        budget.UserId = Guid.Parse(User.FindFirstValue(JwtRegisteredClaimNames.Sub)!);

        await _context.Budgets.AddAsync(budget);
        await _context.SaveChangesAsync();

        return Ok(budget);
    }

    [HttpPut("{id}")]
    public async Task<IActionResult> UpdateBudget([FromRoute] Guid id, [FromBody] CreateBudgetDto budgetDto, [FromServices] IValidator<CreateBudgetDto> validator)
    {
        ValidationResult validationResult = await validator.ValidateAsync(budgetDto);
        if (!validationResult.IsValid)
        {
            return BadRequest(new
            {
                StatusCode = StatusCodes.Status400BadRequest,
                Message = string.Join(", ", validationResult.Errors.Select(e => e.ErrorMessage))
            });
        }

        Budget? budget = await _context.Budgets.FindAsync(id);
        if (budget is null) return NotFound();

        _mapper.Map(budgetDto, budget);
        await _context.SaveChangesAsync();

        return Ok(budget);
    }

    [HttpDelete("{id}")]
    public async Task<IActionResult> DeleteBudget([FromRoute] Guid id)
    {
        Budget? budget = await _context.Budgets.FirstOrDefaultAsync(c => c.Id == id);
        if (budget is null) return NotFound();

        _context.Budgets.Remove(budget);
        await _context.SaveChangesAsync();
        return NoContent();
    }
}
