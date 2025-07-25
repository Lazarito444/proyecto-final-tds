using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using AutoMapper;
using FinancIA.Core.Application.Dtos.Transactions;
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

    [HttpGet("filter")]
    public async Task<IActionResult> GetAllUserTransactionsFiltered([FromQuery] TransactionQueryFilterParameters filter)
    {
        Guid userId = Guid.Parse(User.FindFirstValue(JwtRegisteredClaimNames.Sub)!);

        IQueryable<Transaction> query = _context.Transactions
            .Include(t => t.Category)
            .Where(t => t.UserId == userId);

        if (filter.CategoryId.HasValue)
        {
            query = query.Where(t => t.CategoryId == filter.CategoryId.Value);
        }

        if (filter.Earning.HasValue)
        {
            query = query.Where(t => t.IsEarning == filter.Earning.Value);
        }

        if (filter.FromDate.HasValue)
        {
            query = query.Where(t => t.DateTime >= filter.FromDate.Value);
        }

        if (filter.ToDate.HasValue)
        {
            query = query.Where(t => t.DateTime <= filter.ToDate.Value);
        }

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
    public async Task<IActionResult> CreateTransaction([FromForm] CreateTransactionDto transactionDto, [FromServices] IValidator<CreateTransactionDto> validator)
    {
        ValidationResult validationResult = await validator.ValidateAsync(transactionDto);
        if (!validationResult.IsValid)
        {
            return BadRequest(new
            {
                StatusCode = StatusCodes.Status400BadRequest,
                Message = string.Join(", ", validationResult.Errors.Select(e => e.ErrorMessage))
            });
        }

        Transaction transaction = _mapper.Map<Transaction>(transactionDto);
        transaction.UserId = Guid.Parse(User.FindFirstValue(JwtRegisteredClaimNames.Sub)!);

        if (transactionDto.Image is not null)
        {
            transaction.ImagePath = UploadPhoto(transaction.Id, transactionDto.Image);
        }

        await _context.Transactions.AddAsync(transaction);
        await _context.SaveChangesAsync();

        return Ok(transaction);
    }

    [HttpPut("{id}")]
    public async Task<IActionResult> UpdateTransaction([FromRoute] Guid id, [FromForm] UpdateTransactionDto transactionDto, [FromServices] IValidator<UpdateTransactionDto> validator)
    {
        ValidationResult validationResult = await validator.ValidateAsync(transactionDto);
        if (!validationResult.IsValid)
        {
            return BadRequest(new
            {
                StatusCode = StatusCodes.Status400BadRequest,
                Message = string.Join(", ", validationResult.Errors.Select(e => e.ErrorMessage))
            });
        }

        Transaction? transaction = await _context.Transactions.FindAsync(id);
        if (transaction is null) return NotFound();

        _mapper.Map(transactionDto, transaction);

        if (transactionDto.Image is not null)
        {
            transaction.ImagePath = UploadPhoto(transaction.Id, transactionDto.Image);
        }

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

    [HttpGet("monthly-summary")]
    public async Task<IActionResult> GetMonthlySummary([FromQuery] DateTime month)
    {
        Guid userId = Guid.Parse(User.FindFirstValue(JwtRegisteredClaimNames.Sub)!);

        DateTime start = new DateTime(month.Year, month.Month, 1);
        DateTime end = start.AddMonths(1).AddDays(-1);

        List<Transaction> transactions = await _context.Transactions
            .Include(t => t.Category)
            .Where(t => t.UserId == userId && t.DateTime >= start && t.DateTime <= end)
            .ToListAsync();

        decimal totalIncome = transactions
            .Where(t => t.Category!.IsEarningCategory)
            .Sum(t => t.Amount);

        decimal totalExpenses = transactions
            .Where(t => !t.Category!.IsEarningCategory)
            .Sum(t => t.Amount);

        var summary = new
        {
            start.Year,
            start.Month,
            TotalIncome = totalIncome,
            TotalExpenses = totalExpenses
        };

        return Ok(summary);
    }

    private string UploadPhoto(Guid id, IFormFile file)
    {
        string[] allowedExtensions = [".jpg", ".png", ".jpeg"];
        string extension = Path.GetExtension(file.FileName).ToLowerInvariant();

        if (string.IsNullOrEmpty(extension) || !allowedExtensions.Contains(extension))
        {
            throw new InvalidOperationException("Solo se permiten imágenes JPG y PNG.");
        }

        const long maxSizeInBytes = 10 * 1024 * 1024;
        if (file.Length > maxSizeInBytes)
        {
            throw new InvalidOperationException("El archivo excede el tamaño máximo permitido de 10 MB.");
        }

        string baseFolder = Path.Combine(Directory.GetCurrentDirectory(), "images", "transactions", id.ToString());

        if (!Directory.Exists(baseFolder))
        {
            Directory.CreateDirectory(baseFolder);
        }
        // Crear nombre único para la imagen
        string fileName = $"{Guid.NewGuid()}{extension}";
        string fullPath = Path.Combine(baseFolder, fileName);

        // Guardar el archivo físicamente
        using (FileStream stream = new FileStream(fullPath, FileMode.Create))
        {
            file.CopyTo(stream);
        }

        // Ruta relativa que puedes guardar en base de datos
        string relativePath = Path.Combine("images", "transactions", id.ToString(), fileName);

        return relativePath.Replace("\\", "/");
    }
}
