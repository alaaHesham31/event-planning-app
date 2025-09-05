import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class EventModel {
  static const String collectionName = 'Events';
  String id;
  String title;
  String description;
  String image;
  String eventName;
  DateTime eventDate;
  String eventTime;
  String country;
  String city;
  bool isFavourite;
  LatLng location;

  EventModel({
    this.id = '',
    required this.title,
    required this.description,
    required this.image,
    required this.eventName,
    required this.eventDate,
    required this.eventTime,
    required this.country,
    required this.city,
    required this.location,
    this.isFavourite = false,
  });

  EventModel copyWith({
    String? id,
    String? title,
    String? description,
    String? image,
    String? eventName,
    DateTime? eventDate,
    String? eventTime,
    String? country,
    String? city,
    bool? isFavourite,
    LatLng? location,
  }) {
    return EventModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      image: image ?? this.image,
      eventName: eventName ?? this.eventName,
      eventDate: eventDate ?? this.eventDate,
      eventTime: eventTime ?? this.eventTime,
      country: country ?? this.country,
      city: city ?? this.city,
      location: location ?? this.location,
      isFavourite: isFavourite ?? this.isFavourite,
    );
  }

  EventModel.fromFireStore(Map<String, dynamic> data)
      : this(
          id: data['id'] ?? '',
          title: data['title'] ?? '',
          description: data['description'] ?? '',
          image: data['image'] ?? '',
          eventName: data['eventName'] ?? '',
          eventDate: DateTime.fromMillisecondsSinceEpoch(data['eventDate']),
          eventTime: data['eventTime'] ?? '',
          country: data['country'] ?? '',
          city: data['city'] ?? '',
          location: data['location'] != null
              ? LatLng((data['location'] as GeoPoint).latitude,
                  (data['location'] as GeoPoint).longitude)
              : const LatLng(0, 0),
          isFavourite: data['isFavourite'] ?? false,
        );

  Map<String, dynamic> toFireStore() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image': image,
      'eventName': eventName,
      'eventDate': eventDate.millisecondsSinceEpoch,
      'eventTime': eventTime,
      'country': country,
      'city': city,
      'location': GeoPoint(location.latitude, location.longitude),
      'isFavourite': isFavourite,
    };
  }
}
