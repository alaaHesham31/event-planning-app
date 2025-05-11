import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evently_app/firebase_utils.dart';
import 'package:evently_app/model/event_model.dart';
import 'package:evently_app/utils/app_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EventListProvider extends ChangeNotifier {
  int selectedIndex = 0;


  List<Event> allEventsList = []; // eventsList
  List<Event> filteredEventsList = [];
  List<String> fullEventsNameList = []; // Includes "All"
  List<String> categoryEventsNameList = []; // Excludes "All"
  List<String> fullEventsIconList = []; // Includes "All"
  List<String> categoryEventsIconList = []; // Excludes "All"
  List<Event> favouriteEventsList = [];
  List<String> eventImagesList = [
    AppImage.sportImage,
    AppImage.birthdayImage,
    AppImage.gamingImage,
    AppImage.eatingImage,
    AppImage.holidayImage,
    AppImage.bookClubImage,
    AppImage.workshopImage,
    AppImage.exhibitionImage
  ];

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
  void getEventsIconList(context) {
    fullEventsIconList = [
      AppImage.all,
      AppImage.sport,
      AppImage.birthday,
      AppImage.gaming,
      AppImage.eating,
      AppImage.holiday,
      AppImage.bookClub,
      AppImage.workShop,
      AppImage.exhibition
    ];

    categoryEventsIconList = List.from(fullEventsIconList)..removeAt(0);

  }

  // action
  //get the all events -- all tab
  Future<void> getAllEventsList(String uId) async {
    QuerySnapshot<Event> querySnapshot =
    await FirebaseUtils.getEventCollection(uId).orderBy('eventDate').get();
    allEventsList = querySnapshot.docs.map((doc) {
      return doc.data();
    }).toList();
    filteredEventsList = allEventsList;
    notifyListeners();
  }

  // get filtered events -- each for event name (category)
  Future<void> filterEventsByCategory(String uId) async {
    await getAllEventsList(uId);
    filteredEventsList = allEventsList.where((event) {
      return event.eventName == categoryEventsNameList[selectedIndex - 1];
    }).toList();
    notifyListeners();
  }

  // update isFavourite event
  void updateIsFavouriteEvent(event, String uId) {
    FirebaseUtils.getEventCollection(uId)
        .doc(event.id)
        .update({'isFavourite': !event.isFavourite}).
    then((onValue){
      print('event updated successfuly');
    })
    .timeout(
        Duration(milliseconds: 500), onTimeout: () {
      print('event updated successfuly');
    });
    selectedIndex == 0 ? getAllEventsList(uId) : filterEventsByCategory(uId);
    getFavouriteEvent(uId);
  }

  void getFavouriteEvent(String uId) async {
    var querySnapshot = await FirebaseUtils.getEventCollection(uId)
        .orderBy('eventDate')
        .where('isFavourite', isEqualTo: true).get();

    favouriteEventsList = querySnapshot.docs.map((doc) {
      return doc.data();
    }).toList();
    notifyListeners();
  }

  // change the index of event tab and show eventsList based on the category
  void changeSelectedIndex(int newSelectedIndex, String uId) {
    selectedIndex = newSelectedIndex;
    if (selectedIndex == 0) {
      getAllEventsList(uId);
    } else {
      filterEventsByCategory(uId);
    }
    notifyListeners();
  }
  void clearAllEventLists() {
    allEventsList.clear();
    filteredEventsList.clear();
    fullEventsNameList.clear();
    fullEventsIconList.clear();
    selectedIndex = 0;
    notifyListeners();
  }

}