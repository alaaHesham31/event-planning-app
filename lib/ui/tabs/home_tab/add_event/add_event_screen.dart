import 'package:evently_app/ui/tabs/home_tab/add_event/location_picker_screen.dart';
import 'package:evently_app/utils/firebase_utils.dart';
import 'package:evently_app/model/event_model.dart';
import 'package:evently_app/providers/event_list_providers.dart';
import 'package:evently_app/providers/user_provider.dart';
import 'package:evently_app/ui/widgets/custom_elevated_button.dart';
import 'package:evently_app/ui/widgets/custom_text_field.dart';
import 'package:evently_app/ui/widgets/tab_event_item.dart';
import 'package:evently_app/utils/app_colors.dart';
import 'package:evently_app/utils/app_image.dart';
import 'package:evently_app/utils/app_style.dart';
import 'package:evently_app/utils/toast_msg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddEventScreen extends StatefulWidget {
  static const String routeName = 'addEventScreen';

  AddEventScreen({super.key});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  var formKey = GlobalKey<FormState>();
  DateTime? selectedDate;
  String formatedDate = '';
  TimeOfDay? selectedTime;
  String formatedTime = '';
  var titleController = TextEditingController();
  var descriptionController = TextEditingController();
  late EventListProvider eventListProvider;
  late UserProvider userProvider;
  String selectedImage = '';
  String selectedEvent = '';
  String? selectedCountry;
  String? selectedCity;
  String? selectedLocation;
  LatLng? pickedLocation;

  @override
  Widget build(BuildContext context) {
    eventListProvider = Provider.of<EventListProvider>(context);
    userProvider = Provider.of<UserProvider>(context);

    eventListProvider.categoryEventsNameList;

    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    selectedImage =
        eventListProvider.eventImagesList[eventListProvider.selectedIndex];
    selectedEvent = eventListProvider
        .categoryEventsNameList[eventListProvider.selectedIndex];

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.nodeWhiteColor,
          centerTitle: true,
          title: Text(
            AppLocalizations.of(context)!.createEvent,
            style: AppStyle.semi20Primary,
          ),
          iconTheme: IconThemeData(color: AppColors.primaryColor),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
              vertical: height * 0.02, horizontal: width * 0.04),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: height * 0.25,
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
                  height: height * 0.02,
                ),
                SizedBox(
                  height: height * 0.07,
                  child: ListView.builder(
                    padding: EdgeInsets.only(bottom: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: eventListProvider.categoryEventsNameList.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          eventListProvider.changeSelectedIndex(
                              index, userProvider.currentUser!.id);
                        },
                        child: TabEventItem(
                          backgroundSelectedColor: AppColors.primaryColor,
                          borderUnSelectedColor: AppColors.primaryColor,
                          selectedIconColor: AppColors.whiteColor,
                          unSelectedIconColor: AppColors.primaryColor,
                          selectedTextStyle: AppStyle.bold14White,
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
                        height: height * 0.01,
                      ),
                      CustomTextField(
                        controller: titleController,
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return AppLocalizations.of(context)!
                                .pleaseEnterEventTitle;
                          }
                          return null;
                        },
                        textStyle: AppStyle.semi16Black,
                        hintText: AppLocalizations.of(context)!.eventTitle,
                        hintTextStyle: AppStyle.semi16Grey,
                        borderColor: AppColors.greyColor,
                        prefixIcon: Image.asset(AppImage.editIcon),
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      Text(
                        AppLocalizations.of(context)!.description,
                        style: AppStyle.semi16Black,
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      CustomTextField(
                        controller: descriptionController,
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return AppLocalizations.of(context)!
                                .pleaseEnterEventDescription;
                          }
                          return null;
                        },
                        textStyle: AppStyle.semi16Black,
                        maxLines: 4,
                        hintText:
                            AppLocalizations.of(context)!.eventDescription,
                        hintTextStyle: AppStyle.semi16Grey,
                        borderColor: AppColors.greyColor,
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Row(
                        children: [
                          Image.asset(AppImage.eventDateIcon),
                          SizedBox(
                            width: width * 0.02,
                          ),
                          Text(
                            AppLocalizations.of(context)!.eventDate,
                            style: AppStyle.semi16Black,
                          ),
                          Spacer(),
                          InkWell(
                            onTap: chooseDate,
                            child: Text(
                              selectedDate == null
                                  ? AppLocalizations.of(context)!.chooseDate
                                  : formatedDate,
                              style: AppStyle.semi16Primary,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Row(
                        children: [
                          Image.asset(AppImage.eventTimeIcon),
                          SizedBox(
                            width: width * 0.02,
                          ),
                          Text(
                            AppLocalizations.of(context)!.eventTime,
                            style: AppStyle.semi16Black,
                          ),
                          Spacer(),
                          InkWell(
                            onTap: chooseTime,
                            child: Text(
                              selectedTime == null
                                  ? AppLocalizations.of(context)!.chooseTime
                                  : formatedTime,
                              style: AppStyle.semi16Primary,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Text(
                        AppLocalizations.of(context)!.location,
                        style: AppStyle.semi16Black,
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      InkWell(
                        onTap: () async {
                          pickedLocation =
                              await Navigator.of(context).push<LatLng>(
                            MaterialPageRoute(
                              builder: (context) =>
                                  const LocationPickerScreen(),
                            ),
                          );

                          if (pickedLocation != null) {
                            print(
                                "User selected location: ${pickedLocation!.latitude}, ${pickedLocation!.longitude}");

                            List<Placemark> placemarks =
                                await placemarkFromCoordinates(
                              pickedLocation!.latitude,
                              pickedLocation!.longitude,
                            );

                            selectedCountry = placemarks[0].country;
                            selectedCity = placemarks[0].subAdministrativeArea;

                            setState(() {
                              selectedLocation =
                                  "$selectedCity, $selectedCountry";
                            });
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: height * 0.01,
                              horizontal: width * 0.015),
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
                                    vertical: height * 0.012,
                                    horizontal: width * 0.025),
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
                                width: width * 0.02,
                              ),
                              Text(
                                selectedLocation ??
                                    AppLocalizations.of(context)!
                                        .chooseEventLocation,
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
                        height: height * 0.02,
                      ),
                      CustomElevatedButton(
                        onClick: addEvent,
                        textStyle: AppStyle.semi20White,
                        text: AppLocalizations.of(context)!.addEvent,
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void addEvent() async {
    if (formKey.currentState!.validate() &&
        selectedDate != null &&
        selectedTime != null) {
      EventModel event = EventModel(
          title: titleController.text,
          description: descriptionController.text,
          image: selectedImage,
          eventName: selectedEvent,
          eventDate: selectedDate!,
          eventTime: formatedTime,
          location: pickedLocation!,
          country: selectedCountry!,
          city: selectedCity!);
      // var userProvider = Provider.of<UserProvider>(context, listen: false);

      await FirebaseUtils.addEvent(
               userProvider.currentUser!.id, event)
          .then((onValue) {
        // Update selected index after success
        eventListProvider.changeSelectedIndex(
          0,
          userProvider.currentUser!.id,
        );
        ToastMessage.toastMsg(
            AppLocalizations.of(context)!.eventAddedSuccessfully,
            AppColors.greenColor);
        Navigator.pop(context);
      });
    }
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
    var chooseTime =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    selectedTime = chooseTime;
    formatedTime = selectedTime!.format(context);
    setState(() {});
  }
}
