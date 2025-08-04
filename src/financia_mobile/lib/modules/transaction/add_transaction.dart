import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:financia_mobile/config/app_preferences.dart';
import 'package:financia_mobile/models/transaction_model.dart';
import 'package:financia_mobile/providers/transaction_provider.dart';
import 'package:financia_mobile/extensions/theme_extensions.dart';
import 'package:financia_mobile/widgets/full_width_button.dart';
import 'package:sizer/sizer.dart';
import 'package:financia_mobile/generated/l10n.dart';
import 'package:intl/intl.dart';

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
  final bool _isLoading = false;
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
    final locale = Localizations.localeOf(context).toString();
    final dateFormat = DateFormat('d MMM yyyy', locale);
    _dateController.text = dateFormat.format(_selectedDate);
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
            content: Text(
              "❌ ${S.of(context).error_loading_categories}: ${e.toString()}",
            ),
          ),
        );
      }
    }
  }

  Future<void> _submitTransaction() async {
    if (ref.read(transactionProvider).status == TransactionStatus.loading) {
      return;
    }

    if (!_formKey.currentState!.validate() || _selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ ${S.of(context).please_fill_all_fields}")),
      );
      return;
    }

    final transaction = TransactionModel(
      categoryId: _selectedCategoryId!,
      description: _descriptionController.text,
      amount: double.parse(_amountController.text),
      dateTime: _selectedDate,
      isEarning: _isEarning,
      imageFile: null,
    );

    final transactionNotifier = ref.read(transactionProvider.notifier);
    await transactionNotifier.createTransaction(transaction);
    
    final transactionState = ref.read(transactionProvider);

    if (transactionState.status == TransactionStatus.success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "✅ ${S.of(context).transaction_created_successfully}",
            ),
          ),
        );
        Navigator.of(context).pop();
      }
    } else if (transactionState.status == TransactionStatus.error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ Error: ${transactionState.errorMessage}")),
        );
      }
    }
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
    final transactionStatus = ref.watch(transactionProvider).status;
    final bool isLoading = transactionStatus == TransactionStatus.loading;

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
                    val == null ? S.of(context).select_a_category : null,
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
                    return S.of(context).field_is_required;
                  }
                  if (double.tryParse(val) == null) {
                    return S.of(context).enter_a_valid_number;
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
                validator: (val) => val == null || val.isEmpty
                    ? S.of(context).field_is_required
                    : null,
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
              if (isLoading)
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
