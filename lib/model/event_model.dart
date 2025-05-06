class Event {
  static const String collectionName = 'Events';
  String id;
  String title;
  String description;
  String image;
  String eventName;
  DateTime eventDate;
  String eventTime;
  bool isFavourite;

  Event(
      {this.id = '',
      required this.title,
      required this.description,
      required this.image,
      required this.eventName,
      required this.eventDate,
      required this.eventTime,
      this.isFavourite = false});

  //json to object -- named constructor
 Event.formFireStore( Map<String, dynamic>  data):this(
      id: data['id'],
      title: data['title'],
      description: data['description'],
      image: data['image'],
      eventName: data['eventName'],
   eventDate: DateTime.fromMillisecondsSinceEpoch(data['eventDate']),
      eventTime: data['eventTime'],
      isFavourite: data['isFavourite'],
    );


  // object to json  -- to fireStore
  Map<String, dynamic> toFireStore() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image': image,
      'eventName': eventName,
      'eventDate': eventDate.millisecondsSinceEpoch,
      'eventTime': eventTime,
      'isFavourite': isFavourite
    };
  }
}
