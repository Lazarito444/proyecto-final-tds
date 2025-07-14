using System.IdentityModel.Tokens.Jwt;
using FinancIA.Core.Application.Extensions;
using FinancIA.Core.Domain.Settings;
using FinancIA.Infrastructure.Persistence.Extensions;
using FinancIA.Presentation.Api.Extensions;
using FinancIA.Presentation.Api.Middlewares;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.FileProviders;

WebApplicationBuilder builder = WebApplication.CreateBuilder(args);

JwtSecurityTokenHandler.DefaultMapInboundClaims = false;

builder.Services.AddApplicationLayer();
builder.Services.AddPersistenceLayer(builder.Configuration);
builder.Services.Configure<JwtSettings>(builder.Configuration.GetRequiredSection(nameof(JwtSettings)));
builder.Services.Configure<ApiBehaviorOptions>(opt => opt.SuppressModelStateInvalidFilter = true);
builder.Services.SetupCors();
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.SetupAuthentication(builder.Configuration);
builder.Services.AddAuthorization();
builder.Services.AddSwaggerGen();
builder.Services.SetupSwagger();
SetupImagesFolder();

WebApplication app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI(opt =>
    {
        opt.EnablePersistAuthorization();
    });
}

//app.UseHttpsRedirection();
app.UseCors("AllowAll");

app.UseStaticFiles(new StaticFileOptions
{
    FileProvider = new PhysicalFileProvider(Path.Combine(Directory.GetCurrentDirectory(), "images")),
    RequestPath = "/images",
});

app.UseMiddleware<ExceptionMiddleware>();

app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();

app.Run();


void SetupImagesFolder()
{
    if (!Directory.Exists(Path.Combine(Directory.GetCurrentDirectory(), "images")))
    {
        Directory.CreateDirectory(Path.Combine(Directory.GetCurrentDirectory(), "images"));
    }
}