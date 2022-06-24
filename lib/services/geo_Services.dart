import 'dart:convert';

import 'package:mapmosphere/controller/OverPassApiController.dart';
import 'package:mapmosphere/module/LocationModule.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../module/QueryLocationModel.dart';
import '../module/ResponsesLocation.dart';
import '../module/SearchTypeModel.dart';

class GeoServices {
  late final OverPassApiController overpassApi;
  late final String fileName;

  List<LocationModule> _cachedList = [];
  GeoServices({required this.overpassApi, this.fileName = 'nepal'})
      : assert(overpassApi != null);

  Future<List<LocationModule>> getLocations() async {
    if (_cachedList.length <= 0) {
      Map<dynamic, dynamic> json = await _getJsonFromFile(fileName);
      _cachedList = _jsonToLocations(json);
    }

    return _cachedList;
  }

  Future<List<LocationModule>> getEntitiesInArea(
      {required LocationModule center,
      required SearchType type,
      double radiusInMetres = 50000}) async {
    List<ResponseLocation> fetchResult =
        await this.overpassApi.fetchLocationsAroundCenter(
            QueryLocation(
              longitude: (center.longitude),
              latitude: (center.latitude),
            ),
            type.tags,
            radiusInMetres);

    List<LocationModule> result = [];

    fetchResult.forEach((element) {
      result.add(LocationModule(
          longitude: element.longitude,
          latitude: element.latitude,
          name: element.name));
    });

    return result;
  }

  Future<Map<dynamic, dynamic>> _getJsonFromFile(String fileName) async {
    String jsonString =
        await rootBundle.loadString('assets/location/$fileName.json');

    return jsonDecode(jsonString);
  }

  List<LocationModule> _jsonToLocations(Map<dynamic, dynamic> json) {
    List<LocationModule> locations = [];

    // TODO: Or validate here? Or both?

    for (var element in json["elements"]) {
      locations.add(LocationModule.fromJson(element));
    }

    return locations;
  }
}
