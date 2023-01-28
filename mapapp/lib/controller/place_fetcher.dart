import "package:mapapp/model/place.dart";
import 'package:http/http.dart' as http;
import 'package:mapapp/secret/api_key.dart';
import 'dart:convert';
import 'dart:developer';

Future<List<Place>> fetchPlaces(
    String query, String lat, String lng, bool basic) async {
  List<Place> placesData = [];

  if (basic) {
    return placesData;
  }

  /*String complete =
      "https://maps.googleapis.com/maps/api/place/nearbysearch/json?keyword=&location=-33.8670522%2C151.1957362&radius=1500&type=restaurant&key=YOUR_API_KEY";*/
  String base =
      "https://maps.googleapis.com/maps/api/place/nearbysearch/json?keyword=&location=";
  base = "$base$lat%2C$lng&radius=5000&type=$query&key=$googleMapsAPIKey";

  log('base api link: $base');

  final response = await http.get(Uri.parse(base));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    List<dynamic> places = jsonDecode(response.body)["results"];

    places.forEach((place) {
      placesData.add(Place.fromJson(place));
    });

    return placesData;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load results');
  }
}

//Future<Place> getMoreData(Place place) async {}
