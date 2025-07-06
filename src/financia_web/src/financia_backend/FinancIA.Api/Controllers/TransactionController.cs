using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;

namespace FinancIA.API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    [Authorize] // Requiere token JWT
    public class TransactionController : ControllerBase
    {
        [HttpGet("test")]
        public IActionResult GetMockTransactions()
        {
            var transactions = new List<Transaction>
            {
                new Transaction
                {
                    Id = Guid.NewGuid(),
                    UserId = Guid.Parse("11111111-1111-1111-1111-111111111111"),
                    CategoryId = Guid.Parse("22222222-2222-2222-2222-222222222222"),
                    Description = "Pago de salario",
                    Amount = 1200.00m,
                    DateTime = DateTime.UtcNow,
                    IsEarning = true,
                    Category = new Category
                    {
                        Id = Guid.Parse("22222222-2222-2222-2222-222222222222"),
                        Name = "Ingresos"
                    }
                },
                new Transaction
                {
                    Id = Guid.NewGuid(),
                    UserId = Guid.Parse("11111111-1111-1111-1111-111111111111"),
                    CategoryId = Guid.Parse("33333333-3333-3333-3333-333333333333"),
                    Description = "Compra en supermercado",
                    Amount = -150.75m,
                    DateTime = DateTime.UtcNow.AddDays(-1),
                    IsEarning = false,
                    Category = new Category
                    {
                        Id = Guid.Parse("33333333-3333-3333-3333-333333333333"),
                        Name = "Gastos"
                    }
                }
            };

            return Ok(transactions);
        }
    }

    public class Transaction
    {
        public Guid Id { get; set; }
        public Guid UserId { get; set; }
        public Guid CategoryId { get; set; }
        public string Description { get; set; }
        public decimal Amount { get; set; }
        public DateTime DateTime { get; set; }
        public Category Category { get; set; }
        public bool IsEarning { get; set; }
    }

    public class Category
    {
        public Guid Id { get; set; }
        public string Name { get; set; }
    }
}