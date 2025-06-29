using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FinancIA.Core.Application.Dtos
{
    public class RegisterDTO
    {
        [Required(ErrorMessage = "Nombre no puede estar vacio")]
        public string PersonName { get; set; } = string.Empty;

        [Required(ErrorMessage = "Email no puede estar vacio")]
        [EmailAddress(ErrorMessage = "El email debe estar en un formato existente")]
        [Remote("IsEmailAlreadyRegister", controller: "Account", ErrorMessage = "Este correo ya esta usado")]
        public string Email { get; set; } = string.Empty;

        [Required(ErrorMessage = "El número de teléfono no puede estar vacío")]
        [RegularExpression("^[0-9]+$", ErrorMessage = "El número de teléfono debe contener solo dígitos")]
        public string PhoneNumber { get; set; } = string.Empty;

        [Required(ErrorMessage = "Escriba una clave")]
        public string Password { get; set; } = string.Empty;

        [Required(ErrorMessage = "Confirme su clave")]
        [Compare("Password", ErrorMessage = "Su Clave No coinciden")]
        public string ConfirmPassword { get; set; } = string.Empty;

    }
}
