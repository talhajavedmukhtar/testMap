import 'dart:ffi';
import 'dart:developer';

class Place {
  final String name;
  final String thumbNail;
  final String description;
  final String address;
  final double latitude;
  final double longitude;
  final List<String> pictures;

  const Place(
      {required this.name,
      required this.thumbNail,
      required this.description,
      required this.address,
      required this.latitude,
      required this.longitude,
      required this.pictures});

  factory Place.fromJson(Map<String, dynamic> json) {
    try {
      return Place(
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
