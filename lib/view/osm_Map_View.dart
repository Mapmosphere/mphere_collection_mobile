import 'dart:math';

import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:mapmosphere/controller/OverPassApiController.dart';
import 'package:mapmosphere/controller/geoLocation_Controller.dart';
import 'package:mapmosphere/module/LocationModule.dart';
import 'package:mapmosphere/services/geo_Services.dart';

import '../controller/SearchTypeServiceController.dart';
import '../module/SearchTypeModel.dart';

class OsmStreetMap extends StatefulWidget {
  @override
  _OsmStreetMapState createState() => _OsmStreetMapState();
}

class _OsmStreetMapState extends State<OsmStreetMap> {
  final searchTypeController = Get.put(SearchTypeService());
  final currentLocationController = Get.put(LocationController());
  final MapController _mapController = MapController();
  final OverPassApiController _overpassApi = OverPassApiController();
  late GeoServices _geoService;

  List<SearchType> _searchTypes = [];
  List<LocationModule> _locations = [];

  late LocationModule _currentLocation;

  List<LocationModule> _entities = [];
  late SearchType _currentType;
  bool _answered = false;
  bool isLoaded = false;

  @override
  void initState() {
    searchTypeController.getSearchTypes();
    Future.delayed(const Duration(seconds: 1), () {
      _getNewSearchType();
    });

    _geoService = GeoServices(overpassApi: _overpassApi);
    currentLocationController.getLocation();
    _initialize();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {});

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoaded == false
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: Center(
                  child: Text("I am the Osm Stret Map",
                      style: TextStyle(color: Colors.black))),
            ),
            body: Center(
                child: Stack(
              children: [_getMap(), _getTopContainer()],
            )),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                _proceed();
              },
              child: Icon(Icons.check),
            ),
          );
  }

  void _initialize() async {
    _searchTypes = await SearchTypeService().getSearchTypes();
    _locations = await _geoService.getLocations();
    print(_locations.length);
    _getNewLocation();
    _getNewSearchType();
    setState(() {
      isLoaded = true;
    });
  }

  void _proceed() async {
    if (_answered == true) {
      _showNewQuestion();
      return;
    }

    _answerQuestion();
  }

  void _showNewQuestion() {
    setState(() {
      _getNewLocation();
      _getNewSearchType();
      _entities = [];
      _answered = false;
    });
  }

  Future _answerQuestion() async {
    _indicateLoading();

    _entities = await GeoServices(overpassApi: _overpassApi)
        .getEntitiesInArea(center: _currentLocation, type: _currentType);

    Navigator.of(context).pop();

    setState(() {
      _answered = true;
    });
  }

  void _getNewSearchType() {
    String text = "My Serach Type lenght is";

    setState(() {
      _currentType = _searchTypes[Random().nextInt(_searchTypes.length)];
    });
  }

  void _indicateLoading() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
            content: Container(
                child: Text(
              'Fetching geo data ...',
              textAlign: TextAlign.center,
            )),
          );
        });
  }

  void _getNewLocation() {
    if (_locations.isEmpty) {
      return;
    }
    print(_locations.length);
    setState(() {
      _currentLocation = _locations[Random().nextInt(_locations.length)];
    });

    // _mapController.move(
    //     LatLng((_currentLocation.latitude), (_currentLocation.longitude)), 11);
  }

  FlutterMap _getMap() {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        center: _currentLocation != null
            ? LatLng((_currentLocation.latitude), (_currentLocation.longitude))
            : null,
        zoom: 11,
      ),
      layers: [
        TileLayerOptions(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c']),
        MarkerLayerOptions(
          markers: _getMarkers(),
        ),
        MarkerLayerOptions(
          markers: _getAreaMarkers(),
        ),
      ],
    );
  }

  List<Marker> _getMarkers() {
    List<Marker> markers = [];

    for (LocationModule location in _entities) {
      markers.add(Marker(
          width: 120,
          height: 120,
          point: LatLng((location.latitude), (location.longitude)),
          builder: (ctx) => IconButton(
              onPressed: () {
                print(location.name);
                print(location.latitude);
              },
              icon: Icon(
                Icons.pin_drop,
                color: Colors.red,
              ))));
    }
    print(markers.length);
    return markers;
  }

  List<Marker> _getAreaMarkers() {
    if (_currentLocation == null) {
      return [];
    }

    return [
      Marker(
        width: 230.0,
        height: 230.0,
        point:
            LatLng((_currentLocation.latitude), (_currentLocation.longitude)),
        builder: (ctx) => Container(
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue.withOpacity(0.1),
              border: Border.all(color: Colors.blueAccent)),
        ),
      )
    ];
  }

  Container _getTopContainer() {
    return Container(
      alignment: Alignment.topCenter,
      child: Container(
          padding: EdgeInsets.all(10),
          height: 100,
          alignment: Alignment.center,
          width: double.infinity,
          color: Colors.white.withOpacity(0.8),
          child: Text(
            _getText(),
            style: TextStyle(fontSize: 24),
            textAlign: TextAlign.center,
          )),
    );
  }

  String _getText() {
    if (_currentLocation == null) {
      return '';
    }

    if (_currentType == null) {
      return '';
    }

    if (_answered == false) {
      return "How many ${_currentType.plural} are there 5 km around ${_currentLocation.name}?";
    }

    return "${_entities.length.toString()} ${_currentType.plural}\naround ${_currentLocation.name}";
  }

  // this is theh dummy data to load the user current location

}
