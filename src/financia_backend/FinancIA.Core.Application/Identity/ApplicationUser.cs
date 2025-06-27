using Microsoft.AspNetCore.Identity;

namespace FinancIA.Core.Application.Identity;
public class ApplicationUser : IdentityUser<Guid>
{
    public string FullName { get; set; }
}
