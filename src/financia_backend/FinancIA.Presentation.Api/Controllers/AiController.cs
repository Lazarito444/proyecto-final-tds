using System.IdentityModel.Tokens.Jwt;
using System.Net.Http.Headers;
using System.Security.Claims;
using System.Text;
using System.Text.Json;
using FinancIA.Core.Application.Dtos.Ai;
using FinancIA.Infrastructure.Persistence;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace FinancIA.Presentation.Api.Controllers;

[Authorize]
[ApiController]
[Route("api/ai")]
public class AiController : ControllerBase
{
    private readonly ApplicationDbContext _context;
    private readonly HttpClient _client;
    public AiController(ApplicationDbContext context, IHttpClientFactory httpClientFactory)
    {
        _context = context;
        _client = httpClientFactory.CreateClient();
    }

    [HttpGet("suggestions")]
    public async Task<IActionResult> GetAiSuggestions([FromQuery] string lang)
    {
        bool english = lang == "en";
        Guid userId = Guid.Parse(User.FindFirstValue(JwtRegisteredClaimNames.Sub)!);
        string prompt = await BuildSuggestionsPrompt(userId, english);

        string? openAiApiKey = Environment.GetEnvironmentVariable("FinancIAKey", EnvironmentVariableTarget.Machine);
        if (string.IsNullOrEmpty(openAiApiKey))
        {
            return StatusCode(500, "API Key de OpenAI no configurada.");
        }

        var requestContent = new
        {
            model = "gpt-4.1-nano",
            messages = new[]
            {
                new { role = "system", content = "Eres un asesor financiero profesional." },
                new { role = "user", content = prompt }
            },
            max_tokens = 1000,
            temperature = 0.5
        };

        using var request = new HttpRequestMessage(HttpMethod.Post, "https://api.openai.com/v1/chat/completions");
        request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", openAiApiKey);
        request.Content = new StringContent(JsonSerializer.Serialize(requestContent), Encoding.UTF8, "application/json");

        HttpResponseMessage response = await _client.SendAsync(request);
        if (!response.IsSuccessStatusCode)
        {
            return StatusCode((int)response.StatusCode, "Error al consultar IA.");
        }

        string responseContent = await response.Content.ReadAsStringAsync();
        Console.WriteLine(responseContent);
        try
        {
            using JsonDocument jsonDoc = JsonDocument.Parse(responseContent);
            string aiText = jsonDoc.RootElement
                .GetProperty("choices")[0]
                .GetProperty("message")
                .GetProperty("content")
                .GetString()!;

            JsonDocument suggestionJson = JsonDocument.Parse(aiText);
            JsonElement root = suggestionJson.RootElement;

            string mainSuggestion = root.GetProperty("mainSuggestion").GetString() ?? "";
            List<string> sideSuggestions = root.GetProperty("sideSuggestions")
                                               .EnumerateArray()
                                               .Select(s => s.GetString() ?? "")
                                               .ToList();

            return Ok(new
            {
                MainSuggestion = mainSuggestion,
                SideSuggestions = sideSuggestions
            });
        }
        catch (Exception)
        {
            return Ok(new
            {
                MainSuggestion = responseContent,
                SideSuggestions = Array.Empty<string>()
            });
        }

    }

