import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:your_chef/features/auth/data/sources/remote/auth_remote_data_source.dart';
import 'package:your_chef/features/auth/domain/repositories/auth_repository.dart';
import 'package:your_chef/features/auth/domain/usecases/auth/login_usecase.dart';
import 'package:your_chef/features/auth/domain/usecases/auth/register_usecase.dart';
import 'package:your_chef/features/auth/domain/usecases/auth/reset_password_usecase.dart';
import 'package:your_chef/features/auth/domain/usecases/auth/send_otp_usecase.dart';
import 'package:your_chef/features/auth/domain/usecases/auth/upload_profile_photo_usecase.dart';
import 'package:your_chef/features/auth/domain/usecases/auth/verify_otp_usecase.dart';
import 'package:your_chef/features/auth/domain/usecases/user/signout_usecase.dart';
import 'package:your_chef/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:your_chef/features/auth/presentation/bloc/register/register_bloc.dart';
import 'package:your_chef/features/auth/presentation/bloc/upload_profile_photo/upload_profile_photo_bloc.dart';
import 'package:your_chef/features/auth/presentation/bloc/verify/verify_bloc.dart';
import 'package:your_chef/features/categories/data/repositories/category_repository_impl.dart';
import 'package:your_chef/features/categories/data/sources/remote/category_remote_data_source.dart';
import 'package:your_chef/features/categories/domain/repositories/category_repository.dart';
import 'package:your_chef/features/categories/domain/usecases/get_all_categories_usecase.dart';
import 'package:your_chef/features/foods/data/repositories/food_repository_impl.dart';
import 'package:your_chef/features/foods/data/sources/remote/food_remote_data_source.dart';
import 'package:your_chef/features/foods/domain/repositories/food_repository.dart';
import 'package:your_chef/features/categories/domain/usecases/get_categories_usecase.dart';
import 'package:your_chef/features/foods/domain/usecases/foods/get_foods_by_category_usecase.dart';
import 'package:your_chef/features/foods/presentation/blocs/explore/categories/get_explore_categories_bloc.dart';
import 'package:your_chef/features/foods/presentation/blocs/explore/foods/get_explore_foods_bloc.dart';
import 'package:your_chef/features/home/presentation/bloc/categories/get_home_categories_bloc.dart';
import 'package:your_chef/features/home/presentation/bloc/offers/get_home_offers_bloc.dart';
import 'package:your_chef/features/home/presentation/bloc/on_a_sale/get_home_on_sale_foods_bloc.dart';
import 'package:your_chef/features/home/presentation/bloc/popular_foods/get_home_popular_foods_bloc.dart';
import 'package:your_chef/features/home/presentation/bloc/restaurants/get_home_restaurants_bloc.dart';
import 'package:your_chef/features/offers/data/repositories/offer_repository_impl.dart';
import 'package:your_chef/features/offers/data/sources/remote/offer_remote_data_source.dart';
import 'package:your_chef/features/offers/domain/repositories/offer_repository.dart';
import 'package:your_chef/features/offers/domain/usecases/get_offers_usecase.dart';
import 'package:your_chef/features/foods/domain/usecases/foods/get_popular_foods_usecase.dart';
import 'package:your_chef/features/restaurants/domain/usecases/get_popular_restaurants_usecase.dart';
import 'package:your_chef/features/restaurants/data/repositories/restaurant_repository_impl.dart';
import 'package:your_chef/features/restaurants/data/sources/remote/restaurant_remote_data_source.dart';
import 'package:your_chef/features/restaurants/domain/repositories/restaurant_repository.dart';
import 'package:your_chef/features/foods/domain/usecases/foods/get_restaurant_foods_usecase.dart';
import 'package:your_chef/features/offers/domain/usecases/get_restaurant_offers_usecase.dart';
import 'package:your_chef/features/restaurants/presentation/bloc/menu/get_restaurant_menu_bloc.dart';
import 'package:your_chef/features/restaurants/presentation/bloc/offers/get_restaurant_offers_bloc.dart';
import 'package:your_chef/features/auth/data/repositories/user_repository_impl.dart';
import 'package:your_chef/features/auth/data/sources/local/user_local_data_source.dart';
import 'package:your_chef/features/auth/data/sources/remote/user_remote_data_source.dart';
import 'package:your_chef/features/auth/domain/repositories/user_repository.dart';
import 'package:your_chef/features/auth/domain/usecases/user/delete_saved_user_usecase.dart';
import 'package:your_chef/features/auth/domain/usecases/user/delete_user_usecase.dart';
import 'package:your_chef/features/auth/domain/usecases/user/get_saved_users_usecase.dart';
import 'package:your_chef/features/auth/domain/usecases/user/get_user_usecase.dart';
import 'package:your_chef/features/auth/domain/usecases/user/save_user_usecase.dart';
import 'package:your_chef/features/auth/domain/usecases/user/switch_user_usecase.dart';
import 'package:your_chef/features/auth/domain/usecases/user/update_user_usecase.dart';
import 'package:your_chef/common/blocs/user/user_bloc.dart';
import 'package:your_chef/features/foods/data/repositories/wishlist_repository_impl.dart';
import 'package:your_chef/features/foods/data/sources/remote/wishlist_remote_data_source.dart';
import 'package:your_chef/features/foods/domain/repositories/wishlist_repository.dart';
import 'package:your_chef/features/foods/domain/usecases/wishlist/add_food_to_wishlist_usecase.dart';
import 'package:your_chef/features/foods/domain/usecases/wishlist/get_foods_wishlist_usecase.dart';
import 'package:your_chef/features/foods/domain/usecases/wishlist/remove_food_from_wishlist_usecase.dart';
import 'package:your_chef/common/blocs/wishlist/wishlist_bloc.dart';
import 'package:your_chef/features/settings/presentation/bloc/signout/signout_bloc.dart';
import 'package:your_chef/features/settings/presentation/bloc/switch_account/switch_account_bloc.dart';

