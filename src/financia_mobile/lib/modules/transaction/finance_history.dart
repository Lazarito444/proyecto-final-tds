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
    _historyFuture = FinanceHistoryService().getFinanceHistory();
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
          onPressed: () => Navigator.pop(context),
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
