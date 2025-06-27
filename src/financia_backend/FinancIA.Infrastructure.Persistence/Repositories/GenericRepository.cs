using System.Linq.Expressions;
using FinancIA.Core.Application.Contracts.Repositories;
using Microsoft.EntityFrameworkCore;

namespace FinancIA.Infrastructure.Persistence.Repositories;

public class GenericRepository<TEntity> : IGenericRepository<TEntity>
    where TEntity : class
{
    private readonly ApplicationDbContext _context;

    public GenericRepository(ApplicationDbContext context)
    {
        _context = context;
    }

    public async Task<TEntity?> GetByIdAsync(Guid id)
    {
        TEntity? entity = await _context.Set<TEntity>().FindAsync(id);
        return entity;
    }

    public async Task<List<TEntity>> GetAllAsync()
    {
        List<TEntity> entities = await _context.Set<TEntity>().ToListAsync();
        return entities;
    }

    public async Task<TEntity> SaveAsync(TEntity entity)
    {
        await _context.Set<TEntity>().AddAsync(entity);
        await _context.SaveChangesAsync();
        return entity;
    }

    public async Task<bool> AnyAsync(Expression<Func<TEntity, bool>> func)
    {
        return await _context.Set<TEntity>().AnyAsync(func);
    }

    public async Task<TEntity?> GetBySpec(Expression<Func<TEntity, bool>> func)
    {
        return await _context.Set<TEntity>().FirstOrDefaultAsync(func);
    }

    public async Task<bool> DeleteAsync(TEntity entity)
    {
        try
        {
            _context.Set<TEntity>().Remove(entity);
            await _context.SaveChangesAsync();
            return true;
        }
        catch (Exception)
        {
            return false;
        }
    }
}
