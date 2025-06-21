using FinancIA.Core.Application.Dtos;
using FinancIA.Core.Application.Identity;
using FinancIA.Core.Application.ServiceContracts;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;

namespace FinancIA.Api.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class AccountController : Controller
    {

        private readonly UserManager<ApplicationUser> _userManager;
        private readonly SignInManager<ApplicationUser> _signInManager;
        private readonly RoleManager<ApplicationRole> _roleManager;
        private readonly IJwtService _jwtService;

        public AccountController(UserManager<ApplicationUser> userManager, SignInManager<ApplicationUser> signInManager, RoleManager<ApplicationRole> roleManager, IJwtService jwtService)
        {
            _userManager = userManager;
            _signInManager = signInManager;
            _roleManager = roleManager;
            _jwtService = jwtService;
        }

        [HttpPost("register")]
        public async Task<ActionResult<ApplicationUser>> PostRegister(RegisterDTO registerDTO)
        {
            //Validation
            if(ModelState.IsValid == false)
            {
                string errorMessage = string.Join(" | ", ModelState.Values.SelectMany(V => V.Errors).Select(e => e.ErrorMessage));
                return Problem(errorMessage);

            }

            //Create User
            ApplicationUser user = new ApplicationUser()
            {
                Email = registerDTO.Email,
                PhoneNumber = registerDTO.PhoneNumber,
                UserName = registerDTO.Email,
                PersonName = registerDTO.PersonName,

            };

            IdentityResult result = await  _userManager.CreateAsync(user, registerDTO.Password);

            if (result.Succeeded)
            {
                //sign-in
                _signInManager.SignInAsync(user, isPersistent: false);
               var authenticationReponse = _jwtService.CreateJwtToke(user);
                return Ok(authenticationReponse);
            }
            else { 
            string errorMessage = string.Join(" | ",result.Errors.Select(e=> e.Description));
                return Problem(errorMessage);
            }
        }
        [HttpGet]
        public async Task<ActionResult> IsEmailAlreadyRegister(string email)
        {
          ApplicationUser? user = await _userManager.FindByEmailAsync(email);

            if (user == null) {
                return Ok(true);
            }
            else
            {
                return Ok(false);   
            }
        }


        [HttpPost("Login")]
        public async Task<ActionResult<ApplicationUser>> PostLogin(LoginDTO loginDTO)
        {
            if (ModelState.IsValid == false)
            {
                string errorMessage = string.Join(" | ", ModelState.Values.SelectMany(V => V.Errors).Select(e => e.ErrorMessage));
                return Problem(errorMessage);

            }

            var result = await _signInManager.PasswordSignInAsync(loginDTO.Email, loginDTO.Password, isPersistent: false, lockoutOnFailure: false);

            if (result.Succeeded) 
            {

                ApplicationUser? user = await _userManager.FindByEmailAsync(loginDTO.Email);

                if (user == null) 
                { 
                return NoContent(); 
                }
                //sign-in
                _signInManager.SignInAsync(user, isPersistent: false);
                var authenticationReponse = _jwtService.CreateJwtToke(user);
                return Ok(authenticationReponse);

            }
            else
            {
                return Problem("Correo o clave invalida");
            }
        }



        [HttpGet("Logout")]
        public async Task<IActionResult> GetLogout()
        {
            await _signInManager.SignOutAsync();
            return NoContent();

        }


    }
}
