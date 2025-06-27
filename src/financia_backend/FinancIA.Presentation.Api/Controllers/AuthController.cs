using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using FinancIA.Core.Application.Contracts.Services;
using FinancIA.Core.Application.Dtos.Auth;
using FinancIA.Core.Application.Identity;
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
    private readonly IJwtService _jwtService;

    public AuthController(IJwtService jwtService, UserManager<ApplicationUser> userManager, SignInManager<ApplicationUser> signInManager)
    {
        _jwtService = jwtService;
        _userManager = userManager;
        _signInManager = signInManager;
    }

    [HttpPost("authenticate")]
    public async Task<IActionResult> Authenticate([FromBody] AuthenticateRequest request, [FromServices] IValidator<AuthenticateRequest> validator)
    {
        ValidationResult validationResult = await validator.ValidateAsync(request);
        if (!validationResult.IsValid)
        {
            return BadRequest(validationResult.Errors);
        }

        ApplicationUser? user = await _userManager.FindByEmailAsync(request.Email);

        if (user is null) return BadRequest("Credenciales incorrectas");

        SignInResult result = await _signInManager.CheckPasswordSignInAsync(user, request.Password, lockoutOnFailure: false);

        if (!result.Succeeded) return BadRequest("Credenciales incorrectas");

        Claim[] claims =
        [
            new Claim(JwtRegisteredClaimNames.Sub, user.Id.ToString()),
            new Claim(JwtRegisteredClaimNames.Email, user.Email),
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
            return BadRequest(validationResult.Errors);
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
            string errorMessages = string.Join(" | ", result.Errors.Select(e => e.Description));
            return BadRequest("Algo salió mal: " + errorMessages);
        }

        Claim[] claims =
        [
            new Claim(JwtRegisteredClaimNames.Sub, newUser.Id.ToString()),
            new Claim(JwtRegisteredClaimNames.Email, newUser.Email),
            new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()),
            new Claim(JwtRegisteredClaimNames.Name, newUser.FullName)
        ];

        SystemTokens tokens = await _jwtService.GenerateTokens(newUser.Id, claims);
        return Ok(tokens);
    }

    [HttpPost("refresh")]
    public async Task<IActionResult> Refresh([FromBody] SystemTokens request)
    {
        ClaimsPrincipal principal = _jwtService.GetPrincipalFromExpiredToken(request.AccessToken);
        string? userIdString = principal.FindFirstValue(JwtRegisteredClaimNames.Sub);

        if (userIdString == null) return BadRequest("Access token inválido");

        Guid userId = Guid.Parse(userIdString);
        ApplicationUser? user = await _userManager.Users.FirstOrDefaultAsync(u => u.Id == userId);

        if (user == null) return Unauthorized("Refresh token inválido");

        if (!await _jwtService.CheckUserToken(userId, request.RefreshToken)) return Unauthorized("Refresh token expirado o revocado");

        SystemTokens tokens = await _jwtService.GenerateTokens(userId, principal.Claims.ToArray());
        return Ok(tokens);
    }
}
