import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:your_chef/core/widgets/loading/skeleton_loading_widget.dart';

import 'package:your_chef/features/restaurants/domain/entities/restaurant.dart';

class RestaurantMapTile extends StatefulWidget {
  final Restaurant restaurant;
  const RestaurantMapTile({
    super.key,
    required this.restaurant,
  });

  @override
  State<RestaurantMapTile> createState() => _RestaurantMapTileState();
}

class _RestaurantMapTileState extends State<RestaurantMapTile> {
  late final MapController _mapController;

  @override
  void initState() {
    _mapController = MapController(
      initPosition: GeoPoint(
        latitude: widget.restaurant.latitude,
        longitude: widget.restaurant.longitude,
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: SizedBox(
        width: double.infinity,
        height: 200.h,
        child: OSMFlutter(
          mapIsLoading: SkeletonLoadingWidget(
            loading: true,
            child: Container(
              color: Colors.red,
            ),
          ),
          onMapIsReady: (ready) {
            _mapController.addMarker(
              GeoPoint(
                latitude: widget.restaurant.latitude,
                longitude: widget.restaurant.longitude,
              ),
            );
          },
          osmOption: const OSMOption(
            zoomOption: ZoomOption(
              initZoom: 8,
              minZoomLevel: 3,
              maxZoomLevel: 19,
              stepZoom: 1.0,
            ),
          ),
          controller: _mapController,
        ),
      ),
    );
  }
}
