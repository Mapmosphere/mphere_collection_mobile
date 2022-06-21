import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';
import 'package:mapmosphere/module/SearchTypeModel.dart';

class SearchTypeService extends GetxController {
  List<SearchType> _cachedList = [];

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getSearchTypes();
  }

  Future<List<SearchType>> getSearchTypes() async {
    if (_cachedList.length <= 0) {
      List<dynamic> json = await _getJsonFromFile('search_types');
      _cachedList = _jsonToSearchTypes(json);
      print(_cachedList);
      print("my dummy data is called");
    }

    return _cachedList;
  }

  Future<List<dynamic>> _getJsonFromFile(String fileName) async {
    String jsonString = await rootBundle.loadString('assets/$fileName.json');
    final data = await json.decode(jsonString);
    print(data['elements']);

    return jsonDecode(jsonString)['elements'];
  }

  List<SearchType> _jsonToSearchTypes(List<dynamic> json) {
    List<SearchType> searchTypes = [];

    for (var element in json) {
      searchTypes.add(SearchType.fromJson(element));
    }

    return searchTypes;
  }
}
