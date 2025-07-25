using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using FinancIA.Core.Application.Contracts.Services;
using FinancIA.Core.Application.Dtos.Auth;
using FinancIA.Core.Application.Identity;
using FinancIA.Core.Domain.Entities;
using FinancIA.Infrastructure.Persistence;
using FluentValidation;
using FluentValidation.Results;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using SignInResult = Microsoft.AspNetCore.Identity.SignInResult;

namespace FinancIA.Presentation.Api.Controllers;

[Route("api/auth")]
[ApiController]
public class AuthController : ControllerBase
{
    private readonly UserManager<ApplicationUser> _userManager;
    private readonly SignInManager<ApplicationUser> _signInManager;
    private readonly ApplicationDbContext _context;
    private readonly IJwtService _jwtService;

    public AuthController(IJwtService jwtService, UserManager<ApplicationUser> userManager, SignInManager<ApplicationUser> signInManager, ApplicationDbContext context)
    {
        _jwtService = jwtService;
        _userManager = userManager;
        _signInManager = signInManager;
        _context = context;
    }

    [HttpPost("authenticate")]
    public async Task<IActionResult> Authenticate([FromBody] AuthenticateRequest request, [FromServices] IValidator<AuthenticateRequest> validator)
    {
        ValidationResult validationResult = await validator.ValidateAsync(request);
        if (!validationResult.IsValid)
        {
            return BadRequest(new
            {
                StatusCode = StatusCodes.Status400BadRequest,
                Message = string.Join(", ", validationResult.Errors.Select(e => e.ErrorMessage))
            });
        }

        ApplicationUser? user = await _userManager.FindByEmailAsync(request.Email);

        if (user is null) return Unauthorized("Credenciales incorrectas");

        SignInResult result = await _signInManager.CheckPasswordSignInAsync(user, request.Password, lockoutOnFailure: false);

        if (!result.Succeeded) return Unauthorized("Credenciales incorrectas");

        Claim[] claims =
        [
            new Claim(JwtRegisteredClaimNames.Sub, user.Id.ToString()),
            new Claim(JwtRegisteredClaimNames.Email, user.Email!),
            new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()),
            new Claim(JwtRegisteredClaimNames.Name, user.FullName)
        ];

        SystemTokens tokens = await _jwtService.GenerateTokens(user.Id, claims);
        return Ok(tokens);
    }

    [HttpPost("register")]
    public async Task<IActionResult> SignUp([FromBody] SignUpRequest request, [FromServices] IValidator<SignUpRequest> validator)
    {
        ValidationResult validationResult = await validator.ValidateAsync(request);
        if (!validationResult.IsValid)
        {
            return BadRequest(new
            {
                StatusCode = StatusCodes.Status400BadRequest,
                Message = string.Join(", ", validationResult.Errors.Select(e => e.ErrorMessage))
            });
        }

        ApplicationUser newUser = new ApplicationUser
        {
            Id = Guid.NewGuid(),
            Email = request.Email,
            EmailConfirmed = true,
            FullName = request.FullName,
            UserName = request.Email
        };

        IdentityResult result = await _userManager.CreateAsync(newUser, request.Password);
        if (!result.Succeeded)
        {
            return BadRequest(new
            {
                StatusCode = StatusCodes.Status400BadRequest,
                Message = string.Join(", ", validationResult.Errors.Select(e => e.ErrorMessage))
            });
        }

        Claim[] claims =
        [
            new Claim(JwtRegisteredClaimNames.Sub, newUser.Id.ToString()),
            new Claim(JwtRegisteredClaimNames.Email, newUser.Email),
            new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()),
            new Claim(JwtRegisteredClaimNames.Name, newUser.FullName)
        ];

        SystemTokens tokens = await _jwtService.GenerateTokens(newUser.Id, claims);

        _ = SeedDefaultCategoriesAsync(newUser.Id);
        return Ok(tokens);
    }

    [HttpPost("refresh")]
    public async Task<IActionResult> Refresh([FromBody] SystemTokens request)
    {
        ClaimsPrincipal principal = _jwtService.GetPrincipalFromExpiredToken(request.AccessToken);
        string? userIdString = principal.FindFirstValue(JwtRegisteredClaimNames.Sub);

        if (userIdString == null) return Unauthorized("Access token inválido");

        Guid userId = Guid.Parse(userIdString);
        ApplicationUser? user = await _userManager.Users.FirstOrDefaultAsync(u => u.Id == userId);

        if (user == null) return Unauthorized("Refresh token inválido");

        if (!await _jwtService.CheckUserToken(userId, request.RefreshToken)) return Unauthorized("Refresh token expirado o revocado");

        SystemTokens tokens = await _jwtService.GenerateTokens(userId, principal.Claims.ToArray());
        return Ok(tokens);
    }

    [HttpPost("logout")]
    public async Task<IActionResult> Logout()
    {
        string? userIdString = User.FindFirstValue(JwtRegisteredClaimNames.Sub);

        if (userIdString == null) return Unauthorized("Access token inválido");

        Guid userId = Guid.Parse(userIdString);

        await _jwtService.RemoveUserRefreshTokens(userId);

        return NoContent();
    }

    private async Task SeedDefaultCategoriesAsync(Guid userId)
    {
        List<Category> categories = new List<Category>
        {
            new Category { Name = "Food", IsEarningCategory = false, ColorHex = "#FF6F00", IconName = "local_restaurant", UserId = userId },
            new Category { Name = "Transport", IsEarningCategory = false, ColorHex = "#455A64", IconName = "directions_car", UserId = userId },
            new Category { Name = "Salary", IsEarningCategory = true, ColorHex = "#2E7D32", IconName = "attach_money", UserId = userId },
            new Category { Name = "Extra", IsEarningCategory = true, ColorHex = "#1976D2", IconName = "savings", UserId = userId }
        };

        await _context.Categories.AddRangeAsync(categories);
        await _context.SaveChangesAsync();
    }
}
