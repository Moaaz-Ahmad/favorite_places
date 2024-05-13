import 'package:favorite_places/screens/map.dart';
import 'package:flutter/material.dart';
import 'package:favorite_places/models/place.dart';

class PlaceDetailsScreen extends StatelessWidget {

  const PlaceDetailsScreen({super.key,required this.place});

  final Place place;

  String get locationImage{
    return 'https://maps.googleapis.com/maps/api/staticmap?center=${place.location.latitude},${place.location.longitude}&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C${place.location.latitude},${place.location.longitude}&key=b0cb08b632014eefb9868ea0a2ac8af6';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Place Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    place.image!,
                    width: double.infinity,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => MapScreen(location: place.location)));
                        },
                        child: CircleAvatar(
                          radius: 17,
                          backgroundImage: NetworkImage(locationImage),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Colors.transparent,
                              Colors.black54,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          place.location.address,
                          style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Theme.of(context).colorScheme.onBackground),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}