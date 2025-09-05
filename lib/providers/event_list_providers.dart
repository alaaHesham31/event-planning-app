import 'package:evently_app/model/event_model.dart';
import 'package:evently_app/utils/app_image.dart';
import 'package:evently_app/utils/firebase_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EventListProvider extends ChangeNotifier {
  int selectedIndex = 0;
  String? currentLanguageCode;

  List<EventModel> allEventsList = [];
  List<EventModel> filteredEventsList = [];
  List<EventModel> favouriteEventsList = [];

  List<String> fullEventsNameList = [];
  List<String> categoryEventsNameList = [];
  List<String> fullEventsIconList = [];
  List<String> categoryEventsIconList = [];

  List<String> eventImagesList = [
    AppImage.sportImage,
    AppImage.birthdayImage,
    AppImage.gamingImage,
    AppImage.eatingImage,
    AppImage.holidayImage,
    AppImage.bookClubImage,
    AppImage.workshopImage,
    AppImage.exhibitionImage,
  ];

  // --- Setup ---
  void loadEventCategories(BuildContext context) {
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
    categoryEventsNameList = fullEventsNameList.sublist(1);

    fullEventsIconList = [
      AppImage.all,
      AppImage.sport,
      AppImage.birthday,
      AppImage.gaming,
      AppImage.eating,
      AppImage.holiday,
      AppImage.bookClub,
      AppImage.workShop,
      AppImage.exhibition,
    ];
    categoryEventsIconList = fullEventsIconList.sublist(1);
  }

  void initCategories(BuildContext context) {
    loadEventCategories(context);
    notifyListeners();
  }

  void updateLanguage(BuildContext context) {
    final langCode = Localizations.localeOf(context).languageCode;
    if (currentLanguageCode == langCode) return;
    currentLanguageCode = langCode;

    loadEventCategories(context);
    notifyListeners();
  }

  // --- Load Events ---
  Future<void> loadAllEvents(String uId) async {
    allEventsList = await FirebaseUtils.getAllEvents(uId);
    filteredEventsList = allEventsList;
    notifyListeners();
  }

  Future<void> filterEventsByCategory(String uId) async {
    await loadAllEvents(uId);
    filteredEventsList = allEventsList.where((event) {
      return event.eventName == categoryEventsNameList[selectedIndex - 1];
    }).toList();
    notifyListeners();
  }

  Future<void> loadFavourites(String uId) async {
    favouriteEventsList = await FirebaseUtils.getFavouriteEvents(uId);
    notifyListeners();
  }

  // --- Event Actions ---
  Future<void> toggleFavourite(EventModel event, String uId) async {
    await FirebaseUtils.updateEvent(
        uId, event.copyWith(isFavourite: !event.isFavourite));
    selectedIndex == 0
        ? await loadAllEvents(uId)
        : await filterEventsByCategory(uId);
    await loadFavourites(uId);
  }

  Future<void> deleteEvent(String eventId, String uId) async {
    await FirebaseUtils.deleteEvent(uId, eventId);
    selectedIndex == 0
        ? await loadAllEvents(uId)
        : await filterEventsByCategory(uId);
    notifyListeners();
  }

  void changeSelectedIndex(int index, String uId) {
    selectedIndex = index;
    if (index == 0) {
      loadAllEvents(uId);
    } else {
      filterEventsByCategory(uId);
    }
  }

  EventModel? getEventById(String eventId) {
    try {
      return allEventsList.firstWhere((event) => event.id == eventId);
    } catch (_) {
      return null;
    }
  }

  void clearCache() {
    allEventsList.clear();
    filteredEventsList.clear();
    favouriteEventsList.clear();
    fullEventsNameList.clear();
    fullEventsIconList.clear();
    selectedIndex = 0;
    notifyListeners();
  }
}
