using System.Text;
using FinancIA.Core.Application.Contracts.Services;
using Microsoft.EntityFrameworkCore;

namespace FinancIA.Infrastructure.Persistence.Services;
public class AiService : IAiService
{
    private readonly ApplicationDbContext _context;

    public AiService(ApplicationDbContext context)
    {
        _context = context;
    }

    public async Task<string> BuildChatWithAiPrompt(Guid userId, string prompt, bool english)
    {
        DateTime now = DateTime.UtcNow;
        DateTime start = now.AddMonths(-12);

        var transactions = await _context.Transactions
            .Include(t => t.Category)
            .Where(t => t.UserId == userId &&
                        t.DateTime >= start &&
                        t.DateTime <= now)
            .ToListAsync();



        StringBuilder sb = new StringBuilder();
        sb.AppendLine("Estas son todas las transacciones del usuario en los últimos 6 meses:");
        foreach (var transaction in transactions)
        {
            sb.AppendLine($"[{transaction.IsEarning}] {transaction.Category!.Name} - {transaction.Description}; ${transaction.Amount.ToString("F")}; {transaction.DateTime}");
        }

        sb.AppendLine();
        sb.AppendLine("Basado en estos datos, responde la siguiente pregunta que te hace el usuario sobre finanzas y economía. No respondas la pregunta si el usuario te dice algo no relacionado a finanzas/economía. Si tienes que devolver un monto en específico, hazlo en el siguiente formato: $12,345.67, si tienes que devolver un porcentaje, hazlo en el siguiente formato: %12.34. Usa la coma (,) como separador y el punto como inicio de decimal, no debes exceder de los dos digitos despues del punto decimal. Formato de la respuesta:");
        sb.AppendLine("{ \"aiResponse\": \"\" }");

        sb.AppendLine();
        sb.AppendLine($"ESTE ES EL PROMPT DEL USUARIO: {prompt}");

        if (english) sb.AppendLine("RESPONDE EN INGLÉS");
        return sb.ToString();
    }

    public async Task<string> BuildSuggestionsPrompt(Guid userId, bool english = true)
    {
        DateTime now = DateTime.UtcNow;
        DateTime start = now.AddMonths(-12);

        var earningsByCategory = await _context.Transactions
            .Include(t => t.Category)
            .Where(t => t.UserId == userId &&
                        t.DateTime >= start &&
                        t.DateTime <= now &&
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
                        t.DateTime >= start &&
                        t.DateTime <= now &&
                        !t.Category!.IsEarningCategory)
            .GroupBy(t => t.Category!.Name)
            .Select(g => new
            {
                CategoryName = g.Key,
                TotalAmount = g.Sum(t => t.Amount)
            })
            .OrderByDescending(c => c.TotalAmount)
            .ToListAsync();

        StringBuilder sb = new StringBuilder();
        sb.AppendLine("Este es el resumen de gastos e ingresos del usuario por categoría:");
        sb.AppendLine("Ingresos:");
        foreach (var earn in earningsByCategory)
        {
            sb.AppendLine($"{earn.CategoryName} +{earn.TotalAmount}");
        }
        sb.AppendLine("Gastos:");
        foreach (var exp in expensesByCategory)
        {
            sb.AppendLine($"{exp.CategoryName} -{exp.TotalAmount}");
        }

        sb.AppendLine();
        sb.AppendLine("Basado en estos datos, dame 1 sugerencia principal y 3 sugerencias secundarias para que el usuario administre mejor su dinero. Formato:");
        sb.AppendLine("{ \"mainSuggestion\": \"\", \"sideSuggestions\": [\"Esta es la sugerencia secundaria 1\",\"Esta es la sugerencia secundaria 2\",\"Esta es la sugerencia secundaria 3\"]");

        if (english) sb.AppendLine("RESPONDE EN INGLÉS");
        return sb.ToString();
    }

    public async Task<string> BuildPredictionsPrompt(Guid userId, bool english = true)
    {
        DateTime now = DateTime.UtcNow;
        DateTime start = now.AddMonths(-12);

        var earningsByCategory = await _context.Transactions
            .Include(t => t.Category)
            .Where(t => t.UserId == userId &&
                        t.DateTime >= start &&
                        t.DateTime <= now &&
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
                        t.DateTime >= start &&
                        t.DateTime <= now &&
                        !t.Category!.IsEarningCategory)
            .GroupBy(t => t.Category!.Name)
            .Select(g => new
            {
                CategoryName = g.Key,
                TotalAmount = g.Sum(t => t.Amount)
            })
            .OrderByDescending(c => c.TotalAmount)
            .ToListAsync();

        StringBuilder sb = new StringBuilder();
        sb.AppendLine("Este es el resumen de gastos e ingresos del usuario por categoría:");
        sb.AppendLine("Ingresos:");
        foreach (var earn in earningsByCategory)
        {
            sb.AppendLine($"{earn.CategoryName} +{earn.TotalAmount}");
        }
        sb.AppendLine("Gastos:");
        foreach (var exp in expensesByCategory)
        {
            sb.AppendLine($"{exp.CategoryName} -{exp.TotalAmount}");
        }

        sb.AppendLine();
        sb.AppendLine("Basado en estos datos, dame una predición principal y 3 predicciones secundarias para que el usuario tenga una idea de como estará su balance económico en 1 - 3 meses. Basado en los datos que tienes, trata de usar porcentajes o montos, aunque no los uses si no estás seguro de lo que dirás. Formato:");
        sb.AppendLine("{ \"mainPrediction\": \"\", \"sidePredictions\": [\"Esta es la predicción secundaria 1\",\"Esta es la predicción secundaria 2\",\"Esta es la predicción secundaria 3\"]");

        if (english) sb.AppendLine("RESPONDE EN INGLÉS");
        return sb.ToString();
    }
}
