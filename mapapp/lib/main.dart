import 'dart:ffi';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:custom_info_window/custom_info_window.dart';

import 'package:mapapp/controller/place_fetcher.dart';
import 'package:mapapp/route/details_page.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import "package:mapapp/model/place.dart";
import 'package:mapapp/secret/api_key.dart';
import 'dart:developer';
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Map App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Map App'),
      initialRoute: '/',
      routes: {
        DetailsRoute.routeName: (context) => const DetailsRoute(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late GoogleMapController mapController;

  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();

  final String lat = "51.5085";
  final String lng = "-0.1257";

  final LatLng _center = const LatLng(51.5085, -0.1257);
  Set<Marker> markers = new Set();
  List<Place> places = [];
  late Future<List<Place>> futurePlaces;

  String searchQuery = "";
  String lastTriggeredSearch = "Search...";

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _customInfoWindowController.googleMapController = controller;
  }

  @override
  void initState() {
    super.initState();
    futurePlaces = fetchPlaces(" ", lat, lng, true);
  }

  @override
  void dispose() {
    _customInfoWindowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          fit: StackFit.expand,
          children: [
            //buildMap(),
            FutureBuilder(
                future: futurePlaces,
                builder: (BuildContext jsoncontext, AsyncSnapshot snapshot) {
                  return buildMap(snapshot);
                }),
            buildFloatingSearchBar(),
            CustomInfoWindow(
              controller: _customInfoWindowController,
              height: 300,
              width: 200,
              offset: 0,
            )
          ],
        ));
  }

  Widget buildMap(AsyncSnapshot snapshot) {
    List<Place> places = [];
    if (snapshot.hasData) {
      places = snapshot.data;
    }

    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: _center,
        zoom: 11.0,
      ),
      markers: getMarkers(places),
      onTap: (position) {
        _customInfoWindowController.hideInfoWindow!();
      },
      onCameraMove: (position) {
        _customInfoWindowController.onCameraMove!();
      },
    );
  }

  Widget buildFloatingSearchBar() {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return FloatingSearchBar(
      hint: lastTriggeredSearch,
      /*scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
      transitionDuration: const Duration(milliseconds: 800),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      axisAlignment: isPortrait ? 0.0 : -1.0,
      openAxisAlignment: 0.0,
      width: isPortrait ? 600 : 500,
      debounceDelay: const Duration(milliseconds: 500),*/
      onQueryChanged: (query) {
        setState(() {
          searchQuery = query;
          log('base search query changed: $searchQuery');
        });
      },
      onSubmitted: (query) {
        setState(() {
          log('base search query submitted: $searchQuery');
          lastTriggeredSearch = 'Last search: $searchQuery';
          _customInfoWindowController.hideInfoWindow!();
          futurePlaces = fetchPlaces(searchQuery, lat, lng, false);
        });
      },
      // Specify a custom transition to be used for
      // animating between opened and closed stated.
      //transition: CircularFloatingSearchBarTransition(),
      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: CircularButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              setState(() {
                log('base places should be fetched');
                futurePlaces = fetchPlaces(searchQuery, lat, lng, false);
              });
            },
          ),
        ),
        FloatingSearchBarAction.searchToClear(
          showIfClosed: false,
        ),
      ],
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: const Material(
            color: Colors.white,
            elevation: 4.0,
            /*child: Column(
              mainAxisSize: MainAxisSize.min,
              children: Colors.accents.map((color) {
                return Container(height: 112, color: color);
              }).toList(),
            ),*/
          ),
        );
      },
    );
  }

  Set<Marker> getMarkers(List<Place> places) {
    markers = new Set();

    places.forEach((place) {
      final LatLng point = LatLng(place.latitude, place.longitude);
      final name = place.name;
      final thumbnail = place.thumbNail;
      final address = place.address;
      final description = place.description;
      final pictures = place.pictures;

      markers.add(Marker(
        markerId: MarkerId(point.toString()),
        position: point, //position of marker
        onTap: () {
          _customInfoWindowController.addInfoWindow!(
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                    padding: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(2),
                      border: Border.all(),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Image.network(
                                      'https://maps.googleapis.com/maps/api/place/photo?maxwidth=70&photo_reference=$thumbnail&key=$googleMapsAPIKey')),
                            ]),
                        Text(name,
                            style: TextStyle(
                                fontSize: 17.0, fontWeight: FontWeight.bold)),
                        Text('Address: $address',
                            style: TextStyle(
                              fontSize: 10.0,
                            )),
                        Text('Description: $description'),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                  style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      alignment: Alignment.centerLeft),
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, DetailsRoute.routeName,
                                        arguments: DetailsArguments(
                                            name, description, pictures));
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(5.0),
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(2),
                                      border: Border.all(),
                                    ),
                                    child: const Text('View Details',
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            color: Colors.white)),
                                  )),
                            ])
                      ],
                    )),
              ]),
              point);
        },
        icon: BitmapDescriptor.defaultMarker, //Icon for Marker
      ));
    });

    return markers;
  }
}
