﻿namespace FinancIA.Core.Domain.Entities;
public class Saving
{
    public Guid Id { get; set; } = Guid.NewGuid();
    public Guid UserId { get; set; }
    public string Name { get; set; }
    public decimal GoalAmount { get; set; }
    public decimal CurrentAmount { get; set; }
    public DateOnly? Deadline { get; set; }
    public bool Finished => CurrentAmount >= GoalAmount;
}
