// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:financia_mobile/widgets/full_width_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:financia_mobile/extensions/theme_extensions.dart';
import 'package:financia_mobile/config/app_preferences.dart';
import 'package:financia_mobile/generated/l10n.dart';

class PersonalDataScreen extends StatefulWidget {
  const PersonalDataScreen({super.key});

  @override
  State<PersonalDataScreen> createState() => _PersonalDataScreenState();
}

class _PersonalDataScreenState extends State<PersonalDataScreen> {
  XFile? _profileImage;
  final _nameController = TextEditingController();
  DateTime? _birthDate;
  String? selectedGender;

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    final name = await AppPreferences.getStringPreference('personal_name');
    final birthDateStr = await AppPreferences.getStringPreference(
      'personal_birthdate',
    );
    final gender = await AppPreferences.getStringPreference('personal_gender');
    final imagePath = await AppPreferences.getStringPreference(
      'personal_image_path',
    );

    if (mounted) {
      setState(() {
        _nameController.text = name ?? '';
        _birthDate = birthDateStr != null
            ? DateTime.tryParse(birthDateStr)
            : null;
        selectedGender = gender;
        if (imagePath != null && File(imagePath).existsSync()) {
          _profileImage = XFile(imagePath);
        }
      });
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

  @override
  Widget build(BuildContext context) {
    final List<String> genders = [
      S.of(context).male,
      S.of(context).female,
      S.of(context).other,
    ];

    // Corrección para evitar error en DropdownButtonFormField
    if (selectedGender == null || !genders.contains(selectedGender)) {
      selectedGender = genders[0];
    }

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
      body: Padding(
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
                    : null,
                child: _profileImage == null
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
                prefixIcon: Icon(Icons.person, color: context.colors.primary),
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
            DropdownButtonFormField<int>(
              decoration: InputDecoration(
                labelText: S.of(context).gender,
                prefixIcon: Icon(Icons.wc, color: context.colors.primary),
              ),
              value: genders.indexOf(selectedGender!),
              items: genders.map((gender) {
                return DropdownMenuItem(
                  value: genders.indexOf(gender),
                  child: Text(gender, style: context.textStyles.labelMedium),
                );
              }).toList(),
              onChanged: (value) =>
                  setState(() => selectedGender = genders[value!]),
            ),
            const SizedBox(height: 25),
            FullWidthButton(
              text: S.of(context).save,
              onPressed: () async {
                await AppPreferences.setStringPreference(
                  'personal_name',
                  _nameController.text,
                );
                if (_birthDate != null) {
                  await AppPreferences.setStringPreference(
                    'personal_birthdate',
                    _birthDate!.toIso8601String(),
                  );
                }
                if (selectedGender != null) {
                  await AppPreferences.setStringPreference(
                    'personal_gender',
                    selectedGender!,
                  );
                }
                if (_profileImage != null) {
                  await AppPreferences.setStringPreference(
                    'personal_image_path',
                    _profileImage!.path,
                  );
                }

                if (!mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(S.of(context).data_saved)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
