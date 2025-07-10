using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FinancIA.Core.Application.Dtos
{
    public class LoginDTO
    {

        [Required(ErrorMessage = "Email no puede estar vacio")]
        [EmailAddress(ErrorMessage = "El email debe estar en un formato existente")]
        public string Email { get; set; } = string.Empty;


        [Required(ErrorMessage = "Escriba una clave")]
        public string Password { get; set; } = string.Empty;
    }
}
