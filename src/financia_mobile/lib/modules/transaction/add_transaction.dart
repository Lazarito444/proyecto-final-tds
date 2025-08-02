import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:financia_mobile/config/app_preferences.dart';
import 'package:financia_mobile/models/transaction_model.dart';
import 'package:financia_mobile/services/transaction_service.dart';
import 'package:financia_mobile/extensions/theme_extensions.dart';

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
  DateTime _selectedDate = DateTime.now();
  bool _localIsEarning = false; // Renombrado aquí
  String? _selectedCategoryId;
  File? _imageFile;

  List<Map<String, dynamic>> _categories = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final token = await AppPreferences.getStringPreference('accessToken');
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
    }
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
      });
    }
  }

  Future<void> _submitTransaction() async {
    if (!_formKey.currentState!.validate() || _selectedCategoryId == null) {
      return;
    }

    final transaction = TransactionModel(
      categoryId: _selectedCategoryId!,
      description: _descriptionController.text,
      amount: double.parse(_amountController.text),
      dateTime: _selectedDate,
      isEarning: _localIsEarning, // Cambiado aquí también
      imageFile: _imageFile,
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Agregar Transacción",
          style: context.textStyles.titleMedium?.copyWith(
            color: context.colors.onSurface,
            fontSize: 30,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Monto'),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedCategoryId,
                items: _categories.map((cat) {
                  return DropdownMenuItem<String>(
                    value: cat['id'],
                    child: Text(cat['name']),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _selectedCategoryId = val),
                decoration: const InputDecoration(labelText: 'Categoría'),
                validator: (val) =>
                    val == null ? 'Selecciona una categoría' : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text("¿Es ingreso?"),
                  Switch(
                    value: _localIsEarning,
                    onChanged: (val) => setState(() => _localIsEarning = val),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text("Fecha: ${_selectedDate.toLocal()}"),
              ElevatedButton(
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setState(() => _selectedDate = picked);
                  }
                },
                child: const Text("Seleccionar Fecha"),
              ),
              const SizedBox(height: 12),
              if (_imageFile != null)
                Image.file(_imageFile!, height: 100, fit: BoxFit.cover),
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text("Seleccionar Imagen"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitTransaction,
                child: const Text("Guardar Transacción"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
