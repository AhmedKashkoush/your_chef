import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:your_chef/features/auth/data/sources/remote/auth_remote_data_source.dart';
import 'package:your_chef/features/auth/domain/repositories/auth_repository.dart';
import 'package:your_chef/features/auth/domain/usecases/login_usecase.dart';
import 'package:your_chef/features/auth/domain/usecases/register_usecase.dart';
import 'package:your_chef/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:your_chef/features/auth/domain/usecases/send_otp_usecase.dart';
import 'package:your_chef/features/auth/domain/usecases/upload_profile_photo_usecase.dart';
import 'package:your_chef/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:your_chef/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:your_chef/features/auth/presentation/bloc/register/register_bloc.dart';
import 'package:your_chef/features/auth/presentation/bloc/upload_profile_photo/upload_profile_photo_bloc.dart';
import 'package:your_chef/features/auth/presentation/bloc/verify/verify_bloc.dart';
import 'package:your_chef/features/home/data/repositories/home_repository_impl.dart';
import 'package:your_chef/features/home/data/sources/remote/home_remote_data_source.dart';
import 'package:your_chef/features/home/domain/repositories/home_repository.dart';
import 'package:your_chef/features/home/domain/usecases/get_categories_usecase.dart';
import 'package:your_chef/features/home/domain/usecases/get_offers_usecase.dart';
import 'package:your_chef/features/home/domain/usecases/get_popular_products_usecase.dart';
import 'package:your_chef/features/home/domain/usecases/get_restaurants_usecase.dart';
import 'package:your_chef/features/restaurants/data/repositories/restaurant_repository_impl.dart';
import 'package:your_chef/features/restaurants/data/sources/remote/restaurant_remote_data_source.dart';
import 'package:your_chef/features/restaurants/domain/repositories/restaurant_repository.dart';
import 'package:your_chef/features/restaurants/domain/usecases/get_restaurant_menu_usecase.dart';
import 'package:your_chef/features/restaurants/domain/usecases/get_restaurant_offers_usecase.dart';
import 'package:your_chef/features/restaurants/presentation/bloc/restaurant_bloc.dart';
import 'package:your_chef/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:your_chef/features/settings/data/sources/remote/settings_remote_data_source.dart';
import 'package:your_chef/features/settings/domain/repositories/settings_repository.dart';
import 'package:your_chef/features/settings/domain/usecases/sign_out_usecase.dart';
import 'package:your_chef/features/settings/domain/usecases/switch_account_usecase.dart';
import 'package:your_chef/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:your_chef/features/wishlist/data/repositories/wishlist_repository_impl.dart';
import 'package:your_chef/features/wishlist/data/sources/remote/wishlist_remote_data_source.dart';
import 'package:your_chef/features/wishlist/domain/repositories/wishlist_repository.dart';
import 'package:your_chef/features/wishlist/domain/usecases/add_food_to_wishlist_usecase.dart';
import 'package:your_chef/features/wishlist/domain/usecases/get_foods_wishlist_usecase.dart';
import 'package:your_chef/features/wishlist/domain/usecases/remove_food_from_wishlist_usecase.dart';
import 'package:your_chef/features/wishlist/presentation/bloc/wishlist_bloc.dart';

