import 'package:favorite_places/models/place.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  final PlaceLocation location;
  final bool isSelecting;
  const MapScreen({super.key,
  required this.location,
  this.isSelecting = false});
  
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _pickedLocation;
  GoogleMapController? mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isSelecting ? 'Select Location' : 'View Location'),
        actions: [
          if (widget.isSelecting)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {
                // return the selected location
                Navigator.of(context).pop(_pickedLocation);
              },
            ),
        ],
      ),
      body: GoogleMap(
        onTap: !widget.isSelecting ? null: (location){
          setState(() {
            _pickedLocation = location;
          });
        },
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.location.latitude,widget.location.longitude), // Set initial map location
          zoom: 16.0, // Set initial zoom level
        ),
        markers: (_pickedLocation == null && widget.isSelecting) ? {} :{ // Add a marker if a location is selected
          Marker(
            markerId: const MarkerId('m1'),
            position: _pickedLocation ?? LatLng(widget.location.latitude,widget.location.longitude)
          ),
        }
      ),
    );
  }
}