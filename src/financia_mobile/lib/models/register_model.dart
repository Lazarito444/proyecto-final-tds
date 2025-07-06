class RegisterModel {
  final String fullName;
  final String email;
  final String password;
  final String passwordConfirmation;

  const RegisterModel({
    required this.fullName,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
  });
}
