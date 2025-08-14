// ignore_for_file: unnecessary_to_list_in_spreads

import 'package:flutter/material.dart';
import 'package:financia_mobile/extensions/theme_extensions.dart';
import 'package:financia_mobile/extensions/navigation_extensions.dart';
import 'package:financia_mobile/generated/l10n.dart';
import 'package:financia_mobile/models/budget_model.dart';
import 'package:financia_mobile/models/category_model.dart';
import 'package:financia_mobile/services/budget_service.dart';

class BudgetsScreen extends StatefulWidget {
  const BudgetsScreen({super.key});

  @override
  State<BudgetsScreen> createState() => _BudgetsScreenState();
}

class _BudgetsScreenState extends State<BudgetsScreen> {
  final BudgetService _budgetService = BudgetService();
  List<BudgetWithSpent> _budgetsWithSpent = [];
  List<Category> _categories = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final budgetsWithSpent = await _budgetService
          .getBudgetsWithSpentAmounts();
      final categories = await _budgetService.getAllCategories();

      setState(() {
        _budgetsWithSpent = budgetsWithSpent;
        _categories = categories;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Category? _getCategoryById(String categoryId) {
    try {
      return _categories.firstWhere((category) => category.id == categoryId);
    } catch (e) {
      return null;
    }
  }

  Map<String, dynamic> _budgetToUIFormat(BudgetWithSpent budgetWithSpent) {
    final category = _getCategoryById(budgetWithSpent.budget.categoryId);

    return {
      'id': budgetWithSpent.budget.id,
      'category': category?.name ?? 'Categoría desconocida',
      'budgetAmount': budgetWithSpent.budget.maximumAmount,
      'spentAmount': budgetWithSpent.spentAmount,
      'period': budgetWithSpent.budget.period,
      'icon': category != null
          ? Category.getIconFromName(category.iconName)
          : Icons.category,
      'isRecurring': budgetWithSpent.budget.isRecurring,
      'startDate': budgetWithSpent.budget.startDate,
      'endDate': budgetWithSpent.budget.endDate,
      'categoryId': budgetWithSpent.budget.categoryId,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.surface,
      appBar: AppBar(
        backgroundColor: context.colors.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.colors.onSurface),
          onPressed: () => context.pop(),
        ),
        title: Text(
          S.of(context).budget,
          style: context.textStyles.titleLarge?.copyWith(fontSize: 20),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: context.colors.primary),
            onPressed: () => _showBudgetDialog(),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? _buildErrorWidget()
          : RefreshIndicator(
              onRefresh: _loadData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBudgetSummaryCard(),
                    const SizedBox(height: 24),
                    Text(
                      S.of(context).budget_by_category,
                      style: context.textStyles.titleMedium?.copyWith(
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (_budgetsWithSpent.isEmpty)
                      _buildEmptyState()
                    else
                      ..._budgetsWithSpent
                          .map(
                            (budgetWithSpent) => _buildBudgetCard(
                              _budgetToUIFormat(budgetWithSpent),
                            ),
                          )
                          .toList(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: context.colors.error),
            const SizedBox(height: 16),
            Text(
              'Error al cargar los presupuestos',
              style: context.textStyles.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage ?? 'Error desconocido',
              style: context.textStyles.bodyMedium?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadData,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Icon(
            Icons.account_balance_wallet_outlined,
            size: 64,
            color: context.colors.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'No tienes presupuestos',
            style: context.textStyles.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Crea tu primer presupuesto para controlar tus gastos',
            style: context.textStyles.bodyMedium?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetSummaryCard() {
    final totalBudget = _budgetsWithSpent.fold<double>(
      0,
      (sum, budgetWithSpent) => sum + budgetWithSpent.budget.maximumAmount,
    );
    final totalSpent = _budgetsWithSpent.fold<double>(
      0,
      (sum, budgetWithSpent) => sum + budgetWithSpent.spentAmount,
    );
    final remaining = totalBudget - totalSpent;
    final progress = totalBudget > 0 ? totalSpent / totalBudget : 0.0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            context.colors.primary,
            context.colors.surfaceContainerLowest,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).total_budget,
            style: context.textStyles.labelMedium?.copyWith(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '\$${totalSpent.toStringAsFixed(2)}',
                    style: context.textStyles.titleLarge?.copyWith(
                      color: Colors.white,
                      fontSize: 28,
                    ),
                  ),
                  Text(
                    S.of(context).spent,
                    style: context.textStyles.labelSmall?.copyWith(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${remaining.toStringAsFixed(2)}',
                    style: context.textStyles.titleMedium?.copyWith(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    S.of(context).remaining,
                    style: context.textStyles.labelSmall?.copyWith(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.white,
            valueColor: AlwaysStoppedAnimation<Color>(
              progress > 1.0 ? Colors.red : Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${(progress * 100).toInt()}${S.of(context).percentage_total_budget}',
            style: context.textStyles.labelSmall?.copyWith(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetCard(Map<String, dynamic> budget) {
    final progress = budget['spentAmount'] / budget['budgetAmount'];
    final isOverBudget = progress > 1.0;
    final remaining = budget['budgetAmount'] - budget['spentAmount'];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colors.secondaryContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isOverBudget ? Colors.red : context.colors.outline,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: context.colors.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  budget['icon'] as IconData,
                  color: isOverBudget ? Colors.red : context.colors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      budget['category'] as String,
                      style: context.textStyles.titleSmall?.copyWith(
                        fontSize: 16,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          budget['period'] as String,
                          style: context.textStyles.labelSmall?.copyWith(
                            color: context.colors.outline,
                            fontSize: 12,
                          ),
                        ),
                        if (budget['isRecurring'] == true) ...[
                          const SizedBox(width: 8),
                          Icon(
                            Icons.repeat,
                            size: 12,
                            color: context.colors.outline,
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, color: context.colors.outline),
                onSelected: (value) => _handleBudgetAction(value, budget),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(
                          Icons.edit,
                          size: 20,
                          color: context.colors.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          S.of(context).edit,
                          style: context.textStyles.bodyMedium?.copyWith(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        const Icon(Icons.delete, size: 20, color: Colors.red),
                        const SizedBox(width: 8),
                        Text(
                          S.of(context).delete,
                          style: context.textStyles.bodyMedium?.copyWith(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '\$${budget['spentAmount'].toStringAsFixed(2)}',
                style: context.textStyles.titleSmall?.copyWith(
                  color: isOverBudget ? Colors.red : context.colors.primary,
                  fontSize: 16,
                ),
              ),
              Text(
                '\$${budget['budgetAmount'].toStringAsFixed(2)}',
                style: context.textStyles.labelSmall?.copyWith(
                  color: context.colors.outline,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress > 1.0 ? 1.0 : progress,
            backgroundColor: context.colors.surfaceContainerLow,
            valueColor: AlwaysStoppedAnimation<Color>(
              isOverBudget ? Colors.red : context.colors.primary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${(progress * 100).toInt()}${S.of(context).percentage_used}',
                style: context.textStyles.labelSmall?.copyWith(
                  color: context.colors.outline,
                  fontSize: 12,
                ),
              ),
              Text(
                isOverBudget
                    ? '${S.of(context).exceeded_by}: \$${(-remaining).toStringAsFixed(2)}'
                    : '${S.of(context).remaining}: \$${remaining.toStringAsFixed(2)}',
                style: context.textStyles.labelSmall?.copyWith(
                  color: isOverBudget ? Colors.red : context.colors.primary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _handleBudgetAction(String action, Map<String, dynamic> budget) {
    switch (action) {
      case 'edit':
        _showBudgetDialog(budget: budget);
        break;
      case 'delete':
        _showDeleteDialog(budget);
        break;
    }
  }

  void _showBudgetDialog({Map<String, dynamic>? budget}) {
    final isEditing = budget != null;
    String? selectedCategoryId = budget?['categoryId'];
    final amountController = TextEditingController(
      text: budget?['budgetAmount']?.toString() ?? '',
    );
    String selectedPeriod = budget?['period'] ?? 'Mensual';
    bool isRecurring = budget?['isRecurring'] ?? true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: context.colors.surface,
          title: Text(
            isEditing ? S.of(context).edit_budget : S.of(context).new_budget,
            style: context.textStyles.titleMedium?.copyWith(fontSize: 18),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: selectedCategoryId,
                  style: context.textStyles.bodyMedium?.copyWith(fontSize: 14),
                  decoration: InputDecoration(
                    labelText: S.of(context).category,
                    labelStyle: context.textStyles.bodyMedium?.copyWith(
                      fontSize: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: _categories.map((category) {
                    return DropdownMenuItem(
                      value: category.id,
                      child: Row(
                        children: [
                          Icon(
                            Category.getIconFromName(category.iconName),
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            category.name,
                            style: context.textStyles.bodyMedium?.copyWith(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setDialogState(() => selectedCategoryId = value);
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  style: context.textStyles.bodyMedium?.copyWith(fontSize: 14),
                  decoration: InputDecoration(
                    labelText: S.of(context).budgeted_amount,
                    labelStyle: context.textStyles.bodyMedium?.copyWith(
                      fontSize: 14,
                    ),
                    prefixText: '\$',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedPeriod,
                  style: context.textStyles.bodyMedium?.copyWith(fontSize: 14),
                  decoration: InputDecoration(
                    labelText: S.of(context).period,
                    labelStyle: context.textStyles.bodyMedium?.copyWith(
                      fontSize: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items:
                      [
                        S.of(context).weekly_period,
                        S.of(context).monthly_period,
                        S.of(context).annual_period,
                      ].map((period) {
                        return DropdownMenuItem(
                          value: period,
                          child: Text(
                            period,
                            style: context.textStyles.bodyMedium?.copyWith(
                              fontSize: 14,
                            ),
                          ),
                        );
                      }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setDialogState(() => selectedPeriod = value);
                    }
                  },
                ),
                const SizedBox(height: 16),
                CheckboxListTile(
                  title: Text(
                    'Presupuesto recurrente',
                    style: context.textStyles.bodyMedium?.copyWith(
                      fontSize: 14,
                    ),
                  ),
                  value: isRecurring,
                  onChanged: (value) {
                    setDialogState(() => isRecurring = value ?? true);
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => context.pop(),
              child: Text(
                S.of(context).cancel,
                style: context.textStyles.bodyMedium?.copyWith(fontSize: 14),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _saveBudget(
                  selectedCategoryId,
                  double.tryParse(amountController.text) ?? 0,
                  selectedPeriod,
                  isRecurring,
                  budget,
                );
                context.pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colors.primary,
                foregroundColor: Colors.white,
              ),
              child: Text(
                isEditing ? S.of(context).modify : S.of(context).create,
                style: context.textStyles.bodyMedium?.copyWith(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(Map<String, dynamic> budget) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: context.colors.surface,
        title: Text(
          S.of(context).delete_budget,
          style: context.textStyles.titleMedium?.copyWith(fontSize: 18),
        ),
        content: Text(
          '${S.of(context).ask_delete_budget}"${budget['category']}"?',
          style: context.textStyles.bodyMedium?.copyWith(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text(
              S.of(context).cancel,
              style: context.textStyles.bodyMedium?.copyWith(fontSize: 14),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _deleteBudget(budget['id']);
              context.pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text(
              S.of(context).delete,
              style: context.textStyles.bodyMedium?.copyWith(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveBudget(
    String? categoryId,
    double amount,
    String period,
    bool isRecurring,
    Map<String, dynamic>? existingBudget,
  ) async {
    if (categoryId == null || categoryId.isEmpty || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor completa todos los campos correctamente'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final periodDates = BudgetService.calculatePeriodDates(period);

      if (existingBudget != null) {
        // Update existing budget
        final updateDto = UpdateBudgetDto(
          categoryId: categoryId,
          startDate: periodDates['startDate']!,
          endDate: periodDates['endDate']!,
          isRecurring: isRecurring,
          maximumAmount: amount,
        );

        await _budgetService.updateBudget(existingBudget['id'], updateDto);
      } else {
        // Create new budget
        final createDto = CreateBudgetDto(
          categoryId: categoryId,
          startDate: periodDates['startDate']!,
          endDate: periodDates['endDate']!,
          isRecurring: isRecurring,
          maximumAmount: amount,
        );

        await _budgetService.createBudget(createDto);
      }

      // Reload data
      await _loadData();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              existingBudget != null
                  ? 'Presupuesto actualizado exitosamente'
                  : 'Presupuesto creado exitosamente',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _deleteBudget(String id) async {
    try {
      await _budgetService.deleteBudget(id);
      await _loadData();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Presupuesto eliminado exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al eliminar: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
