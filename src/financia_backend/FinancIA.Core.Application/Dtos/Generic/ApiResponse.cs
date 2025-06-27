namespace FinancIA.Core.Application.Dtos.Generic;
public class ApiResponse<T>
{
    public bool Success { get; private set; }
    public T? Data { get; private set; }
    public string? Message { get; private set; }

    private ApiResponse()
    {

    }

    static ApiResponse<T> Ok(T data, string? message = null)
    {
        return new ApiResponse<T>()
        {
            Success = true,
            Data = data,
            Message = message
        };
    }

    static ApiResponse<string> Fail(T data, string? message = null)
    {
        return new ApiResponse<string>()
        {
            Success = false,
            Message = message
        };
    }
}
