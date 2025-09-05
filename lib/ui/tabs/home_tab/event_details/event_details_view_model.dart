import 'package:evently_app/model/event_model.dart';
import 'package:evently_app/providers/event_list_providers.dart';
import 'package:evently_app/providers/user_provider.dart';
import 'package:flutter/material.dart';

class EventDetailsViewModel extends ChangeNotifier {
  final EventListProvider eventListProvider;
  final UserProvider userProvider;

  String? _eventId;
  EventModel? _event;

  EventDetailsViewModel({
    required this.eventListProvider,
    required this.userProvider,
  }) {
    eventListProvider.addListener(_onEventsChanged);
  }

  EventModel? get event => _event;

  void loadEvent(String eventId) {
    _eventId = eventId;
    _event = eventListProvider.getEventById(eventId);
    notifyListeners();
  }

  void refresh() {
    if (_eventId != null) {
      _event = eventListProvider.getEventById(_eventId!);
      notifyListeners();
    }
  }

  Future<void> deleteEvent(String eventId) async {
    await eventListProvider.deleteEvent(eventId, userProvider.currentUser!.id);
  }

  void _onEventsChanged() {
    if (_eventId == null) return;
    final updated = eventListProvider.getEventById(_eventId!);
    _event = updated;
    notifyListeners();
  }

  @override
  void dispose() {
    eventListProvider.removeListener(_onEventsChanged);
    super.dispose();
  }
}
