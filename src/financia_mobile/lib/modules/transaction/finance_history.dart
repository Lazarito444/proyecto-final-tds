import 'package:financia_mobile/extensions/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:financia_mobile/generated/l10n.dart';
import 'package:financia_mobile/models/finance_history_model.dart';
import 'package:financia_mobile/services/finance_history_service.dart';
import 'package:intl/intl.dart';

class HistorialScreen extends StatefulWidget {
  const HistorialScreen({super.key});

  @override
  State<HistorialScreen> createState() => _HistorialScreenState();
}

class _HistorialScreenState extends State<HistorialScreen> {
  late Future<List<FinanceHistoryModel>> _historyFuture;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() {
    setState(() {
      _historyFuture = FinanceHistoryService().getFinanceHistory();
    });
  }

  Future<void> _deleteTransaction(String id) async {
    try {
      await FinanceHistoryService().deleteTransaction(id);
      _loadHistory();
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text('Transacción eliminada')));
    } catch (e) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text('Error al eliminar: $e')));
    }
  }

  void _editTransaction(FinanceHistoryModel transaction) async {
    final descController = TextEditingController(text: transaction.description);
    final amountController = TextEditingController(text: transaction.amount.toString());
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: context.colors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                S.of(context).edit,
                style: context.textStyles.titleMedium?.copyWith(fontSize: 20),
              ),
              const SizedBox(height: 18),
              TextField(
                controller: descController,
                decoration: InputDecoration(
                  labelText: S.of(context).description, 
                  labelStyle: context.textStyles.bodyMedium,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                style: context.textStyles.bodyMedium,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: amountController,
                decoration: InputDecoration(
                  labelText: S.of(context).amount, 
                  labelStyle: context.textStyles.bodyMedium,
                  prefixText: '\$',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                keyboardType: TextInputType.number,
                style: context.textStyles.bodyMedium,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(S.of(context).cancel, style: context.textStyles.bodyMedium), 
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        await FinanceHistoryService().editTransaction(
                          transaction.id,
                          descController.text,
                          double.tryParse(amountController.text) ?? transaction.amount,
                          transaction.categoryId,
                          transaction.dateTime,
                        );
                        Navigator.pop(context);
                        _loadHistory();
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(SnackBar(content: Text(S.of(context).budget_successfully_updated))); 
                      } catch (e) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(SnackBar(content: Text('${S.of(context).error}: $e'))); 
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.colors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(S.of(context).save, style: context.textStyles.bodyMedium),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(FinanceHistoryModel transaction) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: context.colors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.red, size: 40),
              const SizedBox(height: 16),
              Text(
                S.of(context).delete,
                style: context.textStyles.titleMedium?.copyWith(fontSize: 20),
              ),
              const SizedBox(height: 12),
              Text(
                S.of(context).delete_goal_ask,
                style: context.textStyles.bodyMedium?.copyWith(color: context.colors.onSurfaceVariant),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(S.of(context).cancel, style: context.textStyles.bodyMedium),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      await _deleteTransaction(transaction.id);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(S.of(context).delete, style: context.textStyles.bodyMedium),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconData(String categoryName) {
    switch (categoryName) {
      case 'Salary':
        return Icons.attach_money;
      case 'Food':
        return Icons.restaurant;
      case 'Transport':
        return Icons.directions_bus;
      case 'Extra':
        return Icons.attach_money;
      default:
        return Icons.money;
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final currentMonthFormatted = DateFormat(
      'MMMM yyyy',
      locale,
    ).format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.colors.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.colors.onSurface),
          onPressed: () => Navigator.pop(context, true),
        ),
      ),
      backgroundColor: context.colors.surface,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.of(context).transaction_history,
              style: context.textStyles.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(currentMonthFormatted, style: context.textStyles.titleMedium),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<FinanceHistoryModel>>(
                future: _historyFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text(S.of(context).no_transactions));
                  } else {
                    final transacciones = snapshot.data!;
                    return ListView.builder(
                      itemCount: transacciones.length,
                      itemBuilder: (context, index) {
                        final transaccion = transacciones[index];
                        final esIngreso = transaccion.isEarning;
                        final dateFormatString = locale.startsWith('en')
                            ? 'MMM d, yyyy'
                            : 'd MMM yyyy';
                        final formattedDate = DateFormat(
                          dateFormatString,
                          locale,
                        ).format(transaccion.dateTime);

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  _getIconData(transaccion.categoryName),
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      transaccion.description,
                                      style: GoogleFonts.gabarito(fontSize: 16),
                                    ),
                                    Text(
                                      formattedDate,
                                      style: GoogleFonts.gabarito(
                                        fontSize: 14,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '${esIngreso ? '+' : '-'}${transaccion.amount.abs().toStringAsFixed(2)}',
                                style: GoogleFonts.gabarito(
                                  fontSize: 16,
                                  color: esIngreso
                                      ? Colors.green.shade800
                                      : Colors.red,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              PopupMenuButton<String>(
                                onSelected: (value) {
                                  if (value == 'edit') {
                                    _editTransaction(transaccion);
                                  } else if (value == 'delete') {
                                    _showDeleteDialog(transaccion);
                                  }
                                },
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    value: 'edit',
                                    child: Text(S.of(context).edit),
                                  ),
                                  PopupMenuItem(
                                    value: 'delete',
                                    child: Text(S.of(context).delete),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
