import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_chef/core/errors/error_types.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/core/utils/network_helper.dart';
import 'package:your_chef/features/categories/domain/entities/category.dart';
import 'package:your_chef/features/home/domain/entities/offer.dart';
import 'package:your_chef/features/foods/domain/entities/food.dart';
import 'package:your_chef/features/restaurants/domain/entities/restaurant.dart';
import 'package:your_chef/features/home/domain/usecases/get_categories_usecase.dart';
import 'package:your_chef/features/home/domain/usecases/get_offers_usecase.dart';
import 'package:your_chef/features/home/domain/usecases/get_on_sale_foods_usecase.dart';
import 'package:your_chef/features/home/domain/usecases/get_popular_foods_usecase.dart';
import 'package:your_chef/features/home/domain/usecases/get_restaurants_usecase.dart';

part 'home_events.dart';
part 'home_states.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetOffersUseCase getOffersUseCase;
  final GetCategoriesUseCase getCategoriesUseCase;
  final GetRestaurantsUseCase getRestaurantsUseCase;
  final GetPopularFoodsUseCase getPopularProductsUseCase;
  final GetOnSaleFoodsUseCase getOnSaleProductsUseCase;
  HomeBloc(
    this.getOffersUseCase,
    this.getCategoriesUseCase,
    this.getRestaurantsUseCase,
    this.getPopularProductsUseCase,
    this.getOnSaleProductsUseCase,
  ) : super(
          const HomeState(),
        ) {
    on<GetHomeDataEvent>(_getData);
  }

  FutureOr<void> _getData(
      GetHomeDataEvent event, Emitter<HomeState> emit) async {
    emit(
      state.copyWith(
        offers: const [],
        categories: const [],
        restaurants: const [],
        popularProducts: const [],
        onSaleProducts: const [],
        error: '',
        errorType: ErrorType.normal,
        status: RequestStatus.loading,
      ),
    );

    final List<Either<Failure, List>> data = await Future.wait([
      getOffersUseCase(),
      getCategoriesUseCase(),
      getRestaurantsUseCase(),
      getPopularProductsUseCase(),
      getOnSaleProductsUseCase(),
    ]);

    data[0].fold((failure) {
      if (failure is NetworkFailure) {
        emit(state.copyWith(
          offers: const [],
          categories: const [],
          restaurants: const [],
          popularProducts: const [],
          onSaleProducts: const [],
          error: failure.message,
          errorType: ErrorType.network,
          status: RequestStatus.failure,
        ));
      } else {
        emit(state.copyWith(
          offers: const [],
          categories: const [],
          restaurants: const [],
          popularProducts: const [],
          onSaleProducts: const [],
          error: failure.message,
          errorType: ErrorType.normal,
          status: RequestStatus.failure,
        ));
      }
    }, (offers) {
      data[1].fold((failure) {
        if (failure is NetworkFailure) {
          emit(state.copyWith(
            offers: const [],
            categories: const [],
            restaurants: const [],
            popularProducts: const [],
            onSaleProducts: const [],
            error: failure.message,
            errorType: ErrorType.network,
            status: RequestStatus.failure,
          ));
        } else {
          emit(state.copyWith(
            offers: const [],
            categories: const [],
            restaurants: const [],
            popularProducts: const [],
            onSaleProducts: const [],
            error: failure.message,
            errorType: ErrorType.normal,
            status: RequestStatus.failure,
          ));
        }
      }, (categories) {
        data[2].fold((failure) {
          if (failure is NetworkFailure) {
            emit(state.copyWith(
              offers: const [],
              categories: const [],
              restaurants: const [],
              popularProducts: const [],
              onSaleProducts: const [],
              error: failure.message,
              errorType: ErrorType.network,
              status: RequestStatus.failure,
            ));
          } else {
            emit(state.copyWith(
              offers: const [],
              categories: const [],
              restaurants: const [],
              popularProducts: const [],
              onSaleProducts: const [],
              error: failure.message,
              errorType: ErrorType.normal,
              status: RequestStatus.failure,
            ));
          }
        }, (restaurants) {
          data[3].fold((failure) {
            if (failure is NetworkFailure) {
              emit(state.copyWith(
                offers: const [],
                categories: const [],
                restaurants: const [],
                popularProducts: const [],
                onSaleProducts: const [],
                error: failure.message,
                errorType: ErrorType.network,
                status: RequestStatus.failure,
              ));
            } else {
              emit(state.copyWith(
                offers: const [],
                categories: const [],
                restaurants: const [],
                popularProducts: const [],
                onSaleProducts: const [],
                error: failure.message,
                errorType: ErrorType.normal,
                status: RequestStatus.failure,
              ));
            }
          }, (popularProducts) {
            data[4].fold((failure) {
              if (failure is NetworkFailure) {
                emit(state.copyWith(
                  offers: const [],
                  categories: const [],
                  restaurants: const [],
                  popularProducts: const [],
                  onSaleProducts: const [],
                  error: failure.message,
                  errorType: ErrorType.network,
                  status: RequestStatus.failure,
                ));
              } else {
                emit(state.copyWith(
                  offers: const [],
                  categories: const [],
                  restaurants: const [],
                  popularProducts: const [],
                  onSaleProducts: const [],
                  error: failure.message,
                  errorType: ErrorType.normal,
                  status: RequestStatus.failure,
                ));
              }
            }, (onSaleProducts) {
              emit(
                state.copyWith(
                  offers: List.from(offers),
                  categories: List.from(categories),
                  restaurants: List.from(restaurants),
                  popularProducts: List.from(popularProducts),
                  onSaleProducts: List.from(onSaleProducts),
                  error: '',
                  errorType: ErrorType.normal,
                  status: RequestStatus.success,
                ),
              );
            });
          });
        });
      });
    });
  }
}
