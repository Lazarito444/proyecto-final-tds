// ignore_for_file: unnecessary_to_list_in_spreads

import 'package:flutter/material.dart';
import 'package:financia_mobile/extensions/theme_extensions.dart';
import 'package:financia_mobile/extensions/navigation_extensions.dart';
import 'package:financia_mobile/generated/l10n.dart';

class BudgetsScreen extends StatefulWidget {
  const BudgetsScreen({super.key});

  @override
  State<BudgetsScreen> createState() => _BudgetsScreenState();
}

class _BudgetsScreenState extends State<BudgetsScreen> {
  final List<Map<String, dynamic>> _budgets = [
    {
      'id': 1,
      'category': 'Alimentación',
      'budgetAmount': 800.0,
      'spentAmount': 650.0,
      'period': 'Mensual',
      'icon': Icons.restaurant,
    },
    {
      'id': 2,
      'category': 'Transporte',
      'budgetAmount': 300.0,
      'spentAmount': 280.0,
      'period': 'Mensual',
      'icon': Icons.directions_car,
    },
    {
      'id': 3,
      'category': 'Entretenimiento',
      'budgetAmount': 200.0,
      'spentAmount': 150.0,
      'period': 'Mensual',
      'icon': Icons.movie,
    },
    {
      'id': 4,
      'category': 'Compras',
      'budgetAmount': 400.0,
      'spentAmount': 420.0,
      'period': 'Mensual',
      'icon': Icons.shopping_bag,
    },
  ];

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBudgetSummaryCard(),
            const SizedBox(height: 24),
            Text(
              S.of(context).budget_by_category,
              style: context.textStyles.titleMedium?.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 16),
            ..._budgets.map((budget) => _buildBudgetCard(budget)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildBudgetSummaryCard() {
    final totalBudget = _budgets.fold<double>(
      0,
      (sum, budget) => sum + budget['budgetAmount'],
    );
    final totalSpent = _budgets.fold<double>(
      0,
      (sum, budget) => sum + budget['spentAmount'],
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
                    Text(
                      budget['period'] as String,
                      style: context.textStyles.labelSmall?.copyWith(
                        color: context.colors.outline,
                        fontSize: 12,
                      ),
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
    final categoryController = TextEditingController(
      text: budget?['category'] ?? '',
    );
    final amountController = TextEditingController(
      text: budget?['budgetAmount']?.toString() ?? '',
    );
    String selectedPeriod = budget?['period'] ?? 'Mensual';
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: context.colors.surface,
          title: Text(
            isEditing ? S.of(context).edit_budget : S.of(context).new_budget,
            style: context.textStyles.titleMedium?.copyWith(fontSize: 18),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: categoryController,
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
            ],
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
                  categoryController.text,
                  double.tryParse(amountController.text) ?? 0,
                  selectedPeriod,
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

  void _saveBudget(
    String category,
    double amount,
    String period,
    Map<String, dynamic>? existingBudget,
  ) {
    if (category.isEmpty || amount <= 0) return;
    setState(() {
      if (existingBudget != null) {
        final index = _budgets.indexWhere(
          (b) => b['id'] == existingBudget['id'],
        );
        if (index != -1) {
          _budgets[index] = {
            ..._budgets[index],
            'category': category,
            'budgetAmount': amount,
            'period': period,
          };
        }
      } else {
        _budgets.add({
          'id': DateTime.now().millisecondsSinceEpoch,
          'category': category,
          'budgetAmount': amount,
          'spentAmount': 0.0,
          'period': period,
          'icon': Icons.category,
        });
      }
    });
  }

  void _deleteBudget(int id) {
    setState(() {
      _budgets.removeWhere((b) => b['id'] == id);
    });
  }
}
