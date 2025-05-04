import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evently_app/firebase_utils.dart';
import 'package:evently_app/model/event_model.dart';
import 'package:flutter/material.dart';

class EventListProvider extends ChangeNotifier {
  //data
  List<Event> allEvents  = [];
  List<Event> filteredEvents = [];

  // action
  void getAllEvents() async {
    QuerySnapshot<Event> querySnapshot =
        await FirebaseUtils.getEventCollection().orderBy('eventDate').get();
    allEvents  = querySnapshot.docs.map((doc) {
      return doc.data();
    }).toList();
    filteredEvents = List.from(allEvents);
    notifyListeners();
  }

  void filterEventsByCategory(String category) {
    if (category == 'All') {
      filteredEvents = List.from(allEvents);
    } else {
      filteredEvents = allEvents.where((event) => event.eventName == category).toList();
    }
    notifyListeners();
  }

}
