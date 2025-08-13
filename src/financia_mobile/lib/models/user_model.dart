import 'dart:io';

enum Gender {
  male(0, 'Male'),
  female(1, 'Female'),
  other(2, 'Other');

  const Gender(this.value, this.displayName);
  final int value;
  final String displayName;

  static Gender fromValue(int value) {
    return Gender.values.firstWhere((gender) => gender.value == value);
  }

  static Gender fromString(String name) {
    return Gender.values.firstWhere(
      (gender) => gender.name.toLowerCase() == name.toLowerCase(),
      orElse: () => Gender.other,
    );
  }
}

class User {
  final String id;
  final String fullName;
  final DateTime? dateOfBirth;
  final String email;
  final Gender gender;
  final String? imagePath;

  User({
    required this.id,
    required this.fullName,
    this.dateOfBirth,
    required this.email,
    required this.gender,
    this.imagePath,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'] as String)
          : null,
      email: json['email'] as String,
      gender: Gender.fromValue(json['gender'] as int),
      imagePath: json['imagePath'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'email': email,
      'gender': gender.value,
      'imagePath': imagePath,
    };
  }
}

class UpdateUserRequest {
  final String? fullName;
  final DateTime? dateOfBirth;
  final Gender? gender;
  final String? password;
  final String? currentPassword;
  final File? photoFile;

  UpdateUserRequest({
    this.fullName,
    this.dateOfBirth,
    this.gender,
    this.password,
    this.currentPassword,
    this.photoFile,
  });
}
