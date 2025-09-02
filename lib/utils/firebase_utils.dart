import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evently_app/model/event_model.dart';
import 'package:evently_app/model/user_model.dart';

class FirebaseUtils {
  // --- Users Collection ---
  static CollectionReference<MyUser> getUsersCollection() {
    return FirebaseFirestore.instance
        .collection(MyUser.collectionName)
        .withConverter<MyUser>(
      fromFirestore: (snapshot, _) => MyUser.fromFireStore(snapshot.data()!),
      toFirestore: (user, _) => user.toFireStore(),
    );
  }

  static Future<void> addUser(MyUser user) {
    return getUsersCollection().doc(user.id).set(user);
  }

  static Future<MyUser?> getUserById(String id) async {
    var doc = await getUsersCollection().doc(id).get();
    return doc.data();
  }

  static Future<void> updateUserLocation(
      String userId, String country, String city) {
    return getUsersCollection().doc(userId).update({
      'country': country,
      'city': city,
    });
  }

  // --- Events Collection ---
  static CollectionReference<EventModel> getEventsCollection(String uId) {
    return getUsersCollection()
        .doc(uId)
        .collection(EventModel.collectionName)
        .withConverter<EventModel>(
      fromFirestore: (snapshot, _) => EventModel.fromFireStore(snapshot.data()!),
      toFirestore: (event, _) => event.toFireStore(),
    );
  }

  static Future<void> addEvent(String uId, EventModel event) {
    var collection = getEventsCollection(uId);
    var docRef = collection.doc(); // auto ID
    event.id = docRef.id;
    return docRef.set(event);
  }

  static Future<void> updateEvent(String uId, EventModel event) {
    return getEventsCollection(uId).doc(event.id).update(event.toFireStore());
  }

  static Future<void> deleteEvent(String uId, String eventId) {
    return getEventsCollection(uId).doc(eventId).delete();
  }

  static Future<List<EventModel>> getAllEvents(String uId) async {
    var query = await getEventsCollection(uId).orderBy('eventDate').get();
    return query.docs.map((doc) => doc.data()).toList();
  }

  static Future<List<EventModel>> getFavouriteEvents(String uId) async {
    var query = await getEventsCollection(uId)
        .where('isFavourite', isEqualTo: true)
        .orderBy('eventDate')
        .get();
    return query.docs.map((doc) => doc.data()).toList();
  }
}
