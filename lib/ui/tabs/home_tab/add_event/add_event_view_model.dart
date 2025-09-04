import 'package:evently_app/model/event_model.dart';
import 'package:evently_app/providers/event_list_providers.dart';
import 'package:evently_app/providers/user_provider.dart';
import 'package:evently_app/utils/firebase_utils.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'add_event_navigator.dart';

class AddEventViewModel extends ChangeNotifier {
  late AddEventNavigator navigator;
  late EventListProvider eventListProvider;
  late UserProvider userProvider;

  // form data
  DateTime? selectedDate;
  String formattedDate = '';
  TimeOfDay? selectedTime;
  String formattedTime = '';
  String? selectedCountry;
  String? selectedCity;
  String? selectedLocation;
  LatLng? pickedLocation;

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  void init(EventListProvider eProvider, UserProvider uProvider) {
    eventListProvider = eProvider;
    userProvider = uProvider;
  }

  void chooseDate(BuildContext context) async {
    var chooseDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 356)),
    );
    if (chooseDate != null) {
      selectedDate = chooseDate;
      formattedDate =
      "${chooseDate.day}/${chooseDate.month}/${chooseDate.year}";
      notifyListeners();
    }
  }

  void chooseTime(BuildContext context) async {
    var chooseTime =
    await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (chooseTime != null) {
      selectedTime = chooseTime;
      formattedTime = chooseTime.format(context);
      notifyListeners();
    }
  }

  Future<void> chooseLocation(BuildContext context) async {
    pickedLocation = await navigator.pickLocation(context);
    if (pickedLocation != null) {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        pickedLocation!.latitude,
        pickedLocation!.longitude,
      );
      selectedCountry = placemarks[0].country;
      selectedCity = placemarks[0].subAdministrativeArea;
      selectedLocation = "$selectedCity, $selectedCountry";
      notifyListeners();
    }
  }

  Future<void> addEvent() async {
    if (formKey.currentState!.validate() &&
        selectedDate != null &&
        selectedTime != null &&
        pickedLocation != null) {
      final selectedImage =
      eventListProvider.eventImagesList[eventListProvider.selectedIndex];
      final selectedEvent =
      eventListProvider.categoryEventsNameList[eventListProvider.selectedIndex];

      EventModel event = EventModel(
        title: titleController.text,
        description: descriptionController.text,
        image: selectedImage,
        eventName: selectedEvent,
        eventDate: selectedDate!,
        eventTime: formattedTime,
        location: pickedLocation!,
        country: selectedCountry!,
        city: selectedCity!,
      );

      await FirebaseUtils.addEvent(userProvider.currentUser!.id, event).then((_) {
        eventListProvider.changeSelectedIndex(0, userProvider.currentUser!.id);
        navigator.showSnackBar("Event Added Successfully", Colors.green);
        navigator.closeScreen();
      });
    } else {
      navigator.showSnackBar("Please complete all fields", Colors.red);
    }
  }
}
