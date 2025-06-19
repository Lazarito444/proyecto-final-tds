using Microsoft.AspNetCore.Identity;

namespace FinancIA.Infrastructure.Persistence.Entities
{
    public class ApplicationUser : IdentityUser<int>
    {
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public DateOnly DateOfBirth { get; set; }
        public DateTime SignUpDate { get; set; }

    }
}
