class LocationModule {
  double longitude;
  double latitude;
  String name;
  LocationModule({
    required this.longitude,
    required this.latitude,
    required this.name,
  });

  LocationModule.fromJson(Map<dynamic, dynamic> json)
      : longitude = json['lon'],
        latitude = json['lat'],
        name = json['tags']['name'];
}
