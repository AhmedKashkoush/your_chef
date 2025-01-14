import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_chef/core/constants/strings.dart';
import 'package:your_chef/core/dummy/dummy_data.dart';
import 'package:your_chef/core/extensions/media_query_extension.dart';
import 'package:your_chef/core/extensions/space_extension.dart';
import 'package:your_chef/core/widgets/errors/custom_error_widget.dart';
import 'package:your_chef/core/widgets/loading/skeleton_loading_widget.dart';
import 'package:your_chef/features/home/presentation/bloc/offers/get_home_offers_bloc.dart';
import 'package:your_chef/features/home/presentation/widgets/sections/section_header.dart';
import 'package:your_chef/features/offers/domain/entities/offer.dart';
import 'package:your_chef/core/widgets/items/offer_item.dart';

class OffersSection extends StatelessWidget {
  const OffersSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetHomeOffersBloc, GetHomeOffersState>(
      builder: (context, state) {
        bool loading = state is GetHomeOffersLoadingState;
        if (state is GetHomeOffersInitialState ||
            (state is GetHomeOffersSuccessState && state.offers.isEmpty)) {
          return const SizedBox.shrink();
        }
        if (state is GetHomeOffersErrorState) {
          return CustomErrorWidget(
            error: state.error,
            type: state.errorType,
            onRetry: () => context.read<GetHomeOffersBloc>().add(
                  const GetHomeOffersEventStarted(),
                ),
          );
        }
        return SkeletonLoadingWidget(
          loading: loading,
          child: _buildOffers(
            context,
            offers: state is GetHomeOffersLoadingState
                ? _loadingOffers
                : state is GetHomeOffersSuccessState
                    ? state.offers
                    : [],
            loading: loading,
          ),
        );
      },
    );
  }

  List<Offer> get _loadingOffers => [AppDummies.offers.first.toEntity()];
  Widget _buildOffers(BuildContext context,
      {required List<Offer> offers, required bool loading}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SectionHeader(
          title: AppStrings.todaysOffers.tr(),
          // onPressed: () {},
        ),
        10.height,
        RepaintBoundary(
          child: CarouselSlider(
            options: CarouselOptions(
              viewportFraction: 1,
              aspectRatio: context.isLandscape ? 9 / 3 : 16 / 9,
              autoPlay: !loading,
              enlargeCenterPage: true,
            ),
            items: offers
                .map(
                  (offer) => OfferItem(offer: offer),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
