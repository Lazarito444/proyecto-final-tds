import 'package:financia_mobile/extensions/theme_extensions.dart';
import 'package:financia_mobile/widgets/full_width_button.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:financia_mobile/generated/l10n.dart';

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
      backgroundColor: context.colors.surface,
      appBar: AppBar(backgroundColor: context.colors.surface),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.sw),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.of(context).add_transaction,
              style: context.textStyles.titleMedium,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: SegmentedButton<bool>(
                style: SegmentedButton.styleFrom(
                  textStyle: context.textStyles.labelSmall,
                  backgroundColor: Colors.green.shade100,
                  selectedBackgroundColor: Colors.green.shade300,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: BorderSide(color: context.colors.surface, width: 3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                segments: <ButtonSegment<bool>>[
                  ButtonSegment(value: true, label: Text(S.of(context).income)),
                  ButtonSegment(
                    value: false,
                    label: Text(S.of(context).expenses),
                  ),
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
                labelText: S.of(context).category,
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                categoria = value;
              },
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: S.of(context).amount,
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
                labelText: S.of(context).date,
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
                labelText: S.of(context).description,
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
              onChanged: (value) {
                descripcion = value;
              },
            ),
            SizedBox(height: 24),
            FullWidthButton(text: S.of(context).save, onPressed: () {}),
          ],
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    final months = [
      '',
      S.of(context).month_jan,
      S.of(context).month_feb,
      S.of(context).month_mar,
      S.of(context).month_apr,
      S.of(context).month_may,
      S.of(context).month_jun,
      S.of(context).month_jul,
      S.of(context).month_aug,
      S.of(context).month_sep,
      S.of(context).month_oct,
      S.of(context).month_nov,
      S.of(context).month_dec,
    ];
    return months[month];
  }
}
