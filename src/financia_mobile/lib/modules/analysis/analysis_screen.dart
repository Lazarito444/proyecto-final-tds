import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:financia_mobile/extensions/theme_extensions.dart';
import 'package:financia_mobile/extensions/navigation_extensions.dart';
import 'package:financia_mobile/models/analysis_model.dart';
import 'package:financia_mobile/services/analysis_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:financia_mobile/generated/l10n.dart';

class AnalysisScreen extends ConsumerStatefulWidget {
  const AnalysisScreen({super.key});

  @override
  ConsumerState<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends ConsumerState<AnalysisScreen> {
  final AnalysisService _analysisService = AnalysisService();
  AnalysisData? _analysisData;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadAnalysisData();
  }

  Future<void> _loadAnalysisData() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final data = await _analysisService.getCompleteAnalysis();
      if (mounted) {
        setState(() {
          _analysisData = data;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al cargar análisis: ${e.toString()}")),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _showAddGoalDialog() async {
    if (!mounted) return;

    final titleController = TextEditingController();
    final targetController = TextEditingController();
    final descriptionController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Nuevo Objetivo de Ahorro'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Título del objetivo',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: targetController,
              decoration: const InputDecoration(
                labelText: 'Monto objetivo',
                border: OutlineInputBorder(),
                prefixText: '\$',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Descripción (opcional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (titleController.text.isNotEmpty &&
                  targetController.text.isNotEmpty) {
                try {
                  await _analysisService.createSavingsGoal(
                    title: titleController.text,
                    targetAmount: double.parse(targetController.text),
                    description: descriptionController.text,
                  );
                  if (dialogContext.mounted) {
                    Navigator.of(dialogContext).pop(true);
                  }
                } catch (e) {
                  if (dialogContext.mounted) {
                    ScaffoldMessenger.of(dialogContext).showSnackBar(
                      SnackBar(content: Text("Error al crear objetivo: $e")),
                    );
                  }
                }
              }
            },
            child: const Text('Crear'),
          ),
        ],
      ),
    );

