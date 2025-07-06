using FinancIA.Core.Application.Dtos;
using FinancIA.Core.Application.Identity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FinancIA.Core.Application.ServiceContracts
{
    public interface IJwtService
    {
        AuthenticationReponse CreateJwtToken(ApplicationUser user);
    }
}
