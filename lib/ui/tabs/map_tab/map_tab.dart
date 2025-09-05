import 'package:collection/collection.dart';
import 'package:evently_app/model/event_model.dart';
import 'package:evently_app/providers/app_theme_provider.dart';
import 'package:evently_app/providers/event_list_providers.dart';
import 'package:evently_app/providers/user_provider.dart';
import 'package:evently_app/ui/tabs/home_tab/event_details/event_details_screen.dart';
import 'package:evently_app/ui/tabs/map_tab/map_tab_view_model..dart';
import 'package:evently_app/utils/app_colors.dart';
import 'package:evently_app/utils/app_image.dart';
import 'package:evently_app/utils/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MapTab extends StatelessWidget {
  const MapTab({super.key});

  final CameraPosition _initialPosition = const CameraPosition(
    zoom: 10,
    target: LatLng(30.02, 31.14),
  );

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MapTabViewModel(),
      child: Consumer3<MapTabViewModel, EventListProvider, UserProvider>(
        builder: (context, vm, eventListProvider, userProvider, _) {
          final themeProvider =
              Provider.of<AppThemeProvider>(context, listen: false);

          vm.loadEvents(eventListProvider, userProvider, context);

          return Scaffold(
            body: Stack(
              children: [
                GoogleMap(
                  myLocationButtonEnabled: false,
                  myLocationEnabled: false,
                  zoomControlsEnabled: false,
                  initialCameraPosition: _initialPosition,
                  circles: _buildCircles(eventListProvider, vm),
                  onMapCreated: vm.setMapController,
                ),
                if (vm.selectedEventId != null)
                  _buildInfoWindow(context, eventListProvider, vm),
                Positioned(
                  bottom: 32,
                  left: 24,
                  right: 0,
                  child: SizedBox(
                    height: 110,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: eventListProvider.allEventsList.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final event = eventListProvider.allEventsList[index];
                        return GestureDetector(
                          onTap: () => vm.onEventSelected(event),
                          child: _buildEventItem(event, context),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            floatingActionButton: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: FloatingActionButton(
                onPressed: vm.moveToUserLocation,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                backgroundColor: AppColors.primaryColor,
                child: Icon(
                  Icons.my_location,
                  color: themeProvider.isLightTheme()
                      ? AppColors.whiteColor
                      : AppColors.navyColor,
                  size: 32,
                ),
              ),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
          );
        },
      ),
    );
  }

  Widget _buildInfoWindow(
      BuildContext context, EventListProvider provider, MapTabViewModel vm) {
    final themeProvider = Provider.of<AppThemeProvider>(context, listen: false);

    final event = provider.allEventsList
        .firstWhereOrNull((e) => e.id == vm.selectedEventId);
    if (event == null) return const SizedBox.shrink();

    return Positioned(
      top: 80,
      left: 20,
      right: 20,
      child: Card(
        color: themeProvider.isLightTheme()
            ? AppColors.whiteColor
            : AppColors.navyColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(event.title, style: AppStyle.bold16Primary),
              const SizedBox(height: 6),
              Text("${event.city}, ${event.country}",
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    EventDetailsScreen.routeName,
                    arguments: event,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  AppLocalizations.of(context)!.viewDetails,
                  style: AppStyle.bold14White,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Set<Circle> _buildCircles(EventListProvider provider, MapTabViewModel vm) {
    return provider.allEventsList.map((event) {
      final isSelected = event.id == vm.selectedEventId;
      return Circle(
        circleId: CircleId(event.id),
        center: LatLng(event.location.latitude, event.location.longitude),
        radius: 40,
        fillColor: isSelected ? AppColors.primaryColor : Colors.black,
        strokeColor: isSelected
            ? AppColors.primaryColor.withValues(alpha: 0.4)
            : Colors.black.withValues(alpha: 0.3),
        strokeWidth: 10,
      );
    }).toSet();
  }

  Widget _buildEventItem(EventModel event, BuildContext context) {
    final themeProvider = Provider.of<AppThemeProvider>(context, listen: false);

    return Container(
      height: 100,
      width: 300,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: themeProvider.isLightTheme()
            ? AppColors.nodeWhiteColor
            : AppColors.navyColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryColor, width: 2),
      ),
      child: Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image(
                image: AssetImage(event.image),
                height: 80,
                width: 80,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: AppStyle.bold16Primary,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Image.asset(
                      AppImage.mapIcon,
                      color: themeProvider.isLightTheme()
                          ? AppColors.blackColor
                          : AppColors.whiteColor,
                      height: 20,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '${event.city} , ${event.country}',
                        style: Theme.of(context).textTheme.bodyMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
