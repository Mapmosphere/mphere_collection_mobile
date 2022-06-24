import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:mapmosphere/testDocument/MyLocalModule.dart';
import 'package:mapmosphere/testDocument/myLocalController.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class DisplayLocalMap extends StatefulWidget {
  const DisplayLocalMap({Key? key}) : super(key: key);

  @override
  State<DisplayLocalMap> createState() => _DisplayLocalMapState();
}

class _DisplayLocalMapState extends State<DisplayLocalMap> {
  final myLocalController = Get.put(MyLocalController());
  List<Marker> markers = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myLocalController.fetchData();
    if (myLocalController.isDataLoaded.value == true) {
      _getMarkers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            "My Local Pins",
            style: TextStyle(
              color: Colors.teal,
              fontFamily: "Supreme-Regular",
            ),
          ),
          centerTitle: true,
        ),
        body: Obx(() => myLocalController.isDataLoaded.value == true
            ? FlutterMap(
                options: MapOptions(
                  center: LatLng(
                      double.parse(myLocalController.faqData.first.lat),
                      double.parse(myLocalController.faqData.first.long)),
                  zoom: 13.0,
                ),
                layers: [
                  TileLayerOptions(
                    urlTemplate:
                        "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: ['a', 'b', 'c'],
                  ),
                  MarkerLayerOptions(markers: markers),
                ],
                nonRotatedChildren: [
                  AttributionWidget.defaultWidget(
                    source: 'OpenStreetMap contributors',
                    onSourceTapped: () {},
                  ),
                ],
              )
            : Center(
                child: CircularProgressIndicator(),
              )));
  }

  List<Marker> _getMarkers() {
    List<Marker> markers = [];
    for (int i = 0; i < myLocalController.faqData.length; i++) {
      markers.add(Marker(
          point: LatLng(double.parse(myLocalController.faqData[i].lat),
              double.parse(myLocalController.faqData[i].long)),
          builder: (cts) => Icon(Icons.pin)));
    }
    print(markers.length);
    return markers;
  }
}
