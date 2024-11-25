import 'dart:io';

abstract class AppOptions {
  const AppOptions();
}

class LoginOptions extends AppOptions {
  final String email, password;
  const LoginOptions({
    required this.email,
    required this.password,
  });
}

class RegisterOptions extends AppOptions {
  final String name, phone, address, email, password;
  const RegisterOptions({
    required this.name,
    required this.phone,
    required this.address,
    required this.email,
    required this.password,
  });
}

class ResetPasswordOptions extends AppOptions {
  final String? email, phone;
  const ResetPasswordOptions({
    this.email,
    this.phone,
  });
}

class VerifyOtpOptions extends AppOptions {
  final String? email, phone;
  final String otp;
  const VerifyOtpOptions({
    this.email,
    this.phone,
    required this.otp,
  });
}

class NewPasswordOptions extends AppOptions {
  final String password;
  const NewPasswordOptions({
    required this.password,
  });
}

class UpdatePasswordOptions extends AppOptions {
  final String oldPassword, newPassword;
  const UpdatePasswordOptions({
    required this.oldPassword,
    required this.newPassword,
  });
}

class UploadProfileOptions extends AppOptions {
  final String uid;
  final File photo;
  const UploadProfileOptions({
    required this.uid,
    required this.photo,
  });
}

class PaginationOptions extends AppOptions {
  final int page, limit;
  const PaginationOptions({
    this.page = 1,
    this.limit = 10,
  });
}
