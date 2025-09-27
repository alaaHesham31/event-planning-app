import 'package:evently_app/ui/tabs/home_tab/add_event/add_event_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import 'package:evently_app/ui/tabs/home_tab/add_event/add_event_view_model.dart';
import 'package:evently_app/ui/tabs/home_tab/add_event/add_event_screen.dart';
import 'package:evently_app/providers/event_list_providers.dart';
import 'package:evently_app/providers/user_provider.dart';
import 'package:evently_app/providers/app_theme_provider.dart';
import 'package:evently_app/model/event_model.dart';
import 'package:evently_app/utils/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FakeEventListProvider extends EventListProvider {
  FakeEventListProvider() {
    eventImagesList = ['assets/test.png'];
    categoryEventsNameList = ['CategoryA'];
    categoryEventsIconList = ['assets/test_icon.png'];
  }

  @override
  Future<void> loadAllEvents(String uId) async {
    allEventsList = [];
    filteredEventsList = [];
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
    selectedIndex = index;
  }
}

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


class TestAddEventViewModel extends AddEventViewModel {
  final Future<void> Function(String, EventModel) addEventFunc;

  TestAddEventViewModel(this.addEventFunc);

  @override
  Future<void> addEvent() async {
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
        eventListProvider.changeSelectedIndex(0, 'testUserId');
        navigator.showToastMsg('Event Added Successfully', AppColors.greenColor);
        navigator.closeScreen();
      });
    } else {
      navigator.showToastMsg('Please complete all fields', AppColors.redColor);
    }
  }
}


void main() {
  group('AddEventViewModel unit tests', () {
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

      expect(eventListProvider.selectedIndex, 0);
      expect(navigator.lastMsg, 'Event Added Successfully');
      expect(navigator.lastColor, AppColors.greenColor);
      expect(navigator.closed, isTrue);
    });
  });

  group('AddEventScreen widget tests (lightweight)', () {
    testWidgets('AddEventScreen builds without throwing', (WidgetTester tester) async {
      final eventListProvider = FakeEventListProvider();
      final userProvider = UserProvider();

      final appThemeProvider = AppThemeProvider();

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<EventListProvider>.value(value: eventListProvider),
            ChangeNotifierProvider<UserProvider>.value(value: userProvider),
            ChangeNotifierProvider<AppThemeProvider>.value(value: appThemeProvider),
          ],
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const AddEventScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(Form), findsOneWidget);
      expect(find.byType(ListView), findsWidgets);
      expect(find.byType(Image), findsWidgets);
    });
  });
}
