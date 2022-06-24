import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:mapmosphere/controller/OverPassApiController.dart';
import 'package:mapmosphere/controller/geoLocation_Controller.dart';
import 'package:mapmosphere/controller/mycustomeController/myPointController.dart';
import 'package:mapmosphere/module/LocationModule.dart';
import 'package:mapmosphere/module/MyCostumeModule/pointDataModel.dart';
import 'package:mapmosphere/module/MyCostumeModule/searchModule.dart';
import 'package:mapmosphere/services/geo_Services.dart';
import 'package:mapmosphere/testDocument/displayLocalMap.dart';
import 'package:mapmosphere/view/TagInputSection.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../controller/SearchTypeServiceController.dart';
import '../module/SearchTypeModel.dart';
import 'package:http/http.dart' as http;

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
  bool isFirst = true;
// this is the marker name
  String name = "hero";
  // this is the longitude and latitude of the pinned area
  double pinLong = 10.00;
  double pinLat = -20.00;

  // this is the list of the custome serch module
  List<CustomeSearchModule> customeSearchModule = [];

  // index of search module
  int indexOfSearch = 0;

// this is the  locationName
  List<CustomeSearchModule> locationModel = [];
  int indexOfLocation = 0;
  // this is the boolean function to check the visibility of searchfield
  bool isVisible = false;
  // thhis is used to maintain the zoom level of the map
  double zoomMap = 15.0;
  // this is name of the search amnity
  String nameOfSearchAmnity = "";
  // this is the name of the selected point types
  String selectedType = "Bar";
  // this is sthe list of the selected features
  List<PointDataModel> selectedFeatures = [];
  // this is the const textEditing controller

// this is the font family
  String fontfamily = "Supreme-Regular";
  @override
  void initState() {
    searchTypeController.getSearchTypes();
    Future.delayed(const Duration(seconds: 1), () {
      _getNewSearchType();
      _getNewLocation();
    });

    _geoService = GeoServices(overpassApi: _overpassApi);
    currentLocationController.getLocation();
    _initialize();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {});

    super.initState();
  }

