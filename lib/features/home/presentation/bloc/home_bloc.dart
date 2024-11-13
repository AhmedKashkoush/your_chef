import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_chef/core/errors/error_types.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/core/utils/network_helper.dart';
import 'package:your_chef/features/home/domain/entities/category.dart';
import 'package:your_chef/features/home/domain/entities/offer.dart';
import 'package:your_chef/features/home/domain/entities/product.dart';
import 'package:your_chef/features/home/domain/entities/restaurant.dart';
import 'package:your_chef/features/home/domain/usecases/get_categories_usecase.dart';
import 'package:your_chef/features/home/domain/usecases/get_offers_usecase.dart';
import 'package:your_chef/features/home/domain/usecases/get_products_usecase.dart';
import 'package:your_chef/features/home/domain/usecases/get_restaurants_usecase.dart';

part 'home_events.dart';
part 'home_states.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetOffersUseCase getOffersUseCase;
  final GetCategoriesUseCase getCategoriesUseCase;
  final GetRestaurantsUseCase getRestaurantsUseCase;
  final GetProductsUseCase getProductsUseCase;
  HomeBloc(
    this.getOffersUseCase,
    this.getCategoriesUseCase,
    this.getRestaurantsUseCase,
    this.getProductsUseCase,
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
        products: const [],
        error: '',
        errorType: ErrorType.normal,
        status: RequestStatus.loading,
      ),
    );

    final List<Either<Failure, List>> data = await Future.wait([
      getOffersUseCase(),
      getCategoriesUseCase(),
      getRestaurantsUseCase(),
      getProductsUseCase(),
    ]);

    data[0].fold((failure) {
      if (failure is NetworkFailure) {
        emit(state.copyWith(
          offers: const [],
          categories: const [],
          restaurants: const [],
          products: const [],
          error: failure.message,
          errorType: ErrorType.network,
          status: RequestStatus.failure,
        ));
      } else {
        emit(state.copyWith(
          offers: const [],
          categories: const [],
          restaurants: const [],
          products: const [],
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
            products: const [],
            error: failure.message,
            errorType: ErrorType.network,
            status: RequestStatus.failure,
          ));
        } else {
          emit(state.copyWith(
            offers: const [],
            categories: const [],
            restaurants: const [],
            products: const [],
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
              products: const [],
              error: failure.message,
              errorType: ErrorType.network,
              status: RequestStatus.failure,
            ));
          } else {
            emit(state.copyWith(
              offers: const [],
              categories: const [],
              restaurants: const [],
              products: const [],
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
                products: const [],
                error: failure.message,
                errorType: ErrorType.network,
                status: RequestStatus.failure,
              ));
            } else {
              emit(state.copyWith(
                offers: const [],
                categories: const [],
                restaurants: const [],
                products: const [],
                error: failure.message,
                errorType: ErrorType.normal,
                status: RequestStatus.failure,
              ));
            }
          }, (products) {
            emit(
              state.copyWith(
                offers: List.from(offers),
                categories: List.from(categories),
                restaurants: List.from(restaurants),
                products: List.from(products),
                error: '',
                errorType: ErrorType.normal,
                status: RequestStatus.success,
              ),
            );
          });
        });
      });
    });
  }
}
