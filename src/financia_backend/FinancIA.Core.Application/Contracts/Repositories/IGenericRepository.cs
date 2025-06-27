using System.Linq.Expressions;

namespace FinancIA.Core.Application.Contracts.Repositories;
public interface IGenericRepository<TEntity> where TEntity : class
{
    Task<TEntity?> GetByIdAsync(Guid id);
    Task<List<TEntity>> GetAllAsync();
    Task<TEntity> SaveAsync(TEntity entity);
    Task<bool> AnyAsync(Expression<Func<TEntity, bool>> func);
    Task<TEntity?> GetBySpec(Expression<Func<TEntity, bool>> func);
    Task<bool> DeleteAsync(TEntity entity);
}
