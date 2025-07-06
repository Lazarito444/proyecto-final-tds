using FinancIA.Core.Domain.Exceptions;

namespace FinancIA.Presentation.Api.Middlewares;

public class ExceptionMiddleware
{
    private readonly RequestDelegate _next;

    public ExceptionMiddleware(RequestDelegate next)
    {
        _next = next;
    }

    public async Task InvokeAsync(HttpContext context)
    {
        try
        {
            await _next(context);
        }
        catch (ApiException apiException)
        {
            context.Response.StatusCode = apiException.StatusCode;
            await context.Response.WriteAsJsonAsync(new
            {
                StatusCode = apiException.StatusCode,
                Message = apiException.Message,
            });
        }
        catch (Exception ex)
        {
            context.Response.StatusCode = 500;
            await context.Response.WriteAsJsonAsync(new
            {
                StatusCode = 500,
                Message = ex.Message,
            });
        }
    }
}