import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/usecases/auth/google_sign_in_usecase.dart';
import 'features/auth/presentation/bloc/google_sign_in/google_sign_in_bloc.dart';
import 'features/categories/presentation/bloc/get_all_categories_bloc.dart';
import 'features/foods/domain/usecases/foods/get_on_sale_foods_usecase.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  _initExternal();
  _initRemoteSources();
  _initLocalSources();
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
  //*User
  locator.registerLazySingleton<IUserRemoteDataSource>(
    () => SupabaseUserRemoteDataSource(
      locator<SupabaseClient>(),
    ),
  );

  //*Offers
  locator.registerLazySingleton<IOfferRemoteDataSource>(
    () => SupabaseOfferRemoteDataSource(
      locator<SupabaseClient>(),
    ),
  );

  //*Categories
  locator.registerLazySingleton<ICategoryRemoteDataSource>(
    () => SupabaseCategoryRemoteDataSource(
      locator<SupabaseClient>(),
    ),
  );

  //*Restaurants
  locator.registerLazySingleton<IRestaurantRemoteDataSource>(
    () => SupabaseRestaurantRemoteDataSource(
      locator<SupabaseClient>(),
    ),
  );

  //*Foods
  locator.registerLazySingleton<IFoodRemoteDataSource>(
    () => SupabaseFoodRemoteDataSource(
      locator<SupabaseClient>(),
    ),
  );

  //*Wishlist
  locator.registerLazySingleton<IWishlistRemoteDataSource>(
    () => SupabaseWishlistRemoteDataSource(
      locator<SupabaseClient>(),
    ),
  );
}

//? Local Sources
void _initLocalSources() {
  //*User
  locator.registerLazySingleton<IUserLocalDataSource>(
    () => const SecureStorageUserLocalDataSource(),
  );
}

