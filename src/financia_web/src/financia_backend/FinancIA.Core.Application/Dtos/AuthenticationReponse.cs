using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FinancIA.Core.Application.Dtos
{
    public class AuthenticationReponse
    {
        public string? PersonName { get; set; } = string.Empty;
        public string? Email { get; set; } = string.Empty;
        public string? Token { get; set; } = string.Empty;

        public DateTime? Expiration { get; set; } 
    }
}
