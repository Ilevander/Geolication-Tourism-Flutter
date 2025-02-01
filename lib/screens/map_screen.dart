import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice2/places.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  LatLng? _currentLocation;
  final TextEditingController _searchController = TextEditingController();
  List<Prediction> _predictions = [];
  final String _apiKey =
      'VOTRE_CLE_API_GOOGLE_PLACES'; // Remplacez par votre clé API
  String _mapStyle = '';

  @override
  void initState() {
    super.initState();
    _loadMapStyle();
    _getCurrentLocation();
  }

  Future<void> _loadMapStyle() async {
    // Charger le style JSON depuis les assets
    _mapStyle = await rootBundle.loadString('assets/map_style.json');
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        bool enabled = await Geolocator.openLocationSettings();
        if (!enabled) {
          throw 'Les services de localisation sont désactivés.';
        }
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw 'Les permissions de localisation sont refusées.';
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw 'Les permissions de localisation sont refusées de manière permanente.';
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
      });

      if (_mapController != null && _currentLocation != null) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(_currentLocation!, 14),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur : $e')),
      );
    }
  }

  Future<void> _searchPlaces(String query) async {
    if (query.isEmpty) {
      setState(() {
        _predictions = [];
      });
      return;
    }

    final places = GoogleMapsPlaces(apiKey: _apiKey);
    final response = await places.autocomplete(query);

    if (response.isOkay) {
      setState(() {
        _predictions = response.predictions;
      });
    }
  }

  Future<void> _onPlaceSelected(Prediction prediction) async {
    final places = GoogleMapsPlaces(apiKey: _apiKey);
    final details = await places.getDetailsByPlaceId(prediction.placeId!);

    if (details.isOkay) {
      final location = details.result.geometry!.location;
      setState(() {
        _currentLocation = LatLng(location.lat, location.lng);
      });

      if (_mapController != null) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(_currentLocation!, 14),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carte avec recherche'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Rechercher un lieu...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: (value) {
                _searchPlaces(value);
              },
            ),
          ),
          if (_predictions.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: _predictions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_predictions[index].description!),
                    onTap: () {
                      _onPlaceSelected(_predictions[index]);
                      setState(() {
                        _predictions = [];
                        _searchController.clear();
                      });
                    },
                  );
                },
              ),
            ),
          Expanded(
            child: _currentLocation == null
                ? Center(child: CircularProgressIndicator())
                : GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: _currentLocation!,
                      zoom: 14,
                    ),
                    onMapCreated: (controller) {
                      _mapController = controller;
                      // Appliquer le style personnalisé
                      controller.setMapStyle(_mapStyle);
                    },
                    markers: {
                      Marker(
                        markerId: MarkerId("currentLocation"),
                        position: _currentLocation!,
                        infoWindow:
                            InfoWindow(title: "Votre position actuelle"),
                      ),
                    },
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                  ),
          ),
        ],
      ),
    );
  }
}
