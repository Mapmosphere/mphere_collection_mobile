import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:mapmosphere/view/osm_Map_View.dart';

void main() {
  runApp(const GetMaterialApp(
    home: OsmMapView(),
    debugShowCheckedModeBanner: false,
  ));
}
