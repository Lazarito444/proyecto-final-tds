namespace FinancIA.Core.Application.Contracts.Services;
public interface IAiService
{
    public Task<string> BuildChatWithAiPrompt(Guid userId, string prompt, bool english);

    public Task<string> BuildSuggestionsPrompt(Guid userId, bool english = true);

    public Task<string> BuildPredictionsPrompt(Guid userId, bool english = true);
}
