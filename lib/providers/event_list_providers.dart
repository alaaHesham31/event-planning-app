import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evently_app/firebase_utils.dart';
import 'package:evently_app/model/event_model.dart';
import 'package:evently_app/utils/toast_msg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EventListProvider extends ChangeNotifier {
  int selectedIndex = 0;

  List<Event> allEventsList = []; // eventsList
  List<Event> filteredEventsList = [];
  List<String> fullEventsNameList = []; // Includes "All"
  List<String> categoryEventsNameList = []; // Excludes "All"
  List<Event> favouriteEventsList = [];

  void getEventsNameList(context) {
    fullEventsNameList = [
      AppLocalizations.of(context)!.all,
      AppLocalizations.of(context)!.sport,
      AppLocalizations.of(context)!.birthday,
      AppLocalizations.of(context)!.gaming,
      AppLocalizations.of(context)!.eating,
      AppLocalizations.of(context)!.holiday,
      AppLocalizations.of(context)!.bookClub,
      AppLocalizations.of(context)!.workShop,
      AppLocalizations.of(context)!.exhibition,
    ];

    categoryEventsNameList = List.from(fullEventsNameList)..removeAt(0);

  }

  // action
  //get the all events -- all tab
  Future<void> getAllEventsList() async {
    QuerySnapshot<Event> querySnapshot =
        await FirebaseUtils.getEventCollection().orderBy('eventDate').get();
    allEventsList = querySnapshot.docs.map((doc) {
      return doc.data();
    }).toList();
    filteredEventsList = allEventsList;
    notifyListeners();
  }

  // get filtered events -- each for event name (category)
  Future<void> filterEventsByCategory() async {
    await getAllEventsList();
    filteredEventsList = allEventsList.where((event) {
      return event.eventName == fullEventsNameList [selectedIndex];
    }).toList();
    notifyListeners();
  }

  // update isFavourite event
  void updateIsFavouriteEvent(event) {
    FirebaseUtils.getEventCollection()
        .doc(event.id)
        .update({'isFavourite': !event.isFavourite}).timeout(
            Duration(milliseconds: 500), onTimeout: () {
      print('event updated successfuly');
    });
    selectedIndex == 0 ? getAllEventsList() : filterEventsByCategory();
    getFavouriteEvent();
    // ToastMessage.toastMsg(AppLocalizations.of(context)!.eventUpdatedSuccessfully)
  }

  void getFavouriteEvent() async {
    var querySnapshot = await FirebaseUtils.getEventCollection()
        .orderBy('eventDate')
        .where('isFavourite', isEqualTo: true).get();

    favouriteEventsList = querySnapshot.docs.map((doc) {
      return doc.data();
    }).toList();
    notifyListeners();
  }

  // change the index of event tab and show eventsList based on the category
  void changeSelectedIndex(int newSelectedIndex) {
    selectedIndex = newSelectedIndex;
    if (selectedIndex == 0) {
      getAllEventsList();
    } else {
      filterEventsByCategory();
    }
    notifyListeners();
  }
}