import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/usecases/google_sign_in_usecase.dart';
import 'features/home/domain/usecases/get_on_sale_products_usecase.dart';
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
  //*Restaurant
  locator.registerLazySingleton<IRestaurantRemoteDataSource>(
    () => SupabaseRestaurantRemoteDataSource(
      locator<SupabaseClient>(),
    ),
  );

  //*Wishlist
  locator.registerLazySingleton<IWishlistRemoteDataSource>(
    () => SupabaseWishlistRemoteDataSource(
      locator<SupabaseClient>(),
    ),
  );

  //*Settings
  locator.registerLazySingleton<ISettingsRemoteDataSource>(
    () => SupabaseSettingsRemoteDataSource(
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
  //*Restaurant
  locator.registerLazySingleton<IRestaurantRepository>(
    () => RestaurantRepository(locator<IRestaurantRemoteDataSource>()),
  );
  //*Wishlist
  locator.registerLazySingleton<IWishlistRepository>(
    () => WishlistRepository(locator<IWishlistRemoteDataSource>()),
  );
  //*Settings
  locator.registerLazySingleton<ISettingsRepository>(
    () => SettingsRepository(locator<ISettingsRemoteDataSource>()),
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
  locator.registerLazySingleton<UploadProfilePhotoUseCase>(
    () => UploadProfilePhotoUseCase(locator<IAuthRepository>()),
  );
  locator.registerLazySingleton<SendOtpUseCase>(
    () => SendOtpUseCase(locator<IAuthRepository>()),
  );
  locator.registerLazySingleton<VerifyOtpUseCase>(
    () => VerifyOtpUseCase(locator<IAuthRepository>()),
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
  locator.registerLazySingleton<GetPopularProductsUseCase>(
    () => GetPopularProductsUseCase(locator<IHomeRepository>()),
  );
  locator.registerLazySingleton<GetOnSaleProductsUseCase>(
    () => GetOnSaleProductsUseCase(locator<IHomeRepository>()),
  );

  //*Restaurant
  locator.registerLazySingleton<GetRestaurantMenuUseCase>(
    () => GetRestaurantMenuUseCase(locator<IRestaurantRepository>()),
  );
  locator.registerLazySingleton<GetRestaurantOffersUseCase>(
    () => GetRestaurantOffersUseCase(locator<IRestaurantRepository>()),
  );
  //*Wishlist
  locator.registerLazySingleton<GetFoodsWishlistUseCase>(
    () => GetFoodsWishlistUseCase(locator<IWishlistRepository>()),
  );
  locator.registerLazySingleton<AddFoodToWishlistUseCase>(
    () => AddFoodToWishlistUseCase(locator<IWishlistRepository>()),
  );
  locator.registerLazySingleton<RemoveFoodFromWishlistUseCase>(
    () => RemoveFoodFromWishlistUseCase(locator<IWishlistRepository>()),
  );
  //*Settings
  locator.registerLazySingleton<SignOutUseCase>(
    () => SignOutUseCase(locator<ISettingsRepository>()),
  );
  locator.registerLazySingleton<SwitchAccountUseCase>(
    () => SwitchAccountUseCase(locator<ISettingsRepository>()),
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
  locator.registerFactory<UploadProfilePhotoBloc>(
    () => UploadProfilePhotoBloc(locator<UploadProfilePhotoUseCase>()),
  );
  locator.registerFactory<VerifyBloc>(
    () => VerifyBloc(
      locator<SendOtpUseCase>(),
      locator<VerifyOtpUseCase>(),
    ),
  );
  //*Home
  locator.registerFactory<HomeBloc>(
    () => HomeBloc(
      locator<GetOffersUseCase>(),
      locator<GetCategoriesUseCase>(),
      locator<GetRestaurantsUseCase>(),
      locator<GetPopularProductsUseCase>(),
      locator<GetOnSaleProductsUseCase>(),
    ),
  );
  //*Restaurant
  locator.registerFactory<RestaurantBloc>(
    () => RestaurantBloc(
      locator<GetRestaurantOffersUseCase>(),
      locator<GetRestaurantMenuUseCase>(),
    ),
  );
  //*Wishlist
  locator.registerFactory<WishlistBloc>(
    () => WishlistBloc(
      locator<GetFoodsWishlistUseCase>(),
      locator<AddFoodToWishlistUseCase>(),
      locator<RemoveFoodFromWishlistUseCase>(),
    ),
  );
  //*Settings
  locator.registerFactory<SettingsBloc>(
    () => SettingsBloc(
      locator<SignOutUseCase>(),
      locator<SwitchAccountUseCase>(),
    ),
  );
}
