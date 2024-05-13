
import 'package:favorite_places/models/place.dart';
import 'package:flutter/material.dart';
import 'package:favorite_places/screens/place_details.dart';

class PlacesList extends StatelessWidget {
  const PlacesList({super.key, required this.places});

  final List<Place> places;

  @override
  Widget build(BuildContext context) {
    if (places.isEmpty) {
      return Center(
        child: Text('No favorite places added yet',
         style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.onBackground))
         );
    }
    return  ListView.builder(
      itemCount: places.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            radius: 26,
            backgroundImage: FileImage(places[index].image!),
          ),
          title: Text(places[index].title, style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.onBackground),),
          subtitle: Text(places[index].location.address, style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Theme.of(context).colorScheme.onBackground),),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              // remove the place from the list

            },
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => PlaceDetailsScreen(place: places[index]),
              ),
              );
          },
        );
      },
    ); 
  }
}