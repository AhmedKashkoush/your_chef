import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:your_chef/core/constants/strings.dart';
import 'package:your_chef/core/extensions/space_extension.dart';
import 'package:your_chef/core/widgets/buttons/primary_button.dart';
import 'package:your_chef/core/widgets/fields/custom_text_field.dart';

class EmailResetScreen extends StatefulWidget {
  const EmailResetScreen({super.key});

  @override
  State<EmailResetScreen> createState() => _EmailResetScreenState();
}

class _EmailResetScreenState extends State<EmailResetScreen> {
  final TextEditingController _emailController = TextEditingController();
  final ValueNotifier<bool> _valid = ValueNotifier(false);

  @override
  void initState() {
    _emailController.addListener(_emailListener);

    super.initState();
  }

  @override
  void dispose() {
    _emailController.removeListener(_emailListener);
    _emailController.dispose();
    _valid.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0).r,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppStrings.resetYourEmail,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Flexible(child: 16.height),
              CustomTextField(
                keyboardType: TextInputType.emailAddress,
                hintText: AppStrings.email,
                prefixIcon: const Icon(HugeIcons.strokeRoundedMail01),
                controller: _emailController,
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp(r'\s')),
                ],
              ),
              Flexible(child: 48.height),
              ValueListenableBuilder(
                  valueListenable: _valid,
                  builder: (_, valid, __) {
                    return PrimaryButton(
                      onPressed: valid ? () {} : null,
                      text: AppStrings.sendCode,
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }

  void _emailListener() {
    _valid.value =
        RegExp(r'\S+@\S+\.\S+').hasMatch(_emailController.text.trim());
  }
}
