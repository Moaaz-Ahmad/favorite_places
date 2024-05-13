import 'dart:io';

import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/widgets/image_input.dart';
import 'package:favorite_places/widgets/location_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:favorite_places/providers/user_places.dart';

class AddPlaceScreen extends ConsumerStatefulWidget {
  const AddPlaceScreen({super.key});
  @override
  ConsumerState<AddPlaceScreen> createState() => _AddPlaceScreenState();
}
class _AddPlaceScreenState extends ConsumerState<AddPlaceScreen> {
  final _titleController = TextEditingController();
  File? _pickedImage;
  PlaceLocation? _pickedLocation; 
  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }
    void _savePlace() {
      final title = _titleController.text;
      if (title.isEmpty || _pickedImage == null) {
        return;
      }
      ref.read(userPlacesProvider.notifier).addPlace(title, _pickedImage!, _pickedLocation!);
      Navigator.pop(context);
    }
    @override
    Widget build(BuildContext context) {
      return Scaffold(
      appBar: AppBar(
        title: const Text('Add Favorite Place'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
              decoration: const InputDecoration(
                labelText: 'Title',
              ),
            ),
            const SizedBox(height: 10),
            ImageInput(onpickImage: (image){
              _pickedImage = image;
            },),
            const SizedBox(height: 10),
            LocationInput(onSelectLocation: (location){
              _pickedLocation = location;
            },),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _savePlace,
              icon: const Icon(Icons.add),
              label: const Text('Add Place'),
            )
          ],
        ),
      ),
    );
    }
}