//? Repositories
void _initRepositories() {
  //*Auth
  locator.registerLazySingleton<IAuthRepository>(
    () => AuthRepository(locator<IAuthRemoteDataSource>()),
  );
  //*User
  locator.registerLazySingleton<IUserRepository>(
    () => UserRepository(
      remoteDataSource: locator<IUserRemoteDataSource>(),
      localDataSource: locator<IUserLocalDataSource>(),
    ),
  );

  //*Offers
  locator.registerLazySingleton<IOfferRepository>(
    () => OfferRepository(locator<IOfferRemoteDataSource>()),
  );

  //*Categories
  locator.registerLazySingleton<ICategoryRepository>(
    () => CategoryRepository(locator<ICategoryRemoteDataSource>()),
  );
  //*Restaurants
  locator.registerLazySingleton<IRestaurantRepository>(
    () => RestaurantRepository(locator<IRestaurantRemoteDataSource>()),
  );
  //*Foods
  locator.registerLazySingleton<IFoodRepository>(
    () => FoodRepository(locator<IFoodRemoteDataSource>()),
  );
  //*Wishlist
  locator.registerLazySingleton<IWishlistRepository>(
    () => WishlistRepository(locator<IWishlistRemoteDataSource>()),
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

  //*User
  locator.registerLazySingleton<GetUserUseCase>(
    () => GetUserUseCase(locator<IUserRepository>()),
  );
  locator.registerLazySingleton<GetSavedUsersUseCase>(
    () => GetSavedUsersUseCase(locator<IUserRepository>()),
  );
  locator.registerLazySingleton<UpdateUserUseCase>(
    () => UpdateUserUseCase(locator<IUserRepository>()),
  );
  locator.registerLazySingleton<DeleteUserUseCase>(
    () => DeleteUserUseCase(locator<IUserRepository>()),
  );
  locator.registerLazySingleton<DeleteSavedUserUseCase>(
    () => DeleteSavedUserUseCase(locator<IUserRepository>()),
  );
  locator.registerLazySingleton<SaveUserUseCase>(
    () => SaveUserUseCase(locator<IUserRepository>()),
  );
  locator.registerLazySingleton<SwitchUserUseCase>(
    () => SwitchUserUseCase(locator<IUserRepository>()),
  );
  locator.registerLazySingleton<SignOutUseCase>(
    () => SignOutUseCase(locator<IUserRepository>()),
  );

  //*Offers
  locator.registerLazySingleton<GetOffersUseCase>(
    () => GetOffersUseCase(locator<IOfferRepository>()),
  );

  //*Categories
  locator.registerLazySingleton<GetCategoriesUseCase>(
    () => GetCategoriesUseCase(locator<ICategoryRepository>()),
  );
  locator.registerLazySingleton<GetAllCategoriesUseCase>(
    () => GetAllCategoriesUseCase(locator<ICategoryRepository>()),
  );

  //*Restaurants
  locator.registerLazySingleton<GetPopularRestaurantsUseCase>(
    () => GetPopularRestaurantsUseCase(locator<IRestaurantRepository>()),
  );

  //*Foods
  locator.registerLazySingleton<GetPopularFoodsUseCase>(
    () => GetPopularFoodsUseCase(locator<IFoodRepository>()),
  );
  locator.registerLazySingleton<GetOnSaleFoodsUseCase>(
    () => GetOnSaleFoodsUseCase(locator<IFoodRepository>()),
  );
  locator.registerLazySingleton<GetFoodsByCategoryUseCase>(
    () => GetFoodsByCategoryUseCase(locator<IFoodRepository>()),
  );
  locator.registerLazySingleton<GetRestaurantFoodsUseCase>(
    () => GetRestaurantFoodsUseCase(locator<IFoodRepository>()),
  );
  locator.registerLazySingleton<GetRestaurantOffersUseCase>(
    () => GetRestaurantOffersUseCase(locator<IOfferRepository>()),
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
}

//?Blocs
void _initBlocs() {
  //*Auth
  locator.registerFactory<LoginBloc>(
    () => LoginBloc(locator<LoginUseCase>()),
  );
  locator.registerFactory<GoogleSignInBloc>(
    () => GoogleSignInBloc(locator<GoogleSignUseCase>()),
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

  //*User
  locator.registerFactory<UserBloc>(
    () => UserBloc(
      deleteSavedUserUseCase: locator<DeleteSavedUserUseCase>(),
      getUserUseCase: locator<GetUserUseCase>(),
      getSavedUsersUseCase: locator<GetSavedUsersUseCase>(),
      saveUserUseCase: locator<SaveUserUseCase>(),
      switchUserUseCase: locator<SwitchUserUseCase>(),
      updateUserUseCase: locator<UpdateUserUseCase>(),
      deleteUserUseCase: locator<DeleteUserUseCase>(),
    ),
  );
  //*Home
  locator.registerFactory<GetHomeOffersBloc>(
    () => GetHomeOffersBloc(locator<GetOffersUseCase>()),
  );
  locator.registerFactory<GetHomeCategoriesBloc>(
    () => GetHomeCategoriesBloc(locator<GetCategoriesUseCase>()),
  );
  locator.registerFactory<GetHomeRestaurantsBloc>(
    () => GetHomeRestaurantsBloc(locator<GetPopularRestaurantsUseCase>()),
  );
  locator.registerFactory<GetHomePopularFoodsBloc>(
    () => GetHomePopularFoodsBloc(locator<GetPopularFoodsUseCase>()),
  );
  locator.registerFactory<GetHomeOnSaleFoodsBloc>(
    () => GetHomeOnSaleFoodsBloc(locator<GetOnSaleFoodsUseCase>()),
  );
  //*Explore Foods
  locator.registerFactory<GetExploreFoodsBloc>(
    () => GetExploreFoodsBloc(
      locator<GetPopularFoodsUseCase>(),
      locator<GetOnSaleFoodsUseCase>(),
      locator<GetFoodsByCategoryUseCase>(),
    ),
  );
  locator.registerFactory<GetExploreCategoriesBloc>(
    () => GetExploreCategoriesBloc(
      locator<GetAllCategoriesUseCase>(),
    ),
  );

  //*Categories
  locator.registerFactory<GetAllCategoriesBloc>(
    () => GetAllCategoriesBloc(
      locator<GetAllCategoriesUseCase>(),
    ),
  );

  //*Restaurant
  locator.registerFactory<GetRestaurantOffersBloc>(
    () => GetRestaurantOffersBloc(
      locator<GetRestaurantOffersUseCase>(),
    ),
  );
  locator.registerFactory<GetRestaurantMenuBloc>(
    () => GetRestaurantMenuBloc(
      locator<GetRestaurantFoodsUseCase>(),
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
  locator.registerFactory<SignOutBloc>(
    () => SignOutBloc(
      locator<SignOutUseCase>(),
    ),
  );
  locator.registerFactory<SwitchAccountBloc>(
    () => SwitchAccountBloc(
      locator<SwitchUserUseCase>(),
    ),
  );
}
