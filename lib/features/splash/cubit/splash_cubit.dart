import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_chef/core/constants/keys.dart';
import 'package:your_chef/core/utils/shared_preferences_helper.dart';

part 'splash_states.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(const SplashInitialState());

  Future<void> init() async {
    await Future.delayed(const Duration(seconds: 3));
    final bool onboarding =
        SharedPreferencesHelper.get<bool>(SharedPrefsKeys.onboarding) ?? false;
    if (!onboarding) {
      emit(const SplashUnSkippedOnboardingState());
      return;
    }

    emit(const SplashLoadingState());
  }
}
