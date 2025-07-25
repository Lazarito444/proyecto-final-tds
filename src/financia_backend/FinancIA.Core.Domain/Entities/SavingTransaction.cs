﻿namespace FinancIA.Core.Domain.Entities;
public class SavingTransaction
{
    public Guid Id { get; set; } = Guid.NewGuid();
    public Guid SavingId { get; set; }
    public decimal Amount { get; set; }
    public DateTime DateTime { get; set; }
    public string? Note { get; set; }
    public Saving Saving { get; set; }
}
