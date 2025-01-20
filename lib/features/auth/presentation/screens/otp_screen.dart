import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:your_chef/core/constants/colors.dart';
import 'package:your_chef/core/constants/strings.dart';
import 'package:your_chef/core/extensions/space_extension.dart';
import 'package:your_chef/core/extensions/theme_extension.dart';
import 'package:your_chef/core/options/options.dart';
import 'package:your_chef/core/utils/messages.dart';
import 'package:your_chef/core/widgets/buttons/primary_button.dart';
import 'package:your_chef/features/auth/presentation/bloc/verify/verify_bloc.dart';
import 'package:your_chef/locator.dart';

class OtpScreen extends StatefulWidget {
  final ResetPasswordOptions options;
  const OtpScreen({
    super.key,
    required this.options,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _otpController = TextEditingController();
  Timer? _timer;
  ValueNotifier<Duration>? _duration;
  final ValueNotifier<bool> _valid = ValueNotifier<bool>(false);

  final int _length = 6;

  @override
  void initState() {
    _otpController.addListener(_otpListener);
    _startTimer();
    super.initState();
  }

  void _startTimer([Duration duration = const Duration(minutes: 1)]) {
    _timer?.cancel();
    DateTime date = DateTime.now().add(duration);
    if (_duration == null) {
      _duration = ValueNotifier(date.difference(DateTime.now()));
    } else {
      _duration!.value = date.difference(DateTime.now());
    }

    _timer = Timer.periodic(const Duration(milliseconds: 300), (_) {
      if (_duration!.value.isNegative) {
        _timer?.cancel();
      }
      _duration!.value = date.difference(DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.removeListener(_otpListener);
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => locator<VerifyBloc>()
        ..add(
          SendOtpEvent(widget.options),
        ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        body: Builder(builder: (context) {
          return BlocListener<VerifyBloc, VerifyState>(
            listener: (_, state) {
              if (state is VerifyLoadingState) {
                AppMessages.showLoadingDialog(
                  context,
                  message: AppStrings.justAMoment.tr(),
                );
              } else {
                AppMessages.dismissLoadingDialog(context);

                if (state is CodeSentSuccessState) {
                  AppMessages.showSuccessMessage(context,
                      'Code sent to your ${widget.options.email != null ? 'email' : 'phone'}');
                }
                if (state is VerifyErrorState) {
                  AppMessages.showErrorMessage(
                    context,
                    state.error,
                    state.type,
                  );
                }
              }
            },
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0).r,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    Text(
                      AppStrings.otpTitle.tr(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.options.email != null
                          ? widget.options.email.toString()
                          : widget.options.phone.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: context.theme.iconTheme.color?.withOpacity(0.4),
                      ),
                    ),
                    const Spacer(),
                    Pinput(
                      length: _length,
                      controller: _otpController,
                      defaultPinTheme: PinTheme(
                        height: 52.h,
                        width: 52.w,
                        textStyle: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: BoxDecoration(
                          color:
                              context.theme.iconTheme.color?.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(15).r,
                        ),
                      ),
                      focusedPinTheme: PinTheme(
                        height: 52.h,
                        width: 52.w,
                        textStyle: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(15).r,
                        ),
                      ),
                    ),
                    Flexible(child: 16.height),
                    ValueListenableBuilder(
                      valueListenable: _duration!,
                      builder: (_, time, __) => Text.rich(
                        TextSpan(
                            text: '${AppStrings.codeNotSent.tr()} ',
                            children: [
                              if (_timer != null && _timer!.isActive)
                                TextSpan(
                                    text:
                                        '${AppStrings.tryAgainAfter.tr()}: (${(time.inMinutes % 60).toString().padLeft(2, '0')}:${(time.inSeconds % 60).toString().padLeft(2, '0')})')
                              else
                                WidgetSpan(
                                  child: GestureDetector(
                                    onTap: () => _resend(context),
                                    child: Text(
                                      AppStrings.resend.tr(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                ),
                            ]),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color:
                              context.theme.iconTheme.color?.withOpacity(0.4),
                        ),
                      ),
                    ),
                    Flexible(child: 48.height),
                    ValueListenableBuilder(
                        valueListenable: _valid,
                        builder: (_, valid, __) {
                          return PrimaryButton(
                            onPressed: valid ? () => _verify(context) : null,
                            text: AppStrings.verify.tr(),
                          );
                        }),
                    const Spacer(
                      flex: 3,
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  void _otpListener() {
    _valid.value = _otpController.text.trim().length == _length;
  }

  void _resend(BuildContext context) {
    _startTimer();
    context.read<VerifyBloc>().add(SendOtpEvent(widget.options));
  }

  void _verify(BuildContext context) {
    context.read<VerifyBloc>().add(
          VerifyOtpEvent(
            VerifyOtpOptions(
              otp: _otpController.text.trim(),
              email: widget.options.email,
              phone: widget.options.phone,
            ),
          ),
        );
  }
}
