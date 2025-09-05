import 'package:evently_app/providers/app_theme_provider.dart';
import 'package:evently_app/ui/tabs/home_tab/location_picker/location_picker_viewmodel.dart';
import 'package:evently_app/utils/app_colors.dart';
import 'package:evently_app/utils/app_style.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class LocationPickerScreen extends StatelessWidget {
  static const String routeName = 'location-picker-screen';

  const LocationPickerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<AppThemeProvider>(context, listen: false);

    return ChangeNotifierProvider(
      create: (_) => LocationPickerViewModel(),
      child: Consumer<LocationPickerViewModel>(
        builder: (context, viewModel, _) {
          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                title: Text(
                    AppLocalizations.of(context)!.pickEventLocation,
                  style: themeProvider.isLightTheme()
                      ? AppStyle.semi20White
                      : AppStyle.semi20Primary,
                ),
                backgroundColor: themeProvider.isLightTheme()
                    ? AppColors.primaryColor
                    : AppColors.navyColor,
                centerTitle: true,
              ),
              body: Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition:
                    const CameraPosition(target: LatLng(30.12, 31.2), zoom: 10),
                    onMapCreated: viewModel.onMapCreated,
                    markers: viewModel.selectedLocation == null
                        ? {}
                        : {
                      Marker(
                        markerId: const MarkerId("selected"),
                        position: viewModel.selectedLocation!,
                      ),
                    },
                    onTap: viewModel.selectLocation,
                    myLocationEnabled: false,
                    myLocationButtonEnabled: false,
                  ),

                  // Confirm button
                  if (viewModel.hasLocationSelected)
                    Positioned(
                      bottom: 20,
                      left: 20,
                      right: 20,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: themeProvider.isLightTheme()
                              ? AppColors.primaryColor
                              : AppColors.navyColor,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context, viewModel.selectedLocation);
                        },
                        child: Text(
                          "Confirm Location",
                          style: AppStyle.semi20White,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
