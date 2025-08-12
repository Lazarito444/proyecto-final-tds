// ignore_for_file: unnecessary_to_list_in_spreads, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:financia_mobile/extensions/theme_extensions.dart';
import 'package:financia_mobile/extensions/navigation_extensions.dart';
import 'package:financia_mobile/config/dio_factory.dart';

class SavingsScreen extends StatefulWidget {
  const SavingsScreen({super.key});

  @override
  State<SavingsScreen> createState() => _SavingsScreenState();
}

class _SavingsScreenState extends State<SavingsScreen> {
  List<Map<String, dynamic>> _savings = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchSavings();
  }

  Future<void> _fetchSavings() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final dio = DioFactory.createDio();
      final response = await dio.get('/saving');
      final List<dynamic> data = response.data as List<dynamic>;
      setState(() {
        _savings = data
            .map(
              (e) => {
                'id': e['id'],
                'name': e['name'],
                'targetAmount': (e['targetAmount'] as num).toDouble(),
                'currentAmount': (e['currentAmount'] as num).toDouble(),
                'targetDate': DateTime.parse(e['targetDate']),
                'icon': Icons.savings,
              },
            )
            .toList();
        _loading = false;
      });
    } catch (e) {
      setState(() {
        debugPrint('Error fetching savings: $e');
        _error = 'Error al cargar los ahorros';
        _loading = false;
      });
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
          'Mis Ahorros',
          style: context.textStyles.titleLarge?.copyWith(fontSize: 24),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showSavingDialog(),
        backgroundColor: context.colors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(child: Text(_error!, style: context.textStyles.bodyMedium))
          : _savings.isEmpty
          ? Center(
              child: Text(
                'No tienes ahorros aún.\n¡Crea tu primera meta!',
                textAlign: TextAlign.center,
                style: context.textStyles.titleSmall,
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTotalSavingsCard(),
                  const SizedBox(height: 24),
                  Text(
                    'Metas de Ahorro',
                    style: context.textStyles.titleMedium?.copyWith(
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ..._savings
                      .map((saving) => _buildSavingCard(saving))
                      .toList(),
                ],
              ),
            ),
    );
  }

  Widget _buildTotalSavingsCard() {
    final totalCurrent = _savings.fold<double>(
      0,
      (sum, saving) => sum + saving['currentAmount'],
    );
    final totalTarget = _savings.fold<double>(
      0,
      (sum, saving) => sum + saving['targetAmount'],
    );
    final progress = totalTarget > 0 ? totalCurrent / totalTarget : 0.0;
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
    final progress = saving['targetAmount'] > 0
        ? saving['currentAmount'] / saving['targetAmount']
        : 0.0;
    final daysLeft = saving['targetDate'].difference(DateTime.now()).inDays;
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
                  Icons.savings, // Icono de puerquito
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
                      style: context.textStyles.titleSmall?.copyWith(
                        fontSize: 16,
                      ),
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
                        Icon(
                          Icons.add,
                          size: 20,
                          color: context.colors.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Agregar dinero',
                          style: context.textStyles.bodyMedium?.copyWith(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
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
                          'Editar',
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
                          'Eliminar',
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
    final targetController = TextEditingController(
      text: saving?['targetAmount']?.toString() ?? '',
    );
    DateTime selectedDate =
        saving?['deadline'] ?? DateTime.now().add(const Duration(days: 365));

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
                controller: targetController,
                keyboardType: TextInputType.number,
                style: context.textStyles.bodyMedium?.copyWith(fontSize: 14),
                decoration: InputDecoration(
                  labelText: 'Cantidad objetivo',
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
              Row(
                children: [
                  Text(
                    'Fecha límite: ',
                    style: context.textStyles.bodyMedium?.copyWith(
                      fontSize: 14,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(
                          const Duration(days: 3650),
                        ),
                      );
                      if (date != null) {
                        setDialogState(() => selectedDate = date);
                      }
                    },
                    child: Text(
                      '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                      style: context.textStyles.bodyMedium?.copyWith(
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => context.pop(),
              child: Text(
                'Cancelar',
                style: context.textStyles.bodyMedium?.copyWith(fontSize: 14),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await _saveSaving(
                  nameController.text,
                  double.tryParse(targetController.text) ?? 0,
                  selectedDate,
                  saving,
                );
                context.pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colors.primary,
                foregroundColor: Colors.white,
              ),
              child: Text(
                isEditing ? 'Actualizar' : 'Crear',
                style: context.textStyles.bodyMedium?.copyWith(
                  fontSize: 14,
                  color: context.colors.onSurface,
                ),
              ),
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
        title: Text(
          'Agregar Dinero',
          style: context.textStyles.titleMedium?.copyWith(fontSize: 18),
        ),
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
            child: Text(
              'Cancelar',
              style: context.textStyles.bodyMedium?.copyWith(fontSize: 14),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final amount = double.tryParse(amountController.text) ?? 0;
              if (amount > 0) {
                await _addMoney(saving['id'], amount);
                context.pop();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: context.colors.primary,
              foregroundColor: Colors.white,
            ),
            child: Text(
              'Agregar',
              style: context.textStyles.bodyMedium?.copyWith(fontSize: 14),
            ),
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
        title: Text(
          'Eliminar Meta',
          style: context.textStyles.titleMedium?.copyWith(fontSize: 18),
        ),
        content: Text(
          '¿Estás seguro de que deseas eliminar "${saving['name']}"?',
          style: context.textStyles.bodyMedium?.copyWith(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text(
              'Cancelar',
              style: context.textStyles.bodyMedium?.copyWith(fontSize: 14),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              await _deleteSaving(saving['id']);
              context.pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text(
              'Eliminar',
              style: context.textStyles.bodyMedium?.copyWith(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveSaving(
    String name,
    double targetAmount,
    DateTime deadline,
    Map<String, dynamic>? existingSaving,
  ) async {
    if (name.isEmpty || targetAmount <= 0) return;
    final dio = DioFactory.createDio();
    if (existingSaving != null) {
      // Actualizar meta existente
      await dio.put(
        '/saving/${existingSaving['id']}',
        data: {
          'name': name,
          'targetAmount': targetAmount,
          'targetDate':
              "${deadline.year}-${deadline.month.toString().padLeft(2, '0')}-${deadline.day.toString().padLeft(2, '0')}",
        },
      );
    } else {
      // Crear nueva meta
      await dio.post(
        '/saving',
        data: {
          'name': name,
          'targetAmount': targetAmount,
          'currentAmount': 0.0,
          'targetDate':
              "${deadline.year}-${deadline.month.toString().padLeft(2, '0')}-${deadline.day.toString().padLeft(2, '0')}",
        },
      );
    }
    await _fetchSavings();
  }

  Future<void> _addMoney(String id, double amount) async {
    final dio = DioFactory.createDio();
    final now = DateTime.now();
    final date =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    await dio.post(
      '/saving/$id/deposit',
      data: {'amount': amount, 'date': date},
    );
    await _fetchSavings();
  }

  Future<void> _deleteSaving(String id) async {
    final dio = DioFactory.createDio();
    await dio.delete('/saving/$id');
    await _fetchSavings();
  }
}