    [HttpGet("predictions")]
    public async Task<IActionResult> GetAiPredictions([FromQuery] string lang)
    {
        bool english = lang == "en";
        Guid userId = Guid.Parse(User.FindFirstValue(JwtRegisteredClaimNames.Sub)!);
        string prompt = await BuildPredictionsPrompt(userId, english);

        string? openAiApiKey = Environment.GetEnvironmentVariable("FinancIAKey", EnvironmentVariableTarget.Machine);
        if (string.IsNullOrEmpty(openAiApiKey))
        {
            return StatusCode(500, "API Key de OpenAI no configurada.");
        }

        var requestContent = new
        {
            model = "gpt-4.1-nano",
            messages = new[]
            {
                new { role = "system", content = "Eres un asesor financiero profesional." },
                new { role = "user", content = prompt }
            },
            max_tokens = 1000,
            temperature = 0.5
        };

        using var request = new HttpRequestMessage(HttpMethod.Post, "https://api.openai.com/v1/chat/completions");
        request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", openAiApiKey);
        request.Content = new StringContent(JsonSerializer.Serialize(requestContent), Encoding.UTF8, "application/json");

        HttpResponseMessage response = await _client.SendAsync(request);
        if (!response.IsSuccessStatusCode)
        {
            return StatusCode((int)response.StatusCode, "Error al consultar IA.");
        }

        string responseContent = await response.Content.ReadAsStringAsync();
        Console.WriteLine(responseContent);
        try
        {
            using JsonDocument jsonDoc = JsonDocument.Parse(responseContent);
            string aiText = jsonDoc.RootElement
                .GetProperty("choices")[0]
                .GetProperty("message")
                .GetProperty("content")
                .GetString()!;

            JsonDocument suggestionJson = JsonDocument.Parse(aiText);
            JsonElement root = suggestionJson.RootElement;

            string mainPrediction = root.GetProperty("mainPrediction").GetString() ?? "";
            List<string> sidePredictions = root.GetProperty("sidePredictions")
                                               .EnumerateArray()
                                               .Select(s => s.GetString() ?? "")
                                               .ToList();

            return Ok(new
            {
                MainPrediction = mainPrediction,
                SidePredictions = sidePredictions
            });
        }
        catch (Exception)
        {
            return Ok(new
            {
                MainPrediction = responseContent,
                SidePredictions = Array.Empty<string>()
            });
        }

    }

    [HttpPost("chatbot")]
    public async Task<IActionResult> ChatWithAi([FromQuery] string lang, [FromBody] ChatWithAiRequest req)
    {
        bool english = lang == "en";
        Guid userId = Guid.Parse(User.FindFirstValue(JwtRegisteredClaimNames.Sub)!);
        string prompt = await BuildChatWithAiPrompt(userId, req.Prompt, english);

        string? openAiApiKey = Environment.GetEnvironmentVariable("FinancIAKey", EnvironmentVariableTarget.Machine);
        if (string.IsNullOrEmpty(openAiApiKey))
        {
            return StatusCode(500, "API Key de OpenAI no configurada.");
        }

        var requestContent = new
        {
            model = "gpt-4.1-nano",
            messages = new[]
            {
                new { role = "system", content = "Eres un asesor financiero profesional." },
                new { role = "user", content = prompt }
            },
            max_tokens = 1000,
            temperature = 0.5
        };

        using var request = new HttpRequestMessage(HttpMethod.Post, "https://api.openai.com/v1/chat/completions");
        request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", openAiApiKey);
        request.Content = new StringContent(JsonSerializer.Serialize(requestContent), Encoding.UTF8, "application/json");

        HttpResponseMessage response = await _client.SendAsync(request);
        if (!response.IsSuccessStatusCode)
        {
            return StatusCode((int)response.StatusCode, "Error al consultar IA.");
        }

        string responseContent = await response.Content.ReadAsStringAsync();
        Console.WriteLine(responseContent);
        try
        {
            using JsonDocument jsonDoc = JsonDocument.Parse(responseContent);
            string aiText = jsonDoc.RootElement
                .GetProperty("choices")[0]
                .GetProperty("message")
                .GetProperty("content")
                .GetString()!;

            JsonDocument suggestionJson = JsonDocument.Parse(aiText);
            JsonElement root = suggestionJson.RootElement;

            string aiResponse = root.GetProperty("aiResponse").GetString() ?? "";


            return Ok(new
            {
                AiResponse = aiResponse
            });
        }
        catch (Exception)
        {
            return Ok(new
            {
                AiResponse = responseContent
            });
        }

    }

    private async Task<string> BuildChatWithAiPrompt(Guid userId, string prompt, bool english)
    {
        DateTime now = DateTime.UtcNow;
        DateTime start = now.AddMonths(-6);

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

    private async Task<string> BuildSuggestionsPrompt(Guid userId, bool english = true)
    {
        DateTime now = DateTime.UtcNow;
        DateTime start = now.AddMonths(-6);

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

    private async Task<string> BuildPredictionsPrompt(Guid userId, bool english = true)
    {
        DateTime now = DateTime.UtcNow;
        DateTime start = now.AddMonths(-6);

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
