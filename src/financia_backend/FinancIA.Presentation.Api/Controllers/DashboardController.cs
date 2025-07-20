using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using FinancIA.Infrastructure.Persistence;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace FinancIA.Presentation.Api.Controllers;

[Authorize]
[Route("api/dashboard-data")]
public class DashboardController : ControllerBase
{
    private readonly ApplicationDbContext _context;

    public DashboardController(ApplicationDbContext context)
    {
        _context = context;
    }

    [HttpGet]
    public async Task<IActionResult> GetDashboardData()
    {
        Guid userId = Guid.Parse(User.FindFirstValue(JwtRegisteredClaimNames.Sub)!);
        DateTime now = DateTime.UtcNow;
        DateTime startOfMonth = new DateTime(now.Year, now.Month, 1);
        DateTime endOfMonth = startOfMonth.AddMonths(1).AddSeconds(-1);

        var userLastTransactions = await _context.Transactions
            .Where(t => t.UserId == userId)
            .Include(t => t.Category)
            .OrderByDescending(t => t.DateTime)
            .Take(5)
            .Select(t => new
            {
                t.Id,
                t.Amount,
                t.Description,
                CategoryName = t.Category!.Name,
                t.DateTime,
                t.Category.IsEarningCategory,
                t.Category.ColorHex,
                t.Category.IconName
            })
            .ToListAsync();

        decimal earnings = await _context.Transactions
            .Include(t => t.Category)
            .Where(t => t.UserId == userId &&
                        t.DateTime >= startOfMonth &&
                        t.DateTime <= endOfMonth &&
                        t.Category!.IsEarningCategory)
            .SumAsync(t => t.Amount);

        decimal expenses = await _context.Transactions
            .Include(t => t.Category)
            .Where(t => t.UserId == userId &&
                        t.DateTime >= startOfMonth &&
                        t.DateTime <= endOfMonth &&
                        !t.Category!.IsEarningCategory)
            .SumAsync(t => t.Amount);

        var earningsByCategory = await _context.Transactions
            .Include(t => t.Category)
            .Where(t => t.UserId == userId &&
                        t.DateTime >= startOfMonth &&
                        t.DateTime <= endOfMonth &&
                        t.Category!.IsEarningCategory)
            .GroupBy(t => t.Category!.Name)
            .Select(g => new
            {
                CategoryName = g.Key,
                TotalAmount = g.Sum(t => t.Amount)
            })
            .OrderByDescending(c => c.TotalAmount)
            .ToListAsync();

        var expensesByCategory = await _context.Transactions
            .Include(t => t.Category)
            .Where(t => t.UserId == userId &&
                        t.DateTime >= startOfMonth &&
                        t.DateTime <= endOfMonth &&
                        !t.Category!.IsEarningCategory)
            .GroupBy(t => t.Category!.Name)
            .Select(g => new
            {
                CategoryName = g.Key,
                TotalAmount = g.Sum(t => t.Amount)
            })
            .OrderByDescending(c => c.TotalAmount)
            .ToListAsync();

        return Ok(new
        {
            userLastTransactions,
            earnings,
            expenses,
            earningsByCategory,
            expensesByCategory
        });
    }
}
