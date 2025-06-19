import 'package:financia_mobile/extensions/theme_extensions.dart';
import 'package:financia_mobile/widgets/full_width_button.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AgregarTransaccionScreenState();
}

class _AgregarTransaccionScreenState extends State<AddTransactionScreen> {
  bool isEarning = true;
  String categoria = '';
  double monto = 0.0;
  DateTime fecha = DateTime.now();
  String descripcion = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.sw),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Agregar Transacción', style: context.textStyles.titleMedium,),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: SegmentedButton<bool>(
                style: SegmentedButton.styleFrom(
                  textStyle: context.textStyles.labelSmall,
                  backgroundColor: Colors.green.shade200,
                  selectedBackgroundColor: Colors.green.shade300,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.green.shade200, width: 2),
                  ),
                ),
                segments: const <ButtonSegment<bool>>[
                  ButtonSegment(value: true, label: Text('Ingreso')),
                  ButtonSegment(value: false, label: Text('Egreso')),
                ],
                selected: <bool>{isEarning},
                onSelectionChanged: (selection) {
                  setState(() {
                    isEarning = selection.first;
                  });
                },
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Categoría',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                categoria = value;
              },
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Monto',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (value) {
                monto = double.tryParse(value) ?? 0.0;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Fecha',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today),
              ),
              controller: TextEditingController(
                text:
                    '${fecha.day} ${_getMonthName(fecha.month)} ${fecha.year}',
              ),
              onTap: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: fecha,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  setState(() {
                    fecha = picked;
                  });
                }
              },
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Descripción',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
              onChanged: (value) {
                descripcion = value;
              },
            ),
            SizedBox(height: 24),
            FullWidthButton(text: "Guardar", onPressed: (){})
          ],
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      '',
      'ene.',
      'feb.',
      'mar.',
      'abr.',
      'may.',
      'jun.',
      'jul.',
      'ago.',
      'sep.',
      'oct.',
      'nov.',
      'dic.',
    ];
    return months[month];
  }
}
