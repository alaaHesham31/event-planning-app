import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evently_app/model/event_model.dart';
import 'package:evently_app/model/user_model.dart';

class FirebaseUtils {
  static CollectionReference<Event> getEventCollection(String uId) {
    return getUsersCollection().doc(uId)
        .collection(Event.collectionName)
        .withConverter<Event>(
            fromFirestore: (snapshot, options) =>
                Event.formFireStore(snapshot.data()!),
            toFirestore: (event, _) => event.toFireStore());
  }

  static Future<void> addEventToFireStore(Event event, String uId) {
    var collection = getEventCollection(uId);
    var docRef = collection.doc(); // auto-generates a new ID
    event.id = docRef.id;          // assign the generated ID to the object
    return docRef.set(event);
  }


  static CollectionReference<MyUser> getUsersCollection() {
    return FirebaseFirestore.instance
        .collection(MyUser.collectionName)
        .withConverter<MyUser>(
            fromFirestore: (snapshot, options) =>
                MyUser.fromFireStore(snapshot.data()!),
            toFirestore: (user, _) => user.toFireStore());
  }

  static Future<void> addUserToFireStore(MyUser user) {
    return getUsersCollection().doc(user.id).set(user);
  }

  static Future<MyUser?> readUserFromFireStore(String id)async{
  var querySnapshot = await getUsersCollection().doc(id).get();
  return querySnapshot.data();
  }
}
