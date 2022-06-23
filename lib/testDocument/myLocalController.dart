import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mapmosphere/testDocument/MyLocalModule.dart';

class MyLocalController extends GetxController {
  String subUrl = "faq-api";
  List<MyLocalModule> faqData = [];

  RxBool isDataLoaded = false.obs;

  @override
  void onInit() {
    super.onInit();
    //Change value to name2
    fetchData();
  }

  Future<void> fetchData() async {
    final response =
        await http.get(Uri.parse('http://192.168.1.51:3000/books/'));
    if (response.statusCode == 200) {
      final extractedData = json.decode(response.body);
      print(extractedData);

      for (var data in extractedData) {
        faqData.add(MyLocalModule(
            name: data['name'],
            description: data['description'],
            lat: data['tags1'],
            long: data['tags2'],
            features: data['feature'],
            tags: data['tags']));
        // this is to set status to loaded
        isDataLoaded.value = true;
        print(faqData.length);
      }
    }
  }
}
