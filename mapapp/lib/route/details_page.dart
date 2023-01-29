import 'package:flutter/material.dart';
import '../secret/api_key.dart';
import 'package:carousel_slider/carousel_slider.dart';

class DetailsRoute extends StatelessWidget {
  const DetailsRoute({super.key});

  static const routeName = '/details';

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as DetailsArguments;

    final String name = args.name;
    final String description = args.description;
    final List<String> images = args.imageLinks;

    return Scaffold(
        /*appBar: AppBar(
        title: const Text('Details'),
      ),*/
        /*body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Go back!'),
        ),
      ),*/
        /*body: Column(
      children: [
        //back/cross button (row with start or end)
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back)),
          ],
        ),

        //images carousel
        //Image.network('https://maps.googleapis.com/maps/api/place/photo?maxwidth=70&photo_reference=$thumbnail&key=$googleMapsAPIKey')

        //Name
        Text("Name here"),
        //Description
        Text("Description here"),
      ],
    ));*/
        body: Container(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                //back/cross button (row with start or end)
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back)),
                  ],
                ),

                Text("Title:"),
                Text(name,
                    style:
                        TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold)),

                //images carousel
                Container(
                  padding: EdgeInsets.only(top: 30, bottom: 30),
                  child: CarouselSlider(
                    options: CarouselOptions(height: 400.0),
                    items: images.map((i) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.symmetric(horizontal: 5.0),
                              //decoration: BoxDecoration(color: Colors.white),
                              child: Image.network(
                                  'https://maps.googleapis.com/maps/api/place/photo?maxwidth=500&photo_reference=$i&key=$googleMapsAPIKey'));
                        },
                      );
                    }).toList(),
                  ),
                ),

                Text("Description: $description"),
              ],
            )));
  }
}

class DetailsArguments {
  final String name;
  final String description;
  final List<String> imageLinks;

  DetailsArguments(this.name, this.description, this.imageLinks);
}
