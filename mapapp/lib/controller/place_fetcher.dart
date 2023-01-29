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

    List<Future<Place>> secureFutures = [];
    places.forEach((place) {
      Future<Place> augmented = getMoreData(Place.fromJson(place));
      secureFutures.add(augmented);
    });

    List<Place> resolvedFutures = await Future.wait(secureFutures);

    resolvedFutures.forEach((place) {
      String address = place.address;
      log("base augmented place addy: $address");
      placesData.add(place);
    });

    return placesData;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load results');
  }
}

Future<Place> getMoreData(Place place) async {
  Place augmented = place;
  String id = place.id;
  String base =
      'https://maps.googleapis.com/maps/api/place/details/json?fields=photos%2Cformatted_address%2Ceditorial_summary&place_id=';
  base = '$base$id&key=$googleMapsAPIKey';

  log('augmentation api link: $base');

  final response = await http.get(Uri.parse(base));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    Map<String, dynamic> responseBody = jsonDecode(response.body)['result'];

    log("base map: $responseBody");
    if (responseBody.containsKey('formatted_address')) {
      augmented.address = responseBody["formatted_address"];
    } else {
      augmented.address = "";
    }

    if (responseBody.containsKey('editorial_summary')) {
      augmented.description = responseBody["editorial_summary"]["overview"];
    } else {
      augmented.description = "Not Available";
    }

    if (responseBody.containsKey('photos')) {
      List<dynamic> photos = responseBody["photos"];

      photos.forEach((photo) {
        augmented.pictures.add(photo["photo_reference"]);
      });
    } else {
      augmented.pictures = [];
    }
    log("base augmented place created succesfully");
    return augmented;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    log("base augmented place failed to create succesfully");
    throw Exception('Failed to load results');
  }
}
