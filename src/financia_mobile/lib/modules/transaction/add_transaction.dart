import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:financia_mobile/config/app_preferences.dart';
import 'package:financia_mobile/models/transaction_model.dart';
import 'package:financia_mobile/services/transaction_service.dart';
import 'package:financia_mobile/extensions/theme_extensions.dart';
import 'package:financia_mobile/widgets/full_width_button.dart';
import 'package:sizer/sizer.dart';
import 'package:financia_mobile/generated/l10n.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  ConsumerState<AddTransactionScreen> createState() =>
      _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  bool _isEarning = true;
  String? _selectedCategoryId;

  List<Map<String, dynamic>> _categories = [];
  bool _isLoading = false;
  bool _isCategoriesLoaded = false;
  bool _isDateControllerInitialized = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isCategoriesLoaded) {
      _loadCategories();
      _isCategoriesLoaded = true;
    }

    if (!_isDateControllerInitialized) {
      _updateDateController();
      _isDateControllerInitialized = true;
    }
  }

  void _updateDateController() {
    _dateController.text =
        '${_selectedDate.day} ${_getMonthName(_selectedDate.month)} ${_selectedDate.year}';
  }

  Future<void> _loadCategories() async {
    try {
      final token = await AppPreferences.getStringPreference('accessToken');
      if (token == null) {
        throw Exception('Token de acceso no encontrado');
      }
      final dio = Dio(
        BaseOptions(
          baseUrl: 'http://10.0.0.13:5189/api/',
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      final response = await dio.get('category');
      setState(() {
        _categories = List<Map<String, dynamic>>.from(response.data);
      });
    } catch (e) {
      debugPrint('Error al cargar categorías: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("❌ Error al cargar categorías: ${e.toString()}"),
          ),
        );
      }
    }
  }

  Future<void> _submitTransaction() async {
    if (!_formKey.currentState!.validate() || _selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Por favor completa todos los campos")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final transaction = TransactionModel(
      categoryId: _selectedCategoryId!,
      description: _descriptionController.text,
      amount: double.parse(_amountController.text),
      dateTime: _selectedDate,
      isEarning: _isEarning,
      imageFile: null,
    );

    try {
      await TransactionService().createTransaction(transaction);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Transacción creada exitosamente")),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("❌ Error: ${e.toString()}")));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
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

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.surface,
      appBar: AppBar(backgroundColor: context.colors.surface),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.sw),
        child: Form(
          key: _formKey,
          child: ListView(
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
                    ButtonSegment(
                      value: true,
                      label: Text(S.of(context).income),
                    ),
                    ButtonSegment(
                      value: false,
                      label: Text(S.of(context).expenses),
                    ),
                  ],
                  selected: <bool>{_isEarning},
                  onSelectionChanged: (selection) {
                    setState(() {
                      _isEarning = selection.first;
                    });
                  },
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategoryId,
                decoration: InputDecoration(
                  labelText: S.of(context).category,
                  border: const OutlineInputBorder(),
                ),
                items: _categories.map((cat) {
                  return DropdownMenuItem<String>(
                    value: cat['id'],
                    child: Text(cat['name']),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _selectedCategoryId = val),
                validator: (val) =>
                    val == null ? 'Selecciona una categoría' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: S.of(context).amount,
                  border: const OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Campo requerido';
                  }
                  if (double.tryParse(val) == null) {
                    return 'Ingresa un número válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dateController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: S.of(context).date,
                  border: const OutlineInputBorder(),
                  suffixIcon: const Icon(Icons.calendar_today),
                ),
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setState(() {
                      _selectedDate = picked;
                      _updateDateController();
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: S.of(context).description,
                  border: const OutlineInputBorder(),
                ),
                maxLines: 2,
                validator: (val) =>
                    val == null || val.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 24),
              FullWidthButton(
                text: S.of(context).save,
                onPressed: _isLoading
                    ? () {}
                    : () async {
                        await _submitTransaction();
                      },
              ),
              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
