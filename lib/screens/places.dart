import 'package:favorite_places/providers/user_places.dart';
import 'package:favorite_places/screens/add_place.dart';
import 'package:favorite_places/widgets/places_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlacesScreen extends ConsumerStatefulWidget {
  const PlacesScreen({super.key});

  @override
  ConsumerState<PlacesScreen> createState() => _PlacesScreenState();
}
class _PlacesScreenState extends ConsumerState<PlacesScreen> {
  late Future<void> _placesFuture;
  @override
  void initState() {
    _placesFuture = ref.read(userPlacesProvider.notifier).loadPlaces();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final favoritePlaces = ref.watch(userPlacesProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Places'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddPlaceScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future:_placesFuture,
        builder: (ctx, snapshot) => snapshot.connectionState == ConnectionState.waiting
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : PlacesList(places: favoritePlaces),
      ),
    );
  }
}