import 'package:financia_mobile/extensions/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:financia_mobile/generated/l10n.dart';

class HistorialScreen extends StatelessWidget {
  const HistorialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final movimientos = [
      Movimiento(
        icon: Icons.attach_money,
        titulo: S.of(context).salary,
        fecha: S.of(context).apr_25,
        monto: 2000.00,
      ),
      Movimiento(
        icon: Icons.remove_circle_outline,
        titulo: S.of(context).supermarket,
        fecha: S.of(context).apr_25,
        monto: -150.00,
      ),
      Movimiento(
        icon: Icons.swap_horiz,
        titulo: S.of(context).transfer,
        fecha: S.of(context).apr_24,
        monto: 300.00,
      ),
      Movimiento(
        icon: Icons.restaurant,
        titulo: S.of(context).restaurant,
        fecha: S.of(context).apr_23,
        monto: -45.00,
      ),
      Movimiento(
        icon: Icons.directions_bus,
        titulo: S.of(context).transport,
        fecha: S.of(context).apr_23,
        monto: -20.00,
      ),
    ];

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
            SizedBox(height: 8),
            Text(S.of(context).apr_2024, style: context.textStyles.titleMedium),

            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: movimientos.length,
                itemBuilder: (context, index) {
                  final movimiento = movimientos[index];
                  final esIngreso = movimiento.monto >= 0;
                  return Container(
                    margin: EdgeInsets.only(bottom: 12),
                    padding: EdgeInsets.all(12),
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
                          child: Icon(movimiento.icon, color: Colors.black54),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                movimiento.titulo,
                                style: GoogleFonts.gabarito(fontSize: 16),
                              ),
                              Text(
                                movimiento.fecha,
                                style: GoogleFonts.gabarito(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '${esIngreso ? '+' : '-'}${movimiento.monto.abs().toStringAsFixed(2)}',
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Movimiento {
  final IconData icon;
  final String titulo;
  final String fecha;
  final double monto;

  Movimiento({
    required this.icon,
    required this.titulo,
    required this.fecha,
    required this.monto,
  });
}
