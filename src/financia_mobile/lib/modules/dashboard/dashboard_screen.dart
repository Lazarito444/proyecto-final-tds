import 'package:financia_mobile/modules/analysis/analysis_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:financia_mobile/modules/transaction/add_transaction.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AnalysisScreen()),
      );
    } else if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AddTransactionScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFFB8E6C1),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Color(0xFFB8E6C1),
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
                    'Saldo actual',
                    style: GoogleFonts.gabarito(
                      textStyle: TextStyle(
                        fontSize: 30,
                        color: const Color(0xFF113931),
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
                      color: const Color(0xFF113931),
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
                      color: Colors.white,
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
                            color: Color(0xFF4A9B8E),
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
                          'Ingresos',
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
                          'Egresos',
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
                      'Últimas transacciones',
                      style: GoogleFonts.gabarito(
                        textStyle: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
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
                        title: 'Supermercado',
                        subtitle: 'Egreso',
                        amount: '-\$0,00',
                        isNegative: true,
                      ),
                      TransactionItem(
                        icon: Icons.attach_money,
                        title: 'Salario',
                        subtitle: 'Ingreso',
                        amount: '+2,000,00',
                        isNegative: false,
                      ),
                      TransactionItem(
                        icon: Icons.directions_bus,
                        title: 'Transporte',
                        subtitle: 'Egreso',
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
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFF4A9B8E),
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: GoogleFonts.gabarito(
          textStyle: TextStyle(fontSize: 10),
        ),
        unselectedLabelStyle: GoogleFonts.gabarito(
          textStyle: TextStyle(fontSize: 10),
        ),
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Presupuesto'),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Análisis',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle, size: 32),
            label: 'Sugerencias',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'Recorrido',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.swap_horiz),
            label: 'Transacciones',
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
              color: Color(0xFFE8F5F3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Color(0xFF4A9B8E), size: 24),
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
                      color: Colors.black,
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
