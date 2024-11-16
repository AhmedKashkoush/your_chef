import 'package:flutter/material.dart';
import 'package:your_chef/core/constants/strings.dart';

class AuthButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final AuthType authType;
  const AuthButton({
    super.key,
    this.onPressed,
    required this.authType,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Image.asset(
        "assets/images/auth/${authType.name}.png",
        width: 20,
      ),
      label: Text(_text),
    );
  }

  String get _text {
    switch (authType) {
      case AuthType.google:
        return AppStrings.signInWithGoogle;
    }
  }
}

enum AuthType { google }