// this is the controller disposer

  @override
  Widget build(BuildContext context) {
    return isLoaded == false
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              iconTheme: const IconThemeData(color: Colors.black, size: 30),
              centerTitle: true,
              title: isVisible
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 40,
                        child: const Center(
                          child: TextField(
                              decoration: InputDecoration(
                            hintText: "Search.....",
                            hintStyle: TextStyle(
                              color: Colors.teal,
                              fontFamily: "Supreme-Regular",
                              fontSize: 15,
                            ),
                            border: const OutlineInputBorder(),
                          )),
                        ),
                      ),
                    )
                  : Text(
                      nameOfSearchAmnity != ''
                          ? nameOfSearchAmnity
                          : "MapMoSphere",
                      style: const TextStyle(
                        color: const Color(0xff3721a4),
                        fontFamily: "Tanker-Regular",
                        letterSpacing: 1.3,
                        fontSize: 20,
                      ),
                    ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        if (isVisible == false) {
                          isVisible = true;
                        } else if (isVisible == true) {
                          isVisible = false;
                        }
                      });
                    },
                    icon: const Icon(
                      Icons.search,
                      color: Color(0xff3721a4),
                      size: 40,
                    ),
                  ),
                ),
              ],
            ),
            drawer: Drawer(
              child: ListView(
                children: [
                  Container(
                      height: MediaQuery.of(context).size.height * 0.31,
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                        image: AssetImage('assets/images/Logo Crop.png'),
                        fit: BoxFit.fill,
                      ))),
                  // this is the drawer body
                  ExpansionTile(
                    title: const Text(
                      "Choose Search Type",
                      style: TextStyle(
                        color: Color(0xff3721a4),
                        fontFamily: "Supreme-Regular",
                        fontSize: 20,
                      ),
                    ),
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.35,
                        width: MediaQuery.of(context).size.width,
                        child: isLoaded == false
                            ? const Text("Loading...")
                            : ListView.builder(
                                itemCount: customeSearchModule.length,
                                itemBuilder: ((context, index) {
                                  return Card(
                                    child: ListTile(
                                      trailing: const Icon(
                                        Icons.search,
                                        color: Color(0xff3721a4),
                                      ),
                                      onTap: () {
                                        setState(() {
                                          indexOfSearch = index;
                                          print(indexOfSearch);
                                          nameOfSearchAmnity =
                                              customeSearchModule[index]
                                                  .name
                                                  .toUpperCase();
                                        });
                                        _getNewSearchType();
                                        Navigator.pop(context);
                                      },
                                      title: Text(
                                        customeSearchModule[index]
                                            .name
                                            .toUpperCase(),
                                        style: const TextStyle(
                                          color: Colors.teal,
                                          letterSpacing: 0.5,
                                          fontFamily: "Supreme-Regular",
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                      ),
                    ],
                  ),
                  // this is for the location
                  ExpansionTile(
                    title: const Text(
                      "Choose Search Location",
                      style: TextStyle(
                        color: Color(0xff3721a4),
                        fontFamily: "Supreme-Regular",
                        fontSize: 20,
                      ),
                    ),
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.35,
                        width: MediaQuery.of(context).size.width,
                        child: isLoaded == false
                            ? const Text("Loading...")
                            : ListView.builder(
                                itemCount: locationModel.length,
                                itemBuilder: ((context, index) {
                                  return Card(
                                    child: ListTile(
                                      trailing: const Icon(
                                        Icons.search,
                                        color: Color(0xff3721a4),
                                      ),
                                      onTap: () {
                                        setState(() {
                                          indexOfLocation = index;
                                          print(indexOfSearch);
                                        });
                                        _getNewLocation();
                                        Navigator.pop(context);
                                      },
                                      title: Text(
                                        locationModel[index].name.toUpperCase(),
                                        style: const TextStyle(
                                          color: Colors.teal,
                                          letterSpacing: 0.5,
                                          fontFamily: "Supreme-Regular",
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                      ),
                    ],
                  ),
                  // this is used to view the local pins
                  // Card(
                  //   child: ListTile(
                  //     onTap: () {
                  //       Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //               builder: (context) => DisplayLocalMap()));
                  //     },
                  //     title: const Text(
                  //       "View Local Pins",
                  //       style: TextStyle(
                  //         color: Color(0xff3721a4),
                  //         fontFamily: "Supreme-Regular",
                  //         fontSize: 20,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
            body: Center(
                child: Stack(
              children: [
                _getMap(),
              ],
            )),
            floatingActionButton: Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Row(
                children: [
                  Column(
                    children: [
                      const Spacer(),
                      FloatingActionButton(
                        heroTag: "btn1",
                        backgroundColor: const Color(0xff3721a4),
                        onPressed: () {
                          _mapController.move(
                              LatLng(
                                  double.parse(
                                      currentLocationController.latitude.value),
                                  double.parse(currentLocationController
                                      .longitude.value)),
                              13);
                        },
                        child: const Icon(
                          Icons.gps_fixed_rounded,
                          size: 30,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FloatingActionButton(
                          backgroundColor: const Color(0xff3721a4),
                          onPressed: () {
                            zoomPlus();
                          },
                          child: const Icon(
                            Icons.zoom_in,
                            size: 30,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FloatingActionButton(
                          heroTag: "btn2",
                          backgroundColor: const Color(0xff3721a4),
                          onPressed: () {
                            zoomMinus();
                          },
                          child: const Icon(
                            Icons.zoom_out,
                            size: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    children: [
                      const Spacer(),
                      FloatingActionButton(
                        heroTag: "btn3",
                        backgroundColor: const Color(0xff3721a4),
                        onPressed: () {
                          _proceed();
                        },
                        child: const Icon(Icons.check),
                      ),
                    ],
                  ),
                ],
              ),
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
      isFirst = false;
    });
  }

  void _proceed() async {
    fetchMapData();
  }

  void _showNewQuestion() {
    setState(() {
      _getNewLocation();
      _getNewSearchType();
      _entities = [];
      _answered = false;
    });
  }

  Future fetchMapData() async {
    _indicateLoading();

    _entities = await GeoServices(overpassApi: _overpassApi)
        .getEntitiesInArea(center: _currentLocation, type: _currentType);

    Navigator.of(context).pop();

    setState(() {
      _answered = true;
    });
  }

  void _getNewSearchType() {
    customeSearchModule = [];
    String text = "My Serach Type lenght is";
    for (var i = 0; i < _searchTypes.length; i++) {
      customeSearchModule.add(CustomeSearchModule(
          name: _searchTypes[i]
              .tags
              .toString()
              .split(":")
              .last
              .split("}")
              .first));
    }
    setState(() {
      _currentType = _searchTypes[indexOfSearch];
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
                child: const Text(
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

    locationModel = [];

    for (var i = 0; i < _locations.length; i++) {
      locationModel.add(CustomeSearchModule(name: _locations[i].name));
      print(locationModel[i].name);
    }
    setState(() {
      _currentLocation = _locations[indexOfLocation];
    });

    if (isFirst == true) {
      print("map uninitialized");
    } else {
      _mapController.move(
          LatLng((_currentLocation.latitude), (_currentLocation.longitude)),
          11);
    }
  }

  FlutterMap _getMap() {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
          center: _currentLocation != null
              ? LatLng(
                  (_currentLocation.latitude), (_currentLocation.longitude))
              : null,
          zoom: zoomMap,
          onLongPress: (position, latLang) {
            setState(() {
              pinLong = latLang.longitude;
              pinLat = latLang.latitude;
              print(pinLong);
              print(pinLat);
            });
          }),
      layers: [
        TileLayerOptions(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c']),
        MarkerLayerOptions(
          markers: _getMarkers(),
        ),
        MarkerLayerOptions(
          markers: [
            Marker(
              width: 120,
              height: 120,
              point: LatLng(pinLat, pinLong),
              builder: (ctx) => IconButton(
                onPressed: () {
                  // this  is used to call the button sheet to load the data to the data base
                  DataButtonSheet();
                },
                icon: const Icon(
                  Icons.pin_drop,
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  List<Marker> _getMarkers() {
    List<Marker> markers = [];

    for (LocationModule location in _entities) {
      markers.add(
        Marker(
          width: 120,
          height: 120,
          point: LatLng((location.latitude), (location.longitude)),
          builder: (ctx) => IconButton(
            onPressed: () {
              print(location.name);
              print(location.latitude);
              setState(() {
                name = location.name;
              });
              showBarModalBottomSheet(
                context: context,
                builder: (context) => SingleChildScrollView(
                  controller: ModalScrollController.of(context),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.black,
                    child: Column(
                      children: [
                        Card(
                            elevation: 1,
                            color: Colors.white,
                            child: ListTile(
                              leading: const Icon(
                                Icons.build_circle_outlined,
                                color: Color(0xff3721a4),
                                size: 30,
                              ),
                              title: Text(
                                location.name.toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.black,
                                  letterSpacing: 4.0,
                                  fontFamily: "Supreme-Regular",
                                  fontSize: 20,
                                ),
                              ),
                              subtitle: Text(
                                "Name of the " + nameOfSearchAmnity,
                                style: const TextStyle(
                                  color: Colors.red,
                                  letterSpacing: 2.0,
                                  fontFamily: "Supreme-Regular",
                                  fontSize: 16,
                                ),
                              ),
                            )),
                        // this is the latitude of the place
                        Card(
                            elevation: 1,
                            color: Colors.white,
                            child: ListTile(
                              leading: const Icon(
                                Icons.location_city_outlined,
                                color: Color(0xff3721a4),
                                size: 30,
                              ),
                              title: Text(
                                location.latitude.toString(),
                                style: const TextStyle(
                                  color: Colors.black,
                                  letterSpacing: 4.0,
                                  fontFamily: "Supreme-Regular",
                                  fontSize: 20,
                                ),
                              ),
                              subtitle: Text(
                                "Latitude of the " + nameOfSearchAmnity,
                                style: const TextStyle(
                                  color: Colors.red,
                                  letterSpacing: 2.0,
                                  fontFamily: "Supreme-Regular",
                                  fontSize: 16,
                                ),
                              ),
                            )),
                        // this is the longitude of the pub
                        // this is the latitude of the place
                        Card(
                            elevation: 1,
                            color: Colors.white,
                            child: ListTile(
                              leading: const Icon(
                                Icons.location_on_sharp,
                                color: Color(0xff3721a4),
                                size: 30,
                              ),
                              title: Text(
                                location.longitude.toString(),
                                style: const TextStyle(
                                  color: Colors.black,
                                  letterSpacing: 4.0,
                                  fontSize: 20,
                                  fontFamily: "Supreme-Regular",
                                ),
                              ),
                              subtitle: Text(
                                "Longitude of the " + nameOfSearchAmnity,
                                style: const TextStyle(
                                  color: Colors.red,
                                  letterSpacing: 2.0,
                                  fontFamily: "Supreme-Regular",
                                  fontSize: 16,
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
              );
            },
            icon: const Icon(
              Icons.pin_drop,
              color: Colors.red,
            ),
          ),
        ),
      );
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
          padding: const EdgeInsets.all(10),
          height: 100,
          alignment: Alignment.center,
          width: double.infinity,
          color: Colors.white.withOpacity(0.8),
          child: Text(
            _getText(),
            style: const TextStyle(fontSize: 24),
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
      return " ${_currentType.plural} ${_currentLocation.name}?";
    }

    return "${_entities.length.toString()} ${_currentType.plural}";
  }

  // this is the function to control the zoom level
  void zoomPlus() {
    setState(() {
      zoomMap = zoomMap + 0.05;
    });
    _mapController.move(
        LatLng((_currentLocation.latitude), (_currentLocation.longitude)),
        zoomMap);
  }

  void zoomMinus() {
    setState(() {
      zoomMap = zoomMap - 0.05;
    });
    _mapController.move(
        LatLng((_currentLocation.latitude), (_currentLocation.longitude)),
        zoomMap);
  }

  // this is the button sheet to load the data to the data base
  Future DataButtonSheet() {
    return showBarModalBottomSheet(
      context: context,
      builder: (context) => SingleChildScrollView(
        controller: ModalScrollController.of(context),
        child: Container(
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width,
            color: Colors.black,
            child: ListView.builder(
                itemCount: PointDataController().pointData.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      selectedFeatures = [];
                      Navigator.pop(context);
                      selectedFeatures.add(PointDataModel(
                          pointName:
                              PointDataController().pointData[index].pointName,
                          iconData:
                              PointDataController().pointData[index].iconData));
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserInputTagData(
                                  selectedFeatures, pinLat, pinLong)));
                    },
                    child: Chip(
                      avatar: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        child: Icon(
                          PointDataController().pointData[index].iconData,
                          color: Color(0xff3721a4),
                        ),
                      ),
                      label: Text(
                        PointDataController().pointData[index].pointName,
                        style: const TextStyle(
                          color: Colors.black,
                          fontFamily: "Supreme-Regular",
                          fontSize: 20,
                        ),
                      ),
                    ),
                  );
                })),
      ),
    );
  }

//this is the user input Point data Model
//   Future UserInputPointData() {
//     return showBarModalBottomSheet(
//         backgroundColor: Colors.black,
//         context: context,
//         builder: (context) {
//           controller:
//           ModalScrollController.of(context);
//           return SingleChildScrollView(
//             child: Container(
//               height: MediaQuery.of(context).size.height * 0.9,
//               width: MediaQuery.of(context).size.width,
//               child: Column(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Card(
//                       child: ExpansionTile(
//                           initiallyExpanded: true,
//                           backgroundColor: Colors.white,
//                           title: const Text(
//                             "Features Types",
//                             style: TextStyle(color: Colors.blue, fontSize: 20),
//                           ),
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Container(
//                                 height: 70,
//                                 width: MediaQuery.of(context).size.width,
//                                 color: Colors.red,
//                                 child: Row(
//                                   children: [
//                                     Expanded(
//                                       flex: 1,
//                                       child: Container(
//                                         width: 20,
//                                         color: Colors.white,
//                                         child: Center(
//                                           child: Icon(
//                                               selectedFeatures.first.iconData),
//                                         ),
//                                       ),
//                                     ),
//                                     // this is the name of the features types
//                                     Expanded(
//                                       flex: 3,
//                                       child: Container(
//                                         width: 20,
//                                         color: Colors.white54,
//                                         child: Center(
//                                           child: Text(
//                                             selectedFeatures.first.pointName,
//                                             style: const TextStyle(
//                                                 color: Colors.white,
//                                                 fontSize: 20,
//                                                 fontWeight: FontWeight.bold),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             )
//                           ]),
//                     ),
//                   ),
//                   // this is the another expansion tile
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Card(
//                       child: ExpansionTile(
//                           backgroundColor: Colors.white,
//                           title: const Text(
//                             "Fields",
//                             style: TextStyle(color: Colors.blue, fontSize: 20),
//                           ),
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Container(
//                                 padding:
//                                     const EdgeInsets.fromLTRB(10, 2, 10, 2),
//                                 decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(5),
//                                     border: Border.all(color: Colors.red)),
//                                 child: TextField(
//                                   decoration: const InputDecoration(
//                                     border: InputBorder.none,
//                                     labelText: "Name",
//                                   ),
//                                   controller: pinPointName,
//                                 ),
//                               ),
//                             ),
//                             // this is the description of the pinPoint
//                             Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Container(
//                                 padding:
//                                     const EdgeInsets.fromLTRB(10, 2, 10, 2),
//                                 decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(5),
//                                     border: Border.all(color: Colors.red)),
//                                 child: TextField(
//                                   decoration: const InputDecoration(
//                                     border: InputBorder.none,
//                                     labelText: "Description",
//                                   ),
//                                   controller: pinPointDescription,
//                                 ),
//                               ),
//                             )
//                           ]),
//                     ),
//                   ),
//                   // this is the expansion fields to add the tags
//                   ExpansionTile(
//                     title: Text("Tags"),
//                     children: [
//                       _addTile(),
//                       Container(
//                         height: MediaQuery.of(context).size.height * 0.3,
//                         width: MediaQuery.of(context).size.width,
//                         child: ListView.builder(
//                             scrollDirection: Axis.vertical,
//                             itemCount: nameController.length,
//                             itemBuilder: (context, index) {
//                               return Container(
//                                 margin: EdgeInsets.all(5),
//                                 child: InputDecorator(
//                                   child: Column(
//                                     children: [
//                                       nameFields[index],
//                                       tagFields[index],
//                                     ],
//                                   ),
//                                   decoration: InputDecoration(
//                                     labelText: index.toString(),
//                                     border: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(10.0),
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             }),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           );
//         });
//   }

// // this is the code to add tags fields
//   Widget _addTile() {
//     return ListTile(
//       title: Icon(Icons.add),
//       onTap: () {
//         final name = TextEditingController();
//         final tag = TextEditingController();

//         final nameField = _generateTextField(name, "name");
//         final telField = _generateTextField(tag, "Tag");

//         setState(() {
//           nameController.add(name);
//           tagController.add(tag);

//           nameFields.add(nameField);
//           tagFields.add(telField);
//         });
//       },
//     );
//   }

//   TextField _generateTextField(TextEditingController controller, String hint) {
//     return TextField(
//       controller: controller,
//       decoration: InputDecoration(
//         border: OutlineInputBorder(),
//         labelText: hint,
//       ),
//     );
//   }
}
