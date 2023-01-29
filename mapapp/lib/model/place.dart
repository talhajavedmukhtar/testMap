import 'dart:ffi';
import 'dart:developer';

class Place {
  final String id;
  final String name;
  final String thumbNail;
  String description;
  String address;
  final double latitude;
  final double longitude;
  List<String> pictures;

  Place(
      {required this.id,
      required this.name,
      required this.thumbNail,
      required this.description,
      required this.address,
      required this.latitude,
      required this.longitude,
      required this.pictures});

  factory Place.fromJson(Map<String, dynamic> json) {
    try {
      return Place(
          id: json['place_id'],
          name: json['name'],
          thumbNail: json['photos'][0]['photo_reference'],
          description: "",
          address: "",
          latitude: json['geometry']['location']['lat'],
          longitude: json['geometry']['location']['lng'],
          pictures: []);
    } catch (e) {
      log('base picture fault');
      return Place(
          id: json['place_id'],
          name: json['name'],
          thumbNail: "",
          description: "",
          address: "",
          latitude: json['geometry']['location']['lat'],
          longitude: json['geometry']['location']['lng'],
          pictures: []);
    }
  }
}
