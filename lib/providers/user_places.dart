import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:favorite_places/models/place.dart';
import 'package:path_provider/path_provider.dart' as syspath;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

Future<Database> getDatabase() async {
  final appDir = await syspath.getApplicationDocumentsDirectory();
  final db = await sql.openDatabase(path.join(appDir.path, 'places.db'), onCreate: (db, version) {
    return db.execute('CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT, loc_lat REAL, loc_lng REAL, address TEXT)');
  }, version: 1);
  return db;
}

class UserPlacesNotifier extends StateNotifier<List<Place>> {
  UserPlacesNotifier() : super(const []);
  Future<void> loadPlaces() async{
    final db = await getDatabase();
    final List<Place> loadedPlaces = [];
    db.query('user_places').then((value) {
      for (var i = 0; i < value.length; i++) {
        loadedPlaces.add(Place(
          id: value[i]['id'] as String,
          image: File(value[i]['image'] as String),
          title: value[i]['title'] as String,
          location: PlaceLocation(
            latitude: value[i]['loc_lat'] as double,
            longitude: value[i]['loc_lng'] as double,
            address: value[i]['address'] as String,
          ),
        ));
      }
    });
    state = loadedPlaces;
  }

  void addPlace(String place, File image, PlaceLocation location) async{
    final appDir = await syspath.getApplicationDocumentsDirectory();
    final fileName = path.basename(image.path);
    final savedImage = await image.copy('${appDir.path}/$fileName');
    final newPlace = Place(title: place, image: savedImage, location: location);
    final db = await getDatabase();
    db.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image!.path,
      'loc_lat': newPlace.location.latitude,
      'loc_lng': newPlace.location.longitude,
      'address': newPlace.location.address,
    });
    state = [newPlace,...state];
  }
  void removePlace(Place place) {
    state = state.where((element) => element != place).toList();
  }
}
final userPlacesProvider = StateNotifierProvider<UserPlacesNotifier, List<Place>>((ref) => UserPlacesNotifier());