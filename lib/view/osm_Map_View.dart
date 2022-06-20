import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:mapmosphere/controller/geoLocation_Controller.dart';

class OsmMapView extends StatefulWidget {
  const OsmMapView({Key? key}) : super(key: key);

  @override
  State<OsmMapView> createState() => _OsmMapViewState();
}

class _OsmMapViewState extends State<OsmMapView> {
  final locationController = Get.put(LocationController());

  late MapController mapController;
  double latitude = 28.237988;
  double longitide = 83.995590;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mapController = MapController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Flutter osm hack Fest "),
        ),
        body: Obx(() => locationController.isDataLoaded.value == true
            ? FlutterMap(
                options: MapOptions(
                    center: LatLng(
                        double.parse(locationController.latitude.toString()),
                        double.parse(locationController.longitude.toString())),
                    zoom: 15.0,
                    onTap: (position, latLang) {
                      print(latLang);
                      setState(() {
                        latitude = latLang.latitude;
                        longitide = latLang.longitude;
                      });
                    }),
                layers: [
                  TileLayerOptions(
                    urlTemplate:
                        "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: ['a', 'b', 'c'],
                  ),
                  MarkerLayerOptions(
                    markers: [
                      Marker(
                          width: 180.0,
                          height: 180.0,
                          point: LatLng(latitude, longitide),
                          builder: (ctx) => const Icon(
                                Icons.location_city,
                                color: Colors.red,
                              )),
                    ],
                  ),
                ],
              )
            : const Center(child: CircularProgressIndicator())));
  }
}
