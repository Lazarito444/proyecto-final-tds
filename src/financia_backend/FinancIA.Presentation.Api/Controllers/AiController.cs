using System.IdentityModel.Tokens.Jwt;
using System.Net.Http.Headers;
using System.Security.Claims;
using System.Text;
using System.Text.Json;
using FinancIA.Core.Application.Contracts.Services;
using FinancIA.Core.Application.Dtos.Ai;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace FinancIA.Presentation.Api.Controllers;

[Authorize]
[ApiController]
[Route("api/ai")]
public class AiController : ControllerBase
{
    private readonly IAiService _aiService;
    private readonly HttpClient _client;
    public AiController(IHttpClientFactory httpClientFactory, IAiService aiService)
    {
        _client = httpClientFactory.CreateClient();
        _aiService = aiService;
    }

    [HttpGet("suggestions")]
    public async Task<IActionResult> GetAiSuggestions([FromQuery] string lang)
    {
        bool english = lang == "en";
        Guid userId = Guid.Parse(User.FindFirstValue(JwtRegisteredClaimNames.Sub)!);
        string prompt = await _aiService.BuildSuggestionsPrompt(userId, english);

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
        string prompt = await _aiService.BuildPredictionsPrompt(userId, english);

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
        string prompt = await _aiService.BuildChatWithAiPrompt(userId, req.Prompt, english);

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
}
