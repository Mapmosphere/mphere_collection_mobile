import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mapmosphere/module/MyCostumeModule/pointDataModel.dart';

class PointDataController {
  List<PointDataModel> pointData = [
    PointDataModel(pointName: "Bar", iconData: FontAwesomeIcons.bars),
    PointDataModel(pointName: "Fast Food", iconData: FontAwesomeIcons.bowlFood),
    PointDataModel(
        pointName: "Hospital Ground", iconData: FontAwesomeIcons.hospital),
    PointDataModel(pointName: "Cafe", iconData: Icons.coffee),
    PointDataModel(
        pointName: "Natural Features", iconData: FontAwesomeIcons.tree),
    PointDataModel(pointName: "Park", iconData: Icons.park),
    PointDataModel(
        pointName: "Place Of Workship", iconData: Icons.temple_buddhist),
    PointDataModel(pointName: "Resturant", iconData: Icons.restaurant),
    PointDataModel(
        pointName: "Banks", iconData: FontAwesomeIcons.buildingColumns),
    PointDataModel(pointName: "SuperMarket", iconData: FontAwesomeIcons.shop),
    PointDataModel(pointName: "Others", iconData: Icons.pin_drop),
  ];
}
