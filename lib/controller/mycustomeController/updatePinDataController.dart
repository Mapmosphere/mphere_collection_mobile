import 'package:http/http.dart' as http;

class UpdatePinDataController {
  Future<void> updatePinData(double lat, double long, String featuresTypes,
      String name, String description, String tags) async {
    print(lat);
    print(long);
    final jsonBody = {
      "feature": featuresTypes,
      "name": name,
      "description": description,
      "remarks": "This is my Remarks",
      "lat": "kjlahs",
      "long": "12321",
      "tags": tags,
      "tags1": lat.toString(),
      "tags2": long.toString(),
    };
// '9831501487'
    final response = await http
        .post(Uri.parse('http://192.168.1.51:3000/books/'), body: jsonBody);

    if (response.statusCode == 200) {
      print("Data uploaded Scuessfully");
    }
  }
}
