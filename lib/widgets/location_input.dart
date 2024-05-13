import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/screens/map.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationInput extends StatefulWidget {
  const LocationInput({super.key, required this.onSelectLocation});
  final void Function(PlaceLocation) onSelectLocation;
  @override
  State<LocationInput> createState() => _LocationInputState();
}
class _LocationInputState extends State<LocationInput> {
  PlaceLocation? _pickedLocation;
  var _isLocationLoading = false;
  String get locationImage{
    if(_pickedLocation == null){
      return '';
    }
    return 'https://maps.googleapis.com/maps/api/staticmap?center=${_pickedLocation!.latitude},${_pickedLocation!.longitude}&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C${_pickedLocation!.latitude},${_pickedLocation!.longitude}&key=b0cb08b632014eefb9868ea0a2ac8af6';
  }
  Future<void> _savePlace(double latitude, double longitude) async {
    final url = Uri.parse('https://api.opencagedata.com/geocode/v1/json?q=$latitude+$longitude&key=b0cb08b632014eefb9868ea0a2ac8af6');
final response = await http.get(url);
final resData = json.decode(response.body);
final formattedAddress = resData['results'][0]['formatted'];
    setState(() {
      _pickedLocation = PlaceLocation(latitude: latitude, 
      longitude: longitude, 
      address: formattedAddress);
      _isLocationLoading = false;
    });
    widget.onSelectLocation(_pickedLocation!);
  }
  void _getCurrentLocation() async {
    Location location = Location();

bool serviceEnabled;
PermissionStatus permissionGranted;
LocationData locationData;

serviceEnabled = await location.serviceEnabled();
if (!serviceEnabled) {
  serviceEnabled = await location.requestService();
  if (!serviceEnabled) {
    return;
  }
}

permissionGranted = await location.hasPermission();
if (permissionGranted == PermissionStatus.denied) {
  permissionGranted = await location.requestPermission();
  if (permissionGranted != PermissionStatus.granted) {
    return;
  }
}
setState(() {
      _isLocationLoading = true;
    });

locationData = await location.getLocation();
if (locationData.latitude == null || locationData.longitude == null) {
  return;
}
_savePlace(locationData.latitude!, locationData.longitude!);
  }
  void _selectOnMap() async {
      final pickedLocation =await Navigator.of(context).push<LatLng>(MaterialPageRoute(
        fullscreenDialog: true,
        builder: (ctx) => MapScreen(location:PlaceLocation(latitude: 37.422, longitude: -122.084, address: 'Googleplex')),
      ));
      if(pickedLocation == null){
        return;
      }
      _savePlace(pickedLocation.latitude, pickedLocation.longitude);
    }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Theme.of(context).colorScheme.primary.withOpacity(0.2)),
          ),
          child: _isLocationLoading
              ? const CircularProgressIndicator()
              : _pickedLocation == null
                  ? const Text('No Location Chosen')
                  : Image.network(
                      locationImage,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: _getCurrentLocation,
              icon: const Icon(Icons.location_on),
              label: const Text('Current Location'),
            ),
            TextButton.icon(
              onPressed: _selectOnMap,
              icon: const Icon(Icons.map),
              label: const Text('Select on Map'),
            ),
          ],
        ),
      ],
    );
  }
}