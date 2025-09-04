class MyUser {
  static const String collectionName = 'Users';
  String id;
  String name;
  String email;

  String? country;
  String? city;
  List<String>? deviceTokens;

  MyUser(
      {required this.id,
      required this.name,
      required this.email,
      this.country,
      this.city,
      this.deviceTokens});

  MyUser copyWith({
    String? id,
    String? name,
    String? email,
    String? country,
    String? city,
    List<String>? deviceTokens,
  }) {
    return MyUser(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        country: country ?? this.country,
        city: city ?? this.city,
        deviceTokens: deviceTokens ?? this.deviceTokens);
  }

  // object => json -- from fire store
  MyUser.fromFireStore(Map<String, dynamic> data)
      : this(
          id: data['id'],
          name: data['name'],
          email: data['email'],
          country: data['country'],
          city: data['city'],
          deviceTokens:  data['deviceTokens'] != null
              ? List<String>.from(data['deviceTokens'])
              : [],
        );

  //object => json -- to fire store
  Map<String, dynamic> toFireStore() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'country': country,
      'city': city,
      'deviceTokens': deviceTokens
    };
  }
}
