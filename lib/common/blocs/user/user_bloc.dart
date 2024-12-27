import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_chef/core/errors/error_types.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/core/options/options.dart';
import 'package:your_chef/core/utils/network_helper.dart';
import 'package:your_chef/features/auth/domain/entities/saved_user.dart';
import 'package:your_chef/features/auth/domain/entities/user.dart';
import 'package:your_chef/features/auth/domain/usecases/user/delete_saved_user_usecase.dart';
import 'package:your_chef/features/auth/domain/usecases/user/delete_user_usecase.dart';
import 'package:your_chef/features/auth/domain/usecases/user/get_saved_users_usecase.dart';
import 'package:your_chef/features/auth/domain/usecases/user/get_user_usecase.dart';
import 'package:your_chef/features/auth/domain/usecases/user/save_user_usecase.dart';
import 'package:your_chef/features/auth/domain/usecases/user/switch_user_usecase.dart';
import 'package:your_chef/features/auth/domain/usecases/user/update_user_usecase.dart';

part 'user_events.dart';
part 'user_states.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUserUseCase getUserUseCase;
  final GetSavedUsersUseCase getSavedUsersUseCase;
  final SaveUserUseCase saveUserUseCase;
  final SwitchUserUseCase switchUserUseCase;
  final DeleteUserUseCase deleteUserUseCase;
  final DeleteSavedUserUseCase deleteSavedUserUseCase;
  final UpdateUserUseCase updateUserUseCase;

  UserBloc({
    required this.getUserUseCase,
    required this.getSavedUsersUseCase,
    required this.saveUserUseCase,
    required this.switchUserUseCase,
    required this.deleteUserUseCase,
    required this.deleteSavedUserUseCase,
    required this.updateUserUseCase,
  }) : super(const UserState()) {
    on<GetUserEvent>(_getUser);
    on<GetSavedUsersEvent>(_getSavedUsers);
    on<SaveUserEvent>(_saveUser);
    on<SwitchUserEvent>(_switchUser);
    on<DeleteUserEvent>(_deleteUser);
    on<DeleteSavedUserEvent>(_deleteSavedUser);
    on<UpdateUserEvent>(_updateUser);
    on<SetUserEvent>(_setUser);
    on<LogoutEvent>(_logout);
  }

  FutureOr<void> _getUser(GetUserEvent event, Emitter<UserState> emit) async {
    emit(state.copyWith(
      status: RequestStatus.loading,
      switchUser: false,
    ));
    final Either<Failure, User> result = await getUserUseCase();

    result.fold((failure) {
      if (failure is NetworkFailure) {
        emit(
          state.copyWith(
            status: RequestStatus.failure,
            error: failure.message,
            switchUser: false,
            errorType: ErrorType.network,
          ),
        );
      }
      if (failure is AuthFailure) {
        emit(
          state.copyWith(
            status: RequestStatus.failure,
            error: failure.message,
            switchUser: false,
            errorType: ErrorType.auth,
          ),
        );
      }
      if (failure is ServerFailure) {
        emit(
          state.copyWith(
            status: RequestStatus.failure,
            error: failure.message,
            switchUser: false,
            errorType: ErrorType.normal,
          ),
        );
      }
    }, (user) {
      emit(
        state.copyWith(
          user: user,
          status: RequestStatus.success,
          switchUser: false,
        ),
      );
    });
  }

  FutureOr<void> _getSavedUsers(
      GetSavedUsersEvent event, Emitter<UserState> emit) async {
    emit(state.copyWith(
      status: RequestStatus.loading,
      switchUser: false,
    ));
    final Either<Failure, List<SavedUser>> result =
        await getSavedUsersUseCase();
    result.fold((failure) {
      emit(
        state.copyWith(
          status: RequestStatus.failure,
          error: failure.message,
          switchUser: false,
        ),
      );
    }, (savedUsers) {
      emit(
        state.copyWith(
          savedUsers: savedUsers,
          status: RequestStatus.success,
          switchUser: false,
        ),
      );
    });
  }

  FutureOr<void> _saveUser(SaveUserEvent event, Emitter<UserState> emit) async {
    emit(state.copyWith(
      status: RequestStatus.loading,
      switchUser: false,
    ));
    final Either<Failure, Unit> result = await saveUserUseCase(event.savedUser);
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: RequestStatus.failure,
            error: failure.message,
            switchUser: false,
          ),
        );
      },
      (_) {
        emit(
          state.copyWith(
            status: RequestStatus.success,
            switchUser: false,
          ),
        );
        add(const GetSavedUsersEvent());
      },
    );
  }

  FutureOr<void> _switchUser(
      SwitchUserEvent event, Emitter<UserState> emit) async {
    emit(state.copyWith(status: RequestStatus.loading, switchUser: true));
    final Either<Failure, User> result =
        await switchUserUseCase(event.savedUser);
    result.fold((failure) {
      if (failure is NetworkFailure) {
        emit(
          state.copyWith(
            status: RequestStatus.failure,
            error: failure.message,
            switchUser: true,
            errorType: ErrorType.network,
          ),
        );
      }
      if (failure is AuthFailure) {
        emit(
          state.copyWith(
            status: RequestStatus.failure,
            error: failure.message,
            switchUser: true,
            errorType: ErrorType.auth,
          ),
        );
      }
      if (failure is ServerFailure) {
        emit(
          state.copyWith(
            status: RequestStatus.failure,
            error: failure.message,
            switchUser: true,
            errorType: ErrorType.normal,
          ),
        );
      }
    }, (user) {
      emit(
        state.copyWith(
          user: user,
          status: RequestStatus.success,
          switchUser: true,
        ),
      );
    });
  }

  FutureOr<void> _deleteUser(
      DeleteUserEvent event, Emitter<UserState> emit) async {
    emit(state.copyWith(
      status: RequestStatus.loading,
      switchUser: false,
    ));
    final Either<Failure, Unit> result = await deleteUserUseCase();
    result.fold(
      (failure) {
        if (failure is NetworkFailure) {
          emit(
            state.copyWith(
              status: RequestStatus.failure,
              error: failure.message,
              switchUser: false,
              errorType: ErrorType.network,
            ),
          );
        }
        if (failure is AuthFailure) {
          emit(
            state.copyWith(
              status: RequestStatus.failure,
              error: failure.message,
              switchUser: false,
              errorType: ErrorType.auth,
            ),
          );
        }
        if (failure is ServerFailure) {
          emit(
            state.copyWith(
              status: RequestStatus.failure,
              error: failure.message,
              switchUser: false,
              errorType: ErrorType.normal,
            ),
          );
        }
      },
      (_) {
        emit(
          state.copyWith(
            status: RequestStatus.success,
            switchUser: false,
          ),
        );
      },
    );
  }

  FutureOr<void> _deleteSavedUser(
      DeleteSavedUserEvent event, Emitter<UserState> emit) async {
    emit(state.copyWith(
      status: RequestStatus.loading,
      switchUser: false,
    ));
    final Either<Failure, Unit> result =
        await deleteSavedUserUseCase(event.savedUser);
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: RequestStatus.failure,
            error: failure.message,
            switchUser: false,
          ),
        );
      },
      (_) {
        emit(
          state.copyWith(
            status: RequestStatus.success,
            switchUser: false,
          ),
        );
        add(const GetSavedUsersEvent());
      },
    );
  }

  FutureOr<void> _updateUser(
      UpdateUserEvent event, Emitter<UserState> emit) async {
    emit(state.copyWith(status: RequestStatus.loading));
    final Either<Failure, Unit> result = await updateUserUseCase(event.options);
    result.fold(
      (failure) {
        if (failure is NetworkFailure) {
          emit(
            state.copyWith(
              status: RequestStatus.failure,
              error: failure.message,
              switchUser: false,
              errorType: ErrorType.network,
            ),
          );
        }
        if (failure is AuthFailure) {
          emit(
            state.copyWith(
              status: RequestStatus.failure,
              error: failure.message,
              switchUser: false,
              errorType: ErrorType.auth,
            ),
          );
        }
        if (failure is ServerFailure) {
          emit(
            state.copyWith(
              status: RequestStatus.failure,
              error: failure.message,
              switchUser: false,
              errorType: ErrorType.normal,
            ),
          );
        }
      },
      (_) {
        emit(
          state.copyWith(
            status: RequestStatus.success,
            switchUser: false,
          ),
        );
      },
    );
  }

  void _logout(LogoutEvent event, Emitter<UserState> emit) {
    emit(
      UserState(
        savedUsers: state.savedUsers,
        switchUser: false,
      ),
    );
  }

  void _setUser(SetUserEvent event, Emitter<UserState> emit) {
    emit(
      state.copyWith(
        user: event.user,
        switchUser: false,
      ),
    );
  }
}
