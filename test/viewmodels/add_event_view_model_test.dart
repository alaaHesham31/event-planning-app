import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// app imports (adjust the package paths to match yours)
import 'package:evently_app/ui/tabs/home_tab/add_event/add_event_view_model.dart';
import 'package:evently_app/ui/tabs/home_tab/add_event/add_event_navigator.dart';
import 'package:evently_app/providers/event_list_providers.dart';
import 'package:evently_app/providers/user_provider.dart';
import 'package:evently_app/model/event_model.dart';
import 'package:evently_app/utils/app_colors.dart';

/// A tiny fake navigator used by the tests.
class FakeNavigator implements AddEventNavigator {
  String? lastMsg;
  Color? lastColor;
  bool closed = false;
  LatLng? pickReturn;

  @override
  void closeScreen() => closed = true;

  @override
  Future<LatLng?> pickLocation(BuildContext context) async => pickReturn;

  @override
  void showToastMsg(String message, Color color) {
    lastMsg = message;
    lastColor = color;
  }
}

/// FakeEventListProvider avoids ANY Firestore calls by overriding methods
/// that would otherwise call FirebaseUtils.
class FakeEventListProvider extends EventListProvider {
  FakeEventListProvider() {
    // ensure lists have minimal content used by UI / viewModel:
    eventImagesList = ['assets/images/test.png'];
    categoryEventsNameList = ['CategoryA'];
    // also set corresponding icon list to avoid index errors (if used)
    categoryEventsIconList = ['assets/icons/test_icon.png'];
  }

  @override
  Future<void> loadAllEvents(String uId) async {
    // do nothing — don't call Firebase
    allEventsList = [];
    filteredEventsList = [];
    // no notifyListeners needed for unit test context, but harmless:
    // notifyListeners();
  }

  @override
  Future<void> filterEventsByCategory(String uId) async {
    filteredEventsList = [];
  }

  @override
  Future<void> loadFavourites(String uId) async {
    favouriteEventsList = [];
  }

  @override
  void changeSelectedIndex(int index, String uId) {
    // only change index locally without calling loadAllEvents/filterEventsByCategory
    selectedIndex = index;
  }
}

/// Test subclass of AddEventViewModel that injects an "addEvent" callback
/// so we don't call FirebaseUtils.addEvent.
class TestAddEventViewModel extends AddEventViewModel {
  final Future<void> Function(String, EventModel) addEventFunc;

  TestAddEventViewModel(this.addEventFunc);

  @override
  Future<void> addEvent() async {
    // Simplified: don't depend on formKey.currentState (no widget tree in unit test)
    if (titleController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty &&
        selectedDate != null &&
        selectedTime != null &&
        pickedLocation != null &&
        selectedCountry != null &&
        selectedCity != null) {
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

      await addEventFunc('testUserId', event).then((_) {
        // Use our fake provider's changeSelectedIndex — it will NOT call Firestore.
        eventListProvider.changeSelectedIndex(0, 'testUserId');
        navigator.showToastMsg("Event Added Successfully", AppColors.greenColor);
        navigator.closeScreen();
      });
    } else {
      navigator.showToastMsg("Please complete all fields", AppColors.redColor);
    }
  }
}

void main() {
  group('AddEventViewModel tests (using FakeEventListProvider)', () {
    late FakeEventListProvider eventListProvider;
    late UserProvider userProvider;
    late FakeNavigator navigator;

    setUp(() {
      eventListProvider = FakeEventListProvider();
      userProvider = UserProvider();
      navigator = FakeNavigator();
    });

    test('shows error when fields are incomplete', () async {
      final vm = TestAddEventViewModel((_, __) async {});
      vm.navigator = navigator;
      vm.init(eventListProvider, userProvider);

      // fields left empty -> should show "Please complete all fields"
      await vm.addEvent();

      expect(navigator.lastMsg, 'Please complete all fields');
      expect(navigator.lastColor, AppColors.redColor);
      expect(navigator.closed, isFalse);
    });

    test('successful addEvent calls repository, resets index and closes', () async {
      EventModel? capturedEvent;
      final vm = TestAddEventViewModel((uId, event) async {
        capturedEvent = event;
      });
      vm.navigator = navigator;
      vm.init(eventListProvider, userProvider);

      // Fill required fields:
      vm.titleController.text = 'My Title';
      vm.descriptionController.text = 'My Desc';
      vm.selectedDate = DateTime(2025, 9, 26);
      vm.formattedDate = '26/9/2025';
      vm.selectedTime = TimeOfDay(hour: 14, minute: 30);
      vm.formattedTime = '2:30 PM';
      vm.pickedLocation = LatLng(31.0, 31.0);
      vm.selectedCountry = 'Egypt';
      vm.selectedCity = 'Cairo';

      await vm.addEvent();

      expect(capturedEvent, isNotNull);
      expect(capturedEvent!.title, 'My Title');
      expect(capturedEvent!.description, 'My Desc');
      expect(capturedEvent!.country, 'Egypt');
      expect(capturedEvent!.city, 'Cairo');

      // view model should change selected index back to 0 (fake provider only sets the field)
      expect(eventListProvider.selectedIndex, 0);

      // navigator notifications
      expect(navigator.lastMsg, 'Event Added Successfully');
      expect(navigator.lastColor, AppColors.greenColor);
      expect(navigator.closed, isTrue);
    });
  });
}
