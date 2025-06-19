using FinancIA.Infrastructure.Persistence;
using FinancIA.Core.Application;
using FluentValidation;
using FinancIA.Core.Domain.Settings;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddPersistenceInfrastructure(builder.Configuration);
builder.Services.AddApplicationLayer();
builder.Services.AddValidatorsFromAssemblyContaining<Program>();
builder.Services.Configure<JwtSettings>(builder.Configuration.GetRequiredSection(nameof(JwtSettings)));
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();
