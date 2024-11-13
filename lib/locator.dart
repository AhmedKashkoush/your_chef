import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:your_chef/features/auth/data/sources/remote/auth_remote_data_source.dart';
import 'package:your_chef/features/auth/domain/repositories/auth_repository.dart';
import 'package:your_chef/features/auth/domain/usecases/login_usecase.dart';
import 'package:your_chef/features/auth/domain/usecases/register_usecase.dart';
import 'package:your_chef/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:your_chef/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:your_chef/features/auth/presentation/bloc/register/register_bloc.dart';
import 'package:your_chef/features/home/data/repositories/home_repository.dart';
import 'package:your_chef/features/home/data/sources/remote/home_remote_data_source.dart';
import 'package:your_chef/features/home/domain/repositories/home_repository.dart';
import 'package:your_chef/features/home/domain/usecases/get_categories_usecase.dart';
import 'package:your_chef/features/home/domain/usecases/get_offers_usecase.dart';
import 'package:your_chef/features/home/domain/usecases/get_products_usecase.dart';
import 'package:your_chef/features/home/domain/usecases/get_restaurants_usecase.dart';

import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/usecases/google_sign_in_usecase.dart';
import 'features/home/presentation/bloc/home_bloc.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  _initExternal();
  _initRemoteSources();
  _initRepositories();
  _initUseCases();
  _initBlocs();
}

//? External
void _initExternal() {
  locator.registerLazySingleton<SupabaseClient>(
    () => Supabase.instance.client,
  );
  locator.registerLazySingleton<GoogleSignIn>(
    () => GoogleSignIn(
      clientId: dotenv.env['GOOGLE_CLIENT_ID'],
    ),
  );
}

//? Remote Sources
void _initRemoteSources() {
  //*Auth
  locator.registerLazySingleton<IAuthRemoteDataSource>(
    () => SupabaseAuthRemoteDataSource(
      locator<SupabaseClient>(),
      locator<GoogleSignIn>(),
    ),
  );

  //*Home
  locator.registerLazySingleton<IHomeRemoteDataSource>(
    () => SupabaseHomeRemoteDataSource(
      locator<SupabaseClient>(),
    ),
  );
}

//? Repositories
void _initRepositories() {
  //*Auth
  locator.registerLazySingleton<IAuthRepository>(
    () => AuthRepository(locator<IAuthRemoteDataSource>()),
  );
  //*Home
  locator.registerLazySingleton<IHomeRepository>(
    () => HomeRepository(locator<IHomeRemoteDataSource>()),
  );
}

//? UseCases
void _initUseCases() {
  //*Auth
  locator.registerLazySingleton<RegisterUseCase>(
    () => RegisterUseCase(locator<IAuthRepository>()),
  );
  locator.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(locator<IAuthRepository>()),
  );

  locator.registerLazySingleton<ResetPasswordUseCase>(
    () => ResetPasswordUseCase(locator<IAuthRepository>()),
  );
  locator.registerLazySingleton<GoogleSignUseCase>(
    () => GoogleSignUseCase(locator<IAuthRepository>()),
  );

  //*Home
  locator.registerLazySingleton<GetOffersUseCase>(
    () => GetOffersUseCase(locator<IHomeRepository>()),
  );
  locator.registerLazySingleton<GetCategoriesUseCase>(
    () => GetCategoriesUseCase(locator<IHomeRepository>()),
  );
  locator.registerLazySingleton<GetRestaurantsUseCase>(
    () => GetRestaurantsUseCase(locator<IHomeRepository>()),
  );
  locator.registerLazySingleton<GetProductsUseCase>(
    () => GetProductsUseCase(locator<IHomeRepository>()),
  );
}

//?Blocs
void _initBlocs() {
  //*Auth
  locator.registerFactory<LoginBloc>(
    () => LoginBloc(locator<LoginUseCase>(), locator<GoogleSignUseCase>()),
  );
  locator.registerFactory<RegisterBloc>(
    () => RegisterBloc(locator<RegisterUseCase>()),
  );
  //*Home
  locator.registerFactory<HomeBloc>(
    () => HomeBloc(
      locator<GetOffersUseCase>(),
      locator<GetCategoriesUseCase>(),
      locator<GetRestaurantsUseCase>(),
      locator<GetProductsUseCase>(),
    ),
  );
}
