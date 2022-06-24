import 'package:http/http.dart' as http;
import 'package:mapmosphere/const/api.dart';

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
    final response = await http.post(Uri.parse(api), body: jsonBody);

    if (response.statusCode == 200) {
      print("Data uploaded Scuessfully");
    }
  }
}
