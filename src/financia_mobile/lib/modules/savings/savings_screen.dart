import 'package:flutter/material.dart';
import 'package:financia_mobile/extensions/theme_extensions.dart';
import 'package:financia_mobile/extensions/navigation_extensions.dart';

class SavingsScreen extends StatefulWidget {
  const SavingsScreen({super.key});

  @override
  State<SavingsScreen> createState() => _SavingsScreenState();
}

class _SavingsScreenState extends State<SavingsScreen> {
  final List<Map<String, dynamic>> _savings = [
    {
      'id': 1,
      'name': 'Vacaciones 2024',
      'targetAmount': 5000.0,
      'currentAmount': 2500.0,
      'deadline': DateTime(2024, 12, 31),
      'icon': Icons.flight,
    },
    {
      'id': 2,
      'name': 'Fondo de Emergencia',
      'targetAmount': 15000.0,
      'currentAmount': 8750.0,
      'deadline': DateTime(2025, 6, 30),
      'icon': Icons.security,
    },
    {
      'id': 3,
      'name': 'Nuevo Auto',
      'targetAmount': 25000.0,
      'currentAmount': 5000.0,
      'deadline': DateTime(2025, 12, 31),
      'icon': Icons.directions_car,
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
          'Mis Ahorros',
          style: context.textStyles.titleLarge?.copyWith(fontSize: 20), 
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: context.colors.primary),
            onPressed: () => _showSavingDialog(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTotalSavingsCard(),
            const SizedBox(height: 24),
            Text(
              'Metas de Ahorro',
              style: context.textStyles.titleMedium?.copyWith(fontSize: 18), 
            ),
            const SizedBox(height: 16),
            ..._savings.map((saving) => _buildSavingCard(saving)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalSavingsCard() {
    final totalCurrent = _savings.fold<double>(0, (sum, saving) => sum + saving['currentAmount']);
    final totalTarget = _savings.fold<double>(0, (sum, saving) => sum + saving['targetAmount']);
    final progress = totalTarget > 0 ? totalCurrent / totalTarget : 0.0;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [context.colors.primary, context.colors.surfaceContainerLowest],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Ahorrado',
            style: context.textStyles.labelMedium?.copyWith(
              color: Colors.white,
              fontSize: 14, 
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '\$${totalCurrent.toStringAsFixed(2)}',
            style: context.textStyles.titleLarge?.copyWith(
              color: Colors.white,
              fontSize: 28, 
            ),
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.white,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            '${(progress * 100).toInt()}% de \$${totalTarget.toStringAsFixed(2)}',
            style: context.textStyles.labelSmall?.copyWith(
              color: Colors.white,
              fontSize: 12, 
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSavingCard(Map<String, dynamic> saving) {
    final progress = saving['currentAmount'] / saving['targetAmount'];
    final daysLeft = saving['deadline'].difference(DateTime.now()).inDays;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colors.secondaryContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.colors.outline),
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
                  saving['icon'] as IconData,
                  color: context.colors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      saving['name'] as String,
                      style: context.textStyles.titleSmall?.copyWith(fontSize: 16), 
                    ),
                    Text(
                      '$daysLeft días restantes',
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
                onSelected: (value) => _handleSavingAction(value, saving),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'add',
                    child: Row(
                      children: [
                        Icon(Icons.add, size: 20, color: context.colors.primary),
                        const SizedBox(width: 8),
                        Text('Agregar dinero', style: context.textStyles.bodyMedium?.copyWith(fontSize: 14)), 
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit, size: 20, color: context.colors.primary),
                        const SizedBox(width: 8),
                        Text('Editar', style: context.textStyles.bodyMedium?.copyWith(fontSize: 14)), 
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        const Icon(Icons.delete, size: 20, color: Colors.red),
                        const SizedBox(width: 8),
                        Text('Eliminar', style: context.textStyles.bodyMedium?.copyWith(fontSize: 14)), 
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
                '\$${saving['currentAmount'].toStringAsFixed(2)}',
                style: context.textStyles.titleSmall?.copyWith(
                  color: context.colors.primary,
                  fontSize: 16, 
                ),
              ),
              Text(
                '\$${saving['targetAmount'].toStringAsFixed(2)}',
                style: context.textStyles.labelSmall?.copyWith(
                  color: context.colors.outline,
                  fontSize: 12, 
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: context.colors.surfaceContainerLow,
            valueColor: AlwaysStoppedAnimation<Color>(context.colors.primary),
          ),
          const SizedBox(height: 8),
          Text(
            '${(progress * 100).toInt()}% completado',
            style: context.textStyles.labelSmall?.copyWith(
              color: context.colors.outline,
              fontSize: 12, 
            ),
          ),
        ],
      ),
    );
  }

  void _handleSavingAction(String action, Map<String, dynamic> saving) {
    switch (action) {
      case 'add':
        _showAddMoneyDialog(saving);
        break;
      case 'edit':
        _showSavingDialog(saving: saving);
        break;
      case 'delete':
        _showDeleteDialog(saving);
        break;
    }
  }

  void _showSavingDialog({Map<String, dynamic>? saving}) {
    final isEditing = saving != null;
    final nameController = TextEditingController(text: saving?['name'] ?? '');
    final targetController = TextEditingController(text: saving?['targetAmount']?.toString() ?? '');
    DateTime selectedDate = saving?['deadline'] ?? DateTime.now().add(const Duration(days: 365)); 

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: context.colors.surface,
          title: Text(
            isEditing ? 'Editar Meta' : 'Nueva Meta de Ahorro',
            style: context.textStyles.titleMedium?.copyWith(fontSize: 18), 
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                style: context.textStyles.bodyMedium?.copyWith(fontSize: 14), 
                decoration: InputDecoration(
                  labelText: 'Nombre de la meta',
                  labelStyle: context.textStyles.bodyMedium?.copyWith(fontSize: 14), 
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: targetController,
                keyboardType: TextInputType.number,
                style: context.textStyles.bodyMedium?.copyWith(fontSize: 14), 
                decoration: InputDecoration(
                  labelText: 'Cantidad objetivo',
                  labelStyle: context.textStyles.bodyMedium?.copyWith(fontSize: 14), 
                  prefixText: '\$',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    'Fecha límite: ',
                    style: context.textStyles.bodyMedium?.copyWith(fontSize: 14), 
                  ),
                  TextButton(
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 3650)), 
                      );
                      if (date != null) {
                        setDialogState(() => selectedDate = date);
                      }
                    },
                    child: Text(
                      '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                      style: context.textStyles.bodyMedium?.copyWith(fontSize: 14), 
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => context.pop(),
              child: Text('Cancelar', style: context.textStyles.bodyMedium?.copyWith(fontSize: 14)), 
            ),
            ElevatedButton(
              onPressed: () {
                _saveSaving(nameController.text, double.tryParse(targetController.text) ?? 0, selectedDate, saving);
                context.pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colors.primary,
                foregroundColor: Colors.white,
              ),
              child: Text(isEditing ? 'Actualizar' : 'Crear', style: context.textStyles.bodyMedium?.copyWith(fontSize: 14)), 
            ),
          ],
        ),
      ),
    );
  }

  void _showAddMoneyDialog(Map<String, dynamic> saving) {
    final amountController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: context.colors.surface,
        title: Text('Agregar Dinero', style: context.textStyles.titleMedium?.copyWith(fontSize: 18)), 
        content: TextField(
          controller: amountController,
          keyboardType: TextInputType.number,
          style: context.textStyles.bodyMedium?.copyWith(fontSize: 14), 
          decoration: InputDecoration(
            labelText: 'Cantidad a agregar',
            labelStyle: context.textStyles.bodyMedium?.copyWith(fontSize: 14), 
            prefixText: '\$',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text('Cancelar', style: context.textStyles.bodyMedium?.copyWith(fontSize: 14)), 
          ),
          ElevatedButton(
            onPressed: () {
              final amount = double.tryParse(amountController.text) ?? 0;
              if (amount > 0) {
                _addMoney(saving['id'], amount);
                context.pop();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: context.colors.primary,
              foregroundColor: Colors.white,
            ),
            child: Text('Agregar', style: context.textStyles.bodyMedium?.copyWith(fontSize: 14)), 
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(Map<String, dynamic> saving) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: context.colors.surface,
        title: Text('Eliminar Meta', style: context.textStyles.titleMedium?.copyWith(fontSize: 18)), 
        content: Text(
          '¿Estás seguro de que deseas eliminar "${saving['name']}"?',
          style: context.textStyles.bodyMedium?.copyWith(fontSize: 14), 
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text('Cancelar', style: context.textStyles.bodyMedium?.copyWith(fontSize: 14)),
          ),
          ElevatedButton(
            onPressed: () {
              _deleteSaving(saving['id']);
              context.pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('Eliminar', style: context.textStyles.bodyMedium?.copyWith(fontSize: 14)), 
          ),
        ],
      ),
    );
  }

  void _saveSaving(String name, double targetAmount, DateTime deadline, Map<String, dynamic>? existingSaving) {
    if (name.isEmpty || targetAmount <= 0) return;
    setState(() {
      if (existingSaving != null) {
        final index = _savings.indexWhere((s) => s['id'] == existingSaving['id']);
        if (index != -1) {
          _savings[index] = {
            ..._savings[index],
            'name': name,
            'targetAmount': targetAmount,
            'deadline': deadline,
          };
        }
      } else {
        _savings.add({
          'id': DateTime.now().millisecondsSinceEpoch,
          'name': name,
          'targetAmount': targetAmount,
          'currentAmount': 0.0,
          'deadline': deadline,
          'icon': Icons.savings,
        });
      }
    });
  }

  void _addMoney(int id, double amount) {
    setState(() {
      final index = _savings.indexWhere((s) => s['id'] == id);
      if (index != -1) {
        _savings[index]['currentAmount'] += amount;
      }
    });
  }

  void _deleteSaving(int id) {
    setState(() {
      _savings.removeWhere((s) => s['id'] == id);
    });
  }
}