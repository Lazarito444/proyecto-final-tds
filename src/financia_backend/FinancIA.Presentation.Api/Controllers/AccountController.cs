using FinancIA.Core.Application.Dtos.Account;
using FinancIA.Core.Application.Identity;
using FinancIA.Core.Domain.Enums;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace FinancIA.Presentation.Api.Controllers;

[Authorize]
[ApiController]
[Route("api/account")]
public class AccountController : ControllerBase
{
    private readonly UserManager<ApplicationUser> _userManager;

    public AccountController(UserManager<ApplicationUser> userManager)
    {
        _userManager = userManager;
    }

    [HttpGet("{id}")]
    public async Task<IActionResult> GetAccountInfo([FromRoute] Guid id)
    {
        ApplicationUser? user = await _userManager.Users.FirstOrDefaultAsync(u => u.Id == id);

        if (user is null) return NotFound();

        return Ok(new
        {
            id,
            user.FullName,
            user.DateOfBirth,
            user.Email,
            user.Gender,
            ImagePath = $"{Request.Scheme}://{Request.Host.Value}/{user.ImagePath}"
        });
    }

    [HttpPut("{id}")]
    public async Task<IActionResult> UpdateAccountInfo([FromRoute] Guid id, [FromForm] UpdateAccountRequest request)
    {
        ApplicationUser? user = await _userManager.Users.FirstOrDefaultAsync(u => u.Id == id);

        if (user is null) return NotFound();

        if (request.FullName is not null) user.FullName = request.FullName;
        if (request.DateOfBirth is not null) user.DateOfBirth = request.DateOfBirth;
        if (request.Gender is not null) user.Gender = (Gender)request.Gender;

        IdentityResult result = await _userManager.UpdateAsync(user);
        if (!result.Succeeded) return BadRequest("Algo salió mal al actualizar el usuario");

        if (request.Password is not null && request.CurrentPassword is not null)
        {
            result = await _userManager.ChangePasswordAsync(user, request.CurrentPassword, request.Password);
            if (!result.Succeeded) return BadRequest("Algo salió mal al actualizar la contraseña");
        }

        if (request.PhotoFile is not null)
        {
            user.ImagePath = UploadPhoto(id, request.PhotoFile);
            await _userManager.UpdateAsync(user);
        }


        return Ok(new
        {
            user.Id,
            user.FullName,
            user.DateOfBirth,
            user.Email,
            user.Gender,
            ImagePath = $"{Request.Scheme}://{Request.Host.Value}/{user.ImagePath}"
        });
    }

    private string UploadPhoto(Guid id, IFormFile file)
    {
        string[] allowedExtensions = [".jpg", ".png", ".jpeg"];
        string extension = Path.GetExtension(file.FileName).ToLowerInvariant();

        if (string.IsNullOrEmpty(extension) || !allowedExtensions.Contains(extension))
        {
            throw new InvalidOperationException("Solo se permiten imágenes JPG y PNG.");
        }

        const long maxSizeInBytes = 10 * 1024 * 1024;
        if (file.Length > maxSizeInBytes)
        {
            throw new InvalidOperationException("El archivo excede el tamaño máximo permitido de 10 MB.");
        }

        string baseFolder = Path.Combine(Directory.GetCurrentDirectory(), "images", id.ToString());

        if (!Directory.Exists(baseFolder))
        {
            Directory.CreateDirectory(baseFolder);
        }
        // Crear nombre único para la imagen
        string fileName = $"{Guid.NewGuid()}{extension}";
        string fullPath = Path.Combine(baseFolder, fileName);

        // Guardar el archivo físicamente
        using (FileStream stream = new FileStream(fullPath, FileMode.Create))
        {
            file.CopyTo(stream);
        }

        // Ruta relativa que puedes guardar en base de datos
        string relativePath = Path.Combine("images", id.ToString(), fileName);

        return relativePath.Replace("\\", "/");
    }
}
