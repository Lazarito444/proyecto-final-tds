import 'package:financia_mobile/extensions/theme_extensions.dart';
import 'package:financia_mobile/modules/analysis/analysis_screen.dart';
import 'package:financia_mobile/modules/settings/settings_screen.dart';
import 'package:financia_mobile/modules/transaction/finance_history.dart';
import 'package:financia_mobile/services/dashboard_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:financia_mobile/modules/transaction/add_transaction.dart';
import 'package:financia_mobile/modules/ai_suggestions/ai_suggestions_screen.dart';
import 'package:financia_mobile/generated/l10n.dart';
import 'package:financia_mobile/models/dashboard_model.dart'; 

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) async {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AnalysisScreen()),
      );
    } else if (index == 2) {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AddTransactionScreen()),
      );
      ref.invalidate(dashboardDataProvider);
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HistorialScreen()),
      );
    } else if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AISuggestionsScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final dashboardDataAsyncValue = ref.watch(dashboardDataProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.colors.primaryContainer,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
            icon: const Icon(Icons.settings),
            color: context.colors.onPrimaryContainer,
          ),
        ],
      ),
      body: dashboardDataAsyncValue.when(
        loading: () => Center(
          child: CircularProgressIndicator(color: context.colors.primary),
        ),
        error: (error, stack) => Center(
          child: Text(
            'Error al cargar los datos: $error',
            textAlign: TextAlign.center,
            style: GoogleFonts.gabarito(),
          ),
        ),
        data: (data) {
          final currentBalance = data.earnings - data.expenses;
          return Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: context.colors.primaryContainer,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        S.of(context).current_balance,
                        style: GoogleFonts.gabarito(
                          textStyle: TextStyle(
                            fontSize: 30,
                            color: context.colors.onSurface,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$${currentBalance.toStringAsFixed(2)}',
                      style: GoogleFonts.gabarito(
                        textStyle: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          color: context.colors.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildIncomeExpenseItem(
                          context,
                          color: const Color(0xFF4A9B8E),
                          label: S.of(context).income,
                          amount: data.earnings,
                        ),
                        _buildIncomeExpenseItem(
                          context,
                          color: const Color(0xFFB8E6C1),
                          label: S.of(context).expenses,
                          amount: data.expenses,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          S.of(context).latest_transactions,
                          style: GoogleFonts.gabarito(
                            textStyle: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: context.colors.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    data.userLastTransactions.isEmpty
                        ? Expanded(
                            child: Center(
                              child: Text(
                                S.of(context).no_transactions,
                                style: GoogleFonts.gabarito(
                                  textStyle: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Expanded(
                            child: ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
                              itemCount: data.userLastTransactions.length,
                              itemBuilder: (context, index) {
                                final transaction =
                                    data.userLastTransactions[index];
                                return TransactionItem(
                                  icon: transaction.toIconData,
                                  title: transaction.description,
                                  subtitle: transaction.categoryName,
                                  amount:
                                      '${transaction.isEarningCategory ? '+' : '-'}\$${transaction.amount.toStringAsFixed(2)}',
                                  isNegative: !transaction.isEarningCategory,
                                  iconColor: transaction.toColor,
                                );
                              },
                            ),
                          ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: context.colors.secondaryContainer,
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF4A9B8E),
        unselectedItemColor: context.colors.outline,
        selectedLabelStyle: GoogleFonts.gabarito(
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: GoogleFonts.gabarito(fontSize: 12),
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: S.of(context).budget,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.analytics),
            label: S.of(context).analysis,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.add_circle, size: 32),
            label: S.of(context).transactions,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.receipt),
            label: S.of(context).history,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.swap_horiz),
            label: S.of(context).suggestions,
          ),
        ],
      ),
    );
  }

  Widget _buildIncomeExpenseItem(
    BuildContext context, {
    required Color color,
    required String label,
    required double amount,
  }) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: GoogleFonts.gabarito(fontSize: 18)),
            const SizedBox(height: 4),
            Text(
              '\$${amount.toStringAsFixed(2)}',
              style: GoogleFonts.gabarito(
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class TransactionItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String amount;
  final bool isNegative;
  final Color iconColor;

  const TransactionItem({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.isNegative,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: context.colors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.gabarito(
                    textStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: context.colors.onSurface,
                    ),
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.gabarito(
                    textStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: GoogleFonts.gabarito(
              textStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isNegative ? Colors.red : const Color(0xFF4A9B8E),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
