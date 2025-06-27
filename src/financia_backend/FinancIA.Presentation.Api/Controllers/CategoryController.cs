using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using AutoMapper;
using FinancIA.Core.Application.Dtos.Category;
using FinancIA.Core.Domain.Entities;
using FinancIA.Infrastructure.Persistence;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace FinancIA.Presentation.Api.Controllers;

[Authorize]
[ApiController]
[Route("api/category")]
public class CategoryController : ControllerBase
{
    // TODO: APLICAR LOS PATRONES REPOSITORY/SERVICE LO ANTES POSIBLE
    private readonly ApplicationDbContext _context;
    private readonly IMapper _mapper;

    public CategoryController(ApplicationDbContext context, IMapper mapper)
    {
        _context = context;
        _mapper = mapper;
    }

    [HttpGet]
    public async Task<IActionResult> GetAllUserCategories()
    {
        Guid userId = Guid.Parse(User.FindFirstValue(JwtRegisteredClaimNames.Sub)!);

        List<Category> categories = await _context.Categories
            .Include(c => c.Transactions)
            .Where(c => c.UserId == userId)
            .ToListAsync();

        return Ok(categories);
    }

    [HttpGet("{id}")]
    public async Task<IActionResult> GetCategoryById([FromRoute] Guid id)
    {
        Category? category = await _context.Categories
            .Include(c => c.Transactions)
            .FirstOrDefaultAsync(c => c.Id == id);

        if (category is null) return NotFound();

        return Ok(category);
    }

    [HttpPost]
    public async Task<IActionResult> CreateCategory([FromBody] CreateCategoryDto categoryDto)
    {
        Category category = _mapper.Map<Category>(categoryDto);
        category.UserId = Guid.Parse(User.FindFirstValue(JwtRegisteredClaimNames.Sub)!);

        await _context.Categories.AddAsync(category);
        await _context.SaveChangesAsync();

        return Ok(category);
    }

    [HttpPut("{id}")]
    public async Task<IActionResult> UpdateCategory([FromRoute] Guid id, [FromBody] CreateCategoryDto categoryDto)
    {
        Category? category = await _context.Categories.FindAsync(id);
        if (category is null) return NotFound();

        _mapper.Map(categoryDto, category);
        await _context.SaveChangesAsync();

        return Ok(category);
    }

    [HttpDelete("{id}")]
    public async Task<IActionResult> DeleteCategory([FromRoute] Guid id)
    {
        Category? category = await _context.Categories.FirstOrDefaultAsync(c => c.Id == id);
        if (category is null) return NotFound();

        _context.Categories.Remove(category);
        await _context.SaveChangesAsync();
        return NoContent();
    }
}
