class ResponseLocation {
  late double longitude;
  late double latitude;
  late String name;
  late String city;
  late String street;

  ResponseLocation({
    required this.longitude,
    required this.latitude,
    required this.name,
    required this.city,
    required this.street,
  });

  ResponseLocation.fromJson(Map<dynamic, dynamic> json) {
    longitude = json['lon'];
    latitude = json['lat'];
    name = json['tags']['name'] != null ? json['tags']['name'] : "Name";
    Map<String, dynamic> tags = json['tags'];

    if (tags == null) {
      return;
    }

    city =
        json['tags']['addr:city'] != null ? json['tags']['addr:city'] : "City";
    street = json['tags']['addr:street'] != null
        ? json['tags']['addr:street']
        : "Street";
  }
}