    if (result == true && mounted) {
      _loadAnalysisData(); // Recargar datos
    }
  }

  // Función para obtener el ícono de la categoría, usando solo las categorías que proporcionaste
  IconData _getCategoryIcon(String categoryName) {
    switch (categoryName) {
      case 'Food':
        return Icons.restaurant;
      case 'Transport':
        return Icons.directions_bus;      
      default:
        return Icons.money_off;
    }
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
          S.of(context).analysis,
          style: GoogleFonts.gabarito(
            textStyle: context.textStyles.titleMedium?.copyWith(
              color: context.colors.onSurface,
              fontSize: 27,
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadAnalysisData,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: _analysisData != null
                    ? _buildAnalysisContent()
                    : _buildEmptyState(),
              ),
            ),
    );
  }

  Widget _buildAnalysisContent() {
    final data = _analysisData!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Resumen mensual
        _buildMonthlySummaryCard(data.currentMonthSummary),
        const SizedBox(height: 24),

        // Gastos por categoría
        if (data.expensesByCategory.isNotEmpty) ...[
          Text(
            S.of(context).expenses_by_category,
            style: context.textStyles.titleMedium,
          ),
          const SizedBox(height: 16),
          ...data.expensesByCategory
              .where((expense) => !expense.isEarningCategory)
              .map((expense) => _buildCategoryExpenseItem(expense)),
          const SizedBox(height: 24),
        ],

        // Tendencia mensual
        Text(
          S.of(context).monthly_trend,
          style: context.textStyles.titleMedium,
        ),
        const SizedBox(height: 16),
        _buildMonthlyTrendChart(data.monthlyTrends),
        const SizedBox(height: 24),

        // Objetivos de Ahorro
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                S.of(context).savings_goals,
                style: context.textStyles.titleMedium,
              ),
            ),
            IconButton(
              onPressed: _showAddGoalDialog,
              icon: Icon(
                Icons.add_circle_outline,
                color: context.colors.primary,
              ),
              tooltip: 'Agregar objetivo',
            ),
          ],
        ),
        const SizedBox(height: 16),

        if (data.savingsGoals.isEmpty)
          _buildEmptySavingsGoals()
        else
          ...data.savingsGoals.map(
            (goal) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildSavingsGoalCard(goal),
            ),
          ),
      ],
    );
  }

  Widget _buildEmptySavingsGoals() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: context.colors.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Icon(Icons.savings_outlined, size: 48, color: context.colors.outline),
          const SizedBox(height: 16),
          Text(
            'No tienes objetivos de ahorro',
            style: context.textStyles.titleSmall?.copyWith(
              color: context.colors.outline,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Crea tu primer objetivo de ahorro para comenzar a planificar tus metas financieras',
            style: context.textStyles.bodySmall?.copyWith(
              color: context.colors.outline,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _showAddGoalDialog,
            icon: const Icon(Icons.add),
            label: const Text('Crear objetivo'),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlySummaryCard(MonthlySummary summary) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4A9B8E), Color(0xFF5CB7A6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Resumen de ${summary.month}',
            style: context.textStyles.bodyLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      S.of(context).income,
                      style: context.textStyles.bodySmall?.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                    Text(
                      '\$${summary.totalIncome.toStringAsFixed(2)}',
                      style: context.textStyles.bodyLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Gastos',
                      style: context.textStyles.bodySmall?.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                    Text(
                      '\$${summary.totalExpenses.toStringAsFixed(2)}',
                      style: context.textStyles.bodyLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryExpenseItem(CategoryExpense expense) {
    // Definimos una lista de colores
    final colors = [
      const Color(0xFF4A9B8E),
      const Color(0xFF7BC4B8),
      const Color(0xFFB8E6C1),
      const Color(0xFFD4F1E8),
      const Color(0xFFE8F5F3),
    ];

    // Asignamos un color según el nombre de la categoría
    final colorIndex = expense.categoryName.hashCode % colors.length;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: colors[colorIndex].withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            // Usamos la función para obtener el ícono correcto
            child: Icon(
              _getCategoryIcon(expense.categoryName),
              color: colors[colorIndex],
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  expense.categoryName,
                  style: context.textStyles.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: context.colors.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: expense.percentage / 100,
                    child: Container(
                      decoration: BoxDecoration(
                        color: colors[colorIndex],
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${expense.totalAmount.toStringAsFixed(2)}',
                style: context.textStyles.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: context.colors.onSurface,
                ),
              ),
              Text(
                '${expense.percentage.toInt()}%',
                style: context.textStyles.bodySmall?.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyTrendChart(List<MonthlyTrend> trends) {
    if (trends.isEmpty) {
      return Container(
        height: 200,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FFFE),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: const Center(
          child: Text('No hay datos de tendencias disponibles'),
        ),
      );
    }

    final maxAmount = trends
        .map((t) => t.amount)
        .reduce((a, b) => a > b ? a : b);

    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FFFE),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: trends
                .map(
                  (trend) => Expanded(
                    child: Text(
                      trend.month.substring(0, 3),
                      style: context.textStyles.bodySmall?.copyWith(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: trends.map((trend) {
                final height = maxAmount > 0
                    ? (trend.amount / maxAmount) * 120
                    : 20.0;
                return ChartBar(height: height, color: const Color(0xFF4A9B8E));
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSavingsGoalCard(SavingsGoal goal) {
    final colors = [
      const Color(0xFF4A9B8E),
      const Color(0xFF7BC4B8),
      const Color(0xFFB8E6C1),
    ];

    final color = colors[goal.title.hashCode % colors.length];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  goal.title,
                  style: context.textStyles.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: context.colors.onSurface,
                  ),
                ),
              ),
              Row(
                children: [
                  Text(
                    '${goal.progressPercentage}%',
                    style: context.textStyles.bodySmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) async {
                      if (value == 'delete') {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (dialogContext) => AlertDialog(
                            title: const Text('Eliminar objetivo'),
                            content: Text(
                              '¿Estás seguro de que quieres eliminar "${goal.title}"?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(dialogContext).pop(false),
                                child: const Text('Cancelar'),
                              ),
                              ElevatedButton(
                                onPressed: () =>
                                    Navigator.of(dialogContext).pop(true),
                                child: const Text('Eliminar'),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true && mounted) {
                          try {
                            await _analysisService.deleteSavingsGoal(goal.id);
                            _loadAnalysisData();
                          } catch (e) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Error al eliminar: $e"),
                                ),
                              );
                            }
                          }
                        }
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Eliminar'),
                          ],
                        ),
                      ),
                    ],
                    child: Icon(
                      Icons.more_vert,
                      size: 16,
                      color: context.colors.outline,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '\$${goal.currentAmount.toInt()} de \$${goal.targetAmount.toInt()}',
            style: context.textStyles.bodySmall?.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: goal.progress,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.analytics_outlined,
            size: 64,
            color: context.colors.outline,
          ),
          const SizedBox(height: 16),
          Text(
            'No hay datos de análisis disponibles',
            style: context.textStyles.titleMedium?.copyWith(
              color: context.colors.outline,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Agrega algunas transacciones para ver tu análisis financiero',
            style: context.textStyles.bodyMedium?.copyWith(
              color: context.colors.outline,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _loadAnalysisData,
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }
}

class ChartBar extends StatelessWidget {
  final double height;
  final Color color;

  const ChartBar({super.key, required this.height, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
