import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:mapmosphere/checkModel.dart';
import 'package:mapmosphere/view/osm_Map_View.dart';

void main() {
  runApp(GetMaterialApp(
    home: OsmStreetMap(),
    debugShowCheckedModeBanner: false,
  ));
}
