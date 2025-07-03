import 'package:financia_mobile/extensions/theme_extensions.dart';
import 'package:financia_mobile/modules/analysis/analysis_screen.dart';
import 'package:financia_mobile/modules/settings/settings_screen.dart';
import 'package:financia_mobile/modules/transaction/finance_history.dart';
import 'package:financia_mobile/providers/auth_provider.dart';
import 'package:financia_mobile/providers/theme_mode_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:financia_mobile/modules/transaction/add_transaction.dart';
import 'package:financia_mobile/generated/l10n.dart';

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
        MaterialPageRoute(builder: (context) => AnalysisScreen()),
      );
    } else if (index == 2) {
      await ref.read(authProvider.notifier).logout();
    } else if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AddTransactionScreen()),
      );
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HistorialScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
            icon: Icon(Icons.settings),
            color: context.colors.onPrimaryContainer,
          ),
        ],
      ),

      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: context.colors.primaryContainer,
              // color: Color(0xFFB8E6C1),
              borderRadius: BorderRadius.only(
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
                        // color: const Color(0xFF113931),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '\$8,750,00',
                  style: GoogleFonts.gabarito(
                    textStyle: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: context.colors.onSurface,
                      // color: const Color(0xFF113931),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                SizedBox(height: 24),
                Center(
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: context.colors.secondaryContainer,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        '%',
                        style: GoogleFonts.gabarito(
                          textStyle: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: context.colors.outline,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: Color(0xFF4A9B8E),
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          S.of(context).income,
                          style: GoogleFonts.gabarito(fontSize: 18),
                        ),
                      ],
                    ),
                    SizedBox(width: 24),
                    Row(
                      children: [
                        Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: Color(0xFFB8E6C1),
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          S.of(context).expenses,
                          style: GoogleFonts.gabarito(fontSize: 18),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 24),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
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
                SizedBox(height: 12),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    children: [
                      TransactionItem(
                        icon: Icons.shopping_cart,
                        title: S.of(context).supermarket,
                        subtitle: S.of(context).expenses,
                        amount: '-\$0,00',
                        isNegative: true,
                      ),
                      TransactionItem(
                        icon: Icons.attach_money,
                        title: S.of(context).salary,
                        subtitle: S.of(context).income,
                        amount: '+2,000,00',
                        isNegative: false,
                      ),
                      TransactionItem(
                        icon: Icons.directions_bus,
                        title: S.of(context).transport,
                        subtitle: S.of(context).expenses,
                        amount: '-23,00',
                        isNegative: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: context.colors.secondaryContainer,
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFF4A9B8E),
        unselectedItemColor: context.colors.outline,
        selectedLabelStyle: GoogleFonts.gabarito(
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: GoogleFonts.gabarito(fontSize: 12),
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: S.of(context).budget,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: S.of(context).analysis,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle, size: 32),
            label: S.of(context).suggestions,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: S.of(context).history,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.swap_horiz),
            label: S.of(context).transactions,
          ),
        ],
      ),
    );
  }
}

class TransactionItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String amount;
  final bool isNegative;

  const TransactionItem({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.isNegative,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: context.colors.surfaceContainerLow,
              // color: Color(0xFFE8F5F3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: context.colors.surfaceContainerLowest,
              size: 24,
            ),
          ),
          SizedBox(width: 16),
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
                color: isNegative ? Colors.red : Color(0xFF4A9B8E),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
