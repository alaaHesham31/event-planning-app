import 'package:evently_app/model/event_model.dart';
import 'package:evently_app/providers/app_theme_provider.dart';
import 'package:evently_app/providers/event_list_providers.dart';
import 'package:evently_app/providers/user_provider.dart';
import 'package:evently_app/ui/tabs/home_tab/add_event/location_picker_screen.dart';
import 'package:evently_app/ui/widgets/custom_elevated_button.dart';
import 'package:evently_app/ui/widgets/custom_text_field.dart';
import 'package:evently_app/ui/widgets/tab_event_item.dart';
import 'package:evently_app/utils/app_colors.dart';
import 'package:evently_app/utils/app_image.dart';
import 'package:evently_app/utils/app_style.dart';
import 'package:evently_app/utils/firebase_utils.dart';
import 'package:evently_app/utils/toast_msg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EditEventScreen extends StatefulWidget {
  static const String routeName = 'edit-details=screen';

  EditEventScreen({super.key});

  @override
  State<EditEventScreen> createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  var formKey = GlobalKey<FormState>();

  late TextEditingController titleController;
  late TextEditingController descriptionController;

  String? eventId;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String? formatedDate;
  String? formatedTime;
  String? selectedCountry;
  String? selectedCity;
  LatLng? selectedLocation;

  late String selectedImage;
  late String selectedEvent;

  late EventListProvider eventListProvider;
  late UserProvider userProvider;

  @override
  void initState() {
    super.initState();

    // We can’t use ModalRoute here, so defer it
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)!.settings.arguments as EventModel;

      setState(() {
        titleController = TextEditingController(text: args.title);
        descriptionController = TextEditingController(text: args.description);

        eventId = args.id;
        selectedImage = args.image;
        selectedEvent = args.eventName;
        selectedDate = args.eventDate;
        formatedDate = DateFormat('dd/MM/yyyy').format(selectedDate!);
        formatedTime = args.eventTime;
        selectedLocation = args.location;
        selectedCity = args.city;
        selectedCountry = args.country;

        // providers
        eventListProvider =
            Provider.of<EventListProvider>(context, listen: false);
        userProvider = Provider.of<UserProvider>(context, listen: false);

        final index =
            eventListProvider.categoryEventsNameList.indexOf(selectedEvent);
        if (index != -1) {
          eventListProvider.changeSelectedIndex(
            index,
            userProvider.currentUser!.id,
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final appThemeProvider = Provider.of<AppThemeProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.editEvent,
          style: AppStyle.semi20Primary,
        ),
        iconTheme: IconThemeData(color: AppColors.primaryColor),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Image.asset(
                  selectedImage,
                  fit: BoxFit.fill,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 50,
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: eventListProvider.categoryEventsNameList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          eventListProvider.changeSelectedIndex(
                            index,
                            userProvider.currentUser!.id,
                          );
                          selectedImage =
                              eventListProvider.eventImagesList[index];
                          selectedEvent =
                              eventListProvider.categoryEventsNameList[index];
                        });
                      },
                      child: TabEventItem(
                        backgroundSelectedColor: AppColors.primaryColor,
                        borderUnSelectedColor: AppColors.primaryColor,
                        selectedIconColor: appThemeProvider.isLightTheme()
                            ? AppColors.whiteColor
                            : AppColors.navyColor,
                        unSelectedIconColor: AppColors.primaryColor,
                        selectedTextStyle: appThemeProvider.isLightTheme()
                            ? AppStyle.bold14White
                            : AppStyle.bold14Black,
                        unSelectedTextStyle: AppStyle.bold14Primary,
                        isSelected: eventListProvider.selectedIndex == index,
                        eventName:
                            eventListProvider.categoryEventsNameList[index],
                        eventIconPath:
                            eventListProvider.categoryEventsIconList[index],
                      ),
                    );
                  },
                ),
              ),
              Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.title,
                      style: AppStyle.semi16Black,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    CustomTextField(
                      controller: titleController,
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Please Enter Event Title';
                        }
                        return null;
                      },
                      hintText: AppLocalizations.of(context)!.eventTitle,
                      textStyle: appThemeProvider.isLightTheme()
                          ? AppStyle.semi16Grey
                          : AppStyle.semi16White,
                      hintTextStyle: appThemeProvider.isLightTheme()
                          ? AppStyle.semi16Grey
                          : AppStyle.semi16White,
                      borderColor: appThemeProvider.isLightTheme()
                          ? AppColors.greyColor
                          : AppColors.whiteColor,
                      prefixIcon: Icon(Icons.edit),
                      prefixIconColor: appThemeProvider.isLightTheme()
                          ? AppColors.greyColor
                          : AppColors.whiteColor,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      AppLocalizations.of(context)!.description,
                      style: AppStyle.semi16Black,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    CustomTextField(
                      controller: descriptionController,
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Please Enter Event Description';
                        }
                        return null;
                      },
                      maxLines: 4,
                      hintText: AppLocalizations.of(context)!.eventDescription,
                      textStyle: appThemeProvider.isLightTheme()
                          ? AppStyle.semi16Grey
                          : AppStyle.semi16White,
                      hintTextStyle: appThemeProvider.isLightTheme()
                          ? AppStyle.semi16Grey
                          : AppStyle.semi16White,
                      borderColor: appThemeProvider.isLightTheme()
                          ? AppColors.greyColor
                          : AppColors.whiteColor,

                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: [
                        Image.asset(AppImage.eventDateIcon,
                          color: appThemeProvider.isLightTheme()
                              ? AppColors.blackColor
                              : AppColors.whiteColor,),
                        SizedBox(width: 12),
                        Text(
                          AppLocalizations.of(context)!.eventDate,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Spacer(),
                        InkWell(
                          onTap: chooseDate,
                          child: Text(
                            formatedDate ??
                                AppLocalizations.of(context)!.chooseDate,
                            style: AppStyle.semi16Primary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: [
                        Image.asset(AppImage.eventTimeIcon,
                          color: appThemeProvider.isLightTheme()
                              ? AppColors.blackColor
                              : AppColors.whiteColor,),
                        SizedBox(
                          width: 12,
                        ),
                        Text(
                          AppLocalizations.of(context)!.eventTime,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Spacer(),
                        InkWell(
                          onTap: chooseTime,
                          child: Text(
                            formatedTime ??
                                AppLocalizations.of(context)!.chooseTime,
                            style: AppStyle.semi16Primary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      AppLocalizations.of(context)!.location,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    InkWell(
                      onTap: () async {
                        final pickedLocation =
                            await Navigator.of(context).pushNamed(
                          LocationPickerScreen.routeName,
                        );

                        if (pickedLocation != null &&
                            pickedLocation is LatLng) {
                          print(
                              "User selected location: ${pickedLocation.latitude}, ${pickedLocation.longitude}");
                          // save to your EventModel
                          List<Placemark> placemarks =
                              await placemarkFromCoordinates(
                                  pickedLocation.latitude,
                                  pickedLocation.longitude);
                          selectedCountry = placemarks[0].country;
                          selectedCity = placemarks[0].subAdministrativeArea;
                          setState(() {});
                        }
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.primaryColor,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: AppColors.primaryColor,
                              ),
                              child: Icon(
                                Icons.my_location,
                                color: appThemeProvider.isLightTheme()
                                    ? AppColors.whiteColor
                                    : AppColors.navyColor,
                              ),
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Text(
                              '$selectedCity , $selectedCountry',
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
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    CustomElevatedButton(
                      onClick: () async {
                        updateEventDetails();
                      },
                      textStyle: AppStyle.semi20White,
                      text: AppLocalizations.of(context)!.updateEvent,
                    ),
                    SizedBox(
                      height: 22,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void chooseDate() async {
    var chooseDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        Duration(days: 356),
      ),
    );
    selectedDate = chooseDate;
    formatedDate = DateFormat('dd/MM/yyyy').format(selectedDate!);
    setState(() {});
  }

  void chooseTime() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        selectedTime = pickedTime;
        formatedTime = pickedTime.format(context);
      });
    }
  }

  updateEventDetails() async {
    if (formKey.currentState!.validate()) {
      final eventModel = EventModel(
        id: eventId!,
        title: titleController.text,
        description: descriptionController.text,
        image: selectedImage,
        eventName: selectedEvent,
        eventDate: selectedDate!,
        eventTime: formatedTime!,
        country: selectedCountry!,
        city: selectedCity!,
        location: selectedLocation!,
      );

      FirebaseUtils.updateEvent(userProvider.currentUser!.id, eventModel)
          .then((_) {
        eventListProvider.changeSelectedIndex(
          0,
          userProvider.currentUser!.id,
        );
        print("============================= updated========================");
        ToastMessage.toastMsg(
          AppLocalizations.of(context)!.eventAddedSuccessfully,
          AppColors.greenColor,
        );

        Navigator.pop(context);
      });
    }
  }
}
