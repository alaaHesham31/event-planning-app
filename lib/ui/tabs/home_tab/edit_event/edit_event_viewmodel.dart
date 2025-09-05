import 'package:evently_app/model/event_model.dart';
import 'package:evently_app/providers/event_list_providers.dart';
import 'package:evently_app/providers/user_provider.dart';
import 'package:evently_app/utils/firebase_utils.dart';
import 'package:evently_app/utils/toast_msg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class EditEventViewModel extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  late TextEditingController titleController;
  late TextEditingController descriptionController;

  String? eventId;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String? formattedDate;
  String? formattedTime;
  String? selectedCountry;
  String? selectedCity;
  LatLng? selectedLocation;

  late String selectedImage;
  late String selectedEvent;

  final EventListProvider eventListProvider;
  final UserProvider userProvider;

  EditEventViewModel({
    required this.eventListProvider,
    required this.userProvider,
  });

  void init(EventModel args) {
    titleController = TextEditingController(text: args.title);
    descriptionController = TextEditingController(text: args.description);

    eventId = args.id;
    selectedImage = args.image;
    selectedEvent = args.eventName;
    selectedDate = args.eventDate;
    formattedDate = DateFormat('dd/MM/yyyy').format(selectedDate!);
    formattedTime = args.eventTime;
    selectedLocation = args.location;
    selectedCity = args.city;
    selectedCountry = args.country;

    final index =
        eventListProvider.categoryEventsNameList.indexOf(selectedEvent);
    if (index != -1) {
      eventListProvider.changeSelectedIndex(
        index,
        userProvider.currentUser!.id,
      );
    }

    notifyListeners();
  }

  void chooseDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      selectedDate = pickedDate;
      formattedDate = DateFormat('dd/MM/yyyy').format(selectedDate!);
      notifyListeners();
    }
  }

  void chooseTime(BuildContext context) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (pickedTime != null) {
      selectedTime = pickedTime;
      formattedTime = pickedTime.format(context);
      notifyListeners();
    }
  }

  Future<void> pickLocation(LatLng pickedLocation) async {
    selectedLocation = pickedLocation;
    final placemarks = await placemarkFromCoordinates(
      pickedLocation.latitude,
      pickedLocation.longitude,
    );
    selectedCountry = placemarks[0].country;
    selectedCity = placemarks[0].subAdministrativeArea;
    notifyListeners();
  }

  Future<void> updateEvent(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      final eventModel = EventModel(
        id: eventId!,
        title: titleController.text,
        description: descriptionController.text,
        image: selectedImage,
        eventName: selectedEvent,
        eventDate: selectedDate!,
        eventTime: formattedTime!,
        country: selectedCountry!,
        city: selectedCity!,
        location: selectedLocation!,
      );

      await FirebaseUtils.updateEvent(userProvider.currentUser!.id, eventModel);

      eventListProvider.changeSelectedIndex(
        0,
        userProvider.currentUser!.id,
      );

      ToastMessage.toastMsg(
        AppLocalizations.of(context)!.eventAddedSuccessfully,
        Colors.green,
      );

      Navigator.pop(context);
    }
  }
}
