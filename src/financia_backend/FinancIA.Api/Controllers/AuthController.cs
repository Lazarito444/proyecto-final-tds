using FinancIA.Core.Application.Dtos.Auth;
using FinancIA.Infrastructure.Persistence.Entities;
using FluentValidation;
using FluentValidation.Results;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using SignInResult = Microsoft.AspNetCore.Identity.SignInResult;

namespace FinancIA.Api.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AuthController : ControllerBase
    {
        private readonly UserManager<ApplicationUser> _userManager;
        private readonly SignInManager<ApplicationUser> _signInManager;

        public AuthController(UserManager<ApplicationUser> userManager, SignInManager<ApplicationUser> signInManager)
        {
            _userManager = userManager;
            _signInManager = signInManager;
        }

        [HttpPost("authenticate")]
        public async Task<IActionResult> Authenticate([FromBody] LoginRequest request, [FromServices] IValidator<LoginRequest> validator)
        {
            ValidationResult validationResult = await validator.ValidateAsync(request);
            if (!validationResult.IsValid)
            {
                return BadRequest(validationResult.Errors);
            }

            ApplicationUser? user = await _userManager.FindByEmailAsync(request.Email);
            if (user == null)
            {
                return BadRequest("Wrong credentials");
            }

            SignInResult signInResult = await _signInManager.CheckPasswordSignInAsync(user, request.Password, lockoutOnFailure: false);
            if (!signInResult.Succeeded)
            {
                return BadRequest("Wrong credentials");
            }



            return Ok();
        }

        private string GenerateJwt(int userId)
        {
            return "";
        }

        private string GenerateRefreshToken(int userId)
        {
            return "";
        }

    }
}
