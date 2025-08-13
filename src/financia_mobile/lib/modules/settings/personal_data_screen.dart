// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:financia_mobile/widgets/full_width_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:financia_mobile/extensions/theme_extensions.dart';
import 'package:financia_mobile/generated/l10n.dart';
import 'package:financia_mobile/models/user_model.dart';
import 'package:financia_mobile/services/user_service.dart';

class PersonalDataScreen extends StatefulWidget {
  const PersonalDataScreen({super.key});

  @override
  State<PersonalDataScreen> createState() => _PersonalDataScreenState();
}

class _PersonalDataScreenState extends State<PersonalDataScreen> {
  XFile? _profileImage;
  final _nameController = TextEditingController();
  DateTime? _birthDate;
  Gender selectedGender = Gender.male;
  final UserService _userService = UserService();
  bool _isLoading = false;
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);

    try {
      final user = await _userService.getCurrentUser();
      if (user != null && mounted) {
        setState(() {
          _currentUser = user;
          _nameController.text = user.fullName;
          _birthDate = user.dateOfBirth;
          selectedGender = user.gender;
          // Note: Profile image from server would need to be downloaded separately
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al cargar datos: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profileImage = image;
      });
    }
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _birthDate = picked;
      });
    }
  }

  Future<void> _saveData() async {
    if (_currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo obtener la información del usuario'),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final updateRequest = UpdateUserRequest(
        fullName: _nameController.text.trim().isNotEmpty
            ? _nameController.text.trim()
            : null,
        dateOfBirth: _birthDate,
        gender: selectedGender,
        photoFile: _profileImage != null ? File(_profileImage!.path) : null,
      );

      final updatedUser = await _userService.updateUser(
        _currentUser!.id,
        updateRequest,
      );

      if (updatedUser != null && mounted) {
        setState(() {
          _currentUser = updatedUser;
        });

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(S.of(context).data_saved)));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al guardar: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Gender> genders = [Gender.male, Gender.female, Gender.other];

    return Scaffold(
      backgroundColor: context.colors.surface,
      appBar: AppBar(
        backgroundColor: context.colors.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.colors.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: ListView(
                children: [
                  Text(
                    S.of(context).personal_data,
                    style: context.textStyles.titleLarge,
                  ),
                  const SizedBox(height: 30),
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: context.colors.surfaceContainerLow,
                      backgroundImage: _profileImage != null
                          ? FileImage(File(_profileImage!.path))
                          : _currentUser?.imagePath != null
                          ? NetworkImage(_currentUser!.imagePath!)
                          : null,
                      child:
                          (_profileImage == null &&
                              _currentUser?.imagePath == null)
                          ? Icon(
                              Icons.camera_alt,
                              size: 32,
                              color: context.colors.onSurfaceVariant,
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: S.of(context).full_name,
                      prefixIcon: Icon(
                        Icons.person,
                        color: context.colors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  ListTile(
                    title: Text(
                      _birthDate == null
                          ? S.of(context).birth_date
                          : _birthDate.toString().split(' ')[0],
                    ),
                    leading: Icon(Icons.cake, color: context.colors.primary),
                    trailing: Icon(
                      Icons.calendar_today,
                      color: context.colors.onSurfaceVariant,
                    ),
                    onTap: _pickDate,
                  ),
                  const SizedBox(height: 25),
                  DropdownButtonFormField<Gender>(
                    decoration: InputDecoration(
                      labelText: S.of(context).gender,
                      prefixIcon: Icon(Icons.wc, color: context.colors.primary),
                    ),
                    value: selectedGender,
                    items: genders.map((gender) {
                      return DropdownMenuItem(
                        value: gender,
                        child: Text(
                          _getGenderDisplayName(gender),
                          style: context.textStyles.labelMedium,
                        ),
                      );
                    }).toList(),
                    onChanged: (value) =>
                        setState(() => selectedGender = value!),
                  ),
                  const SizedBox(height: 25),
                  FullWidthButton(
                    text: S.of(context).save,
                    onPressed: () {
                      if (!_isLoading) {
                        _saveData();
                      }
                    },
                  ),
                ],
              ),
            ),
    );
  }

  String _getGenderDisplayName(Gender gender) {
    switch (gender) {
      case Gender.male:
        return S.of(context).male;
      case Gender.female:
        return S.of(context).female;
      case Gender.other:
        return S.of(context).other;
    }
  }
}
