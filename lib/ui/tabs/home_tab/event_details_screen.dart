import 'package:evently_app/model/event_model.dart';
import 'package:evently_app/ui/tabs/home_tab/edit_event_screen.dart';
import 'package:evently_app/utils/app_colors.dart';
import 'package:evently_app/utils/app_image.dart';
import 'package:evently_app/utils/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class EventDetailsScreen extends StatelessWidget {
  static const String routeName = 'event-details-screen';

  EventDetailsScreen({super.key});

  GoogleMapController? mapController;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as EventModel;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.eventDetails,
          style: AppStyle.semi20Primary,
        ),
        iconTheme: IconThemeData(color: AppColors.primaryColor),
        centerTitle: true,
        backgroundColor: AppColors.nodeWhiteColor,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, EditEventScreen.routeName,
                  arguments: args);
            },
            icon: Image(
              image: AssetImage(AppImage.updateIcon),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Image(
              image: AssetImage(AppImage.deleteIcon),
            ),
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
                  args.image,
                  fit: BoxFit.fill,
                ),
              ),
              SizedBox(
                height: 24,
              ),
              Text(
                args.title,
                style: AppStyle.semi24Primary,
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.primaryColor,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: AppColors.primaryColor,
                      ),
                      child: Icon(
                        Icons.calendar_month,
                        color: AppColors.whiteColor,
                      ),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat('dd-MM-yyyy').format(args.eventDate),
                          style: AppStyle.semi16Primary,
                        ),
                        Text(
                          args.eventTime,
                          style: AppStyle.semi16Black,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.primaryColor,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: AppColors.primaryColor,
                      ),
                      child: Icon(
                        Icons.my_location,
                        color: AppColors.whiteColor,
                      ),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Text(
                      '${args.city} , ${args.country}',
                      style: AppStyle.semi16Primary,
                    ),
                    Spacer(),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: AppColors.primaryColor,
                      size: 20,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 16,
              ),
              GestureDetector(
                onTap: () async {
                  final url =
                      "https://www.google.com/maps/search/?api=1&query=${args.location.latitude},${args.location.longitude}";
                  if (await canLaunchUrl(Uri.parse(url))) {
                    await launchUrl(Uri.parse(url));
                  }
                },
                child: Container(
                  height: 350,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.primaryColor,
                      width: 2,
                    ),
                  ),
                  // clipBehavior: Clip.antiAlias,
                  child: GoogleMap(
                    initialCameraPosition:
                        CameraPosition(target: args.location, zoom: 10),
                    onMapCreated: (controller) => mapController = controller,
                    markers: {
                      Marker(
                        markerId: MarkerId('displayed'),
                        position: args.location,
                        // Blue pin
                      ),
                    },
                    zoomControlsEnabled: false,
                    myLocationEnabled: false,
                    scrollGesturesEnabled: false,
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                AppLocalizations.of(context)!.description,
                style: AppStyle.semi16Black,
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                args.description,
                style: AppStyle.semi16Black,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
