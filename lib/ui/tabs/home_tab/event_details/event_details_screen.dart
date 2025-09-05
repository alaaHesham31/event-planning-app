import 'package:evently_app/model/event_model.dart';
import 'package:evently_app/providers/app_theme_provider.dart';
import 'package:evently_app/providers/event_list_providers.dart';
import 'package:evently_app/providers/user_provider.dart';
import 'package:evently_app/ui/tabs/home_tab/edit_event/edit_event_screen.dart';
import 'package:evently_app/ui/tabs/home_tab/event_details/event_details_view_model.dart';
import 'package:evently_app/utils/app_colors.dart';
import 'package:evently_app/utils/app_image.dart';
import 'package:evently_app/utils/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class EventDetailsScreen extends StatefulWidget {
  static const String routeName = 'event-details-screen';

  const EventDetailsScreen({super.key});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  GoogleMapController? mapController;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as EventModel;
    final themeProvider = Provider.of<AppThemeProvider>(context, listen: false);

    return ChangeNotifierProvider<EventDetailsViewModel>(
      create: (_) => EventDetailsViewModel(
        eventListProvider:
            Provider.of<EventListProvider>(context, listen: false),
        userProvider: Provider.of<UserProvider>(context, listen: false),
      )..loadEvent(args.id),
      child: Consumer<EventDetailsViewModel>(
        builder: (context, viewModel, _) {
          final event = viewModel.event;

          if (event != null && mapController != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              mapController?.animateCamera(
                CameraUpdate.newLatLng(event.location),
              );
            });
          }

          if (event == null) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return Scaffold(
            appBar: AppBar(
              title: Text(
                AppLocalizations.of(context)!.eventDetails,
                style: AppStyle.semi20Primary,
              ),
              iconTheme: const IconThemeData(color: AppColors.primaryColor),
              centerTitle: true,
              actions: [
                IconButton(
                  onPressed: () async {
                    await Navigator.pushNamed(
                      context,
                      EditEventScreen.routeName,
                      arguments: event,
                    );
                    viewModel.refresh();
                  },
                  icon: Image(image: AssetImage(AppImage.updateIcon)),
                ),
                IconButton(
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text(AppLocalizations.of(context)!.deleteEvent),
                        content: Text(AppLocalizations.of(context)!
                            .areYouSureYouWantToDeleteThisEvent),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child:
                                  Text(AppLocalizations.of(context)!.cancel)),
                          TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child:
                                  Text(AppLocalizations.of(context)!.delete)),
                        ],
                      ),
                    );

                    if (confirm == true) {
                      await viewModel.deleteEvent(event.id);
                      if (mounted) Navigator.pop(context);
                    }
                  },
                  icon: Image(image: AssetImage(AppImage.deleteIcon)),
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Image.asset(
                        event.image,
                        fit: BoxFit.fill,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(event.title, style: AppStyle.semi24Primary),
                    const SizedBox(height: 16),
                    _buildDateTimeCard(event, themeProvider),
                    const SizedBox(height: 12),
                    _buildLocationCard(event, themeProvider),
                    const SizedBox(height: 16),
                    _buildGoogleMap(event),
                    const SizedBox(height: 16),
                    Text(AppLocalizations.of(context)!.description,
                        style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 12),
                    Text(event.description,
                        style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDateTimeCard(EventModel event, AppThemeProvider themeProvider) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryColor),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppColors.primaryColor,
            ),
            child: Icon(
              Icons.calendar_month,
              color: themeProvider.isLightTheme()
                  ? AppColors.whiteColor
                  : AppColors.navyColor,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(DateFormat('dd-MM-yyyy').format(event.eventDate),
                  style: AppStyle.semi16Primary),
              Text(event.eventTime,
                  style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLocationCard(EventModel event, AppThemeProvider themeProvider) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryColor),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppColors.primaryColor,
            ),
            child: Icon(
              Icons.my_location,
              color: themeProvider.isLightTheme()
                  ? AppColors.whiteColor
                  : AppColors.navyColor,
            ),
          ),
          const SizedBox(width: 16),
          Text('${event.city} , ${event.country}',
              style: AppStyle.semi16Primary),
          const Spacer(),
          const Icon(Icons.arrow_forward_ios_rounded,
              color: AppColors.primaryColor, size: 20),
        ],
      ),
    );
  }

  Widget _buildGoogleMap(EventModel event) {
    return GestureDetector(
      onTap: () async {
        final url =
            "https://www.google.com/maps/search/?api=1&query=${event.location.latitude},${event.location.longitude}";
        if (await canLaunchUrl(Uri.parse(url))) {
          await launchUrl(Uri.parse(url));
        }
      },
      child: Container(
        height: 350,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.primaryColor, width: 2),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: GoogleMap(
            initialCameraPosition:
                CameraPosition(target: event.location, zoom: 10),
            onMapCreated: (controller) => mapController = controller,
            markers: {
              Marker(
                markerId: const MarkerId('displayed'),
                position: event.location,
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueRed),
              ),
            },
            zoomControlsEnabled: false,
            myLocationEnabled: false,
            scrollGesturesEnabled: false,
          ),
        ),
      ),
    );
  }
}
