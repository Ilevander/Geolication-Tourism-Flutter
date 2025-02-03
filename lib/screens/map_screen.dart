import 'package:flutter/material.dart';
import 'package:geo_app_fltr/models/place_type.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice2/places.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';

class MapScreen extends StatefulWidget {
  final String category;

  MapScreen({required this.category});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  LatLng? _currentLocation;
  final String _apiKey = 'AIzaSyCfWJjWL1dS0AtLvkYIdduhISpbRvbjRi4';
  String _mapStyle = '';
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _loadMapStyle();
    _getCurrentLocation().then((_) {
      if (widget.category.isNotEmpty && _currentLocation != null) {
        _searchPlacesByCategory(widget.category);
      }
    });
  }

  Future<void> _loadMapStyle() async {
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

  Future<void> _searchPlacesByCategory(String category) async {
    if (_currentLocation == null) return;

    final places = GoogleMapsPlaces(apiKey: _apiKey);
    PlaceType placeType;

    switch (category.toLowerCase()) {
      case 'atm':
      case 'bank':
        placeType = PlaceType.bank;
        break;
      case 'mosque':
        placeType = PlaceType.church;  
        break;
      case 'beach':
        placeType = PlaceType.beach;
        break;
      case 'cinema':
        placeType = PlaceType.movie_theater;
        break;
      case 'coffee':
        placeType = PlaceType.cafe;
        break;
      case 'education':
        placeType = PlaceType.school;
        break;
      case 'hotel':
        placeType = PlaceType.hotel;
        break;
      case 'mall':
        placeType = PlaceType.shopping_mall;
        break;
      case 'restaurant':
        placeType = PlaceType.restaurant;
        break;
      case 'hospital':
        placeType = PlaceType.hospital;
        break;
      case 'garden':
        placeType = PlaceType.park;
        break;
      default:
        placeType = PlaceType.point_of_interest; 
    }

    final response = await places.searchNearbyWithRadius(
      Location(lat: _currentLocation!.latitude, lng: _currentLocation!.longitude),
      5000,
      type: placeType.toString().split('.').last,
    );

    if (response.isOkay) {
      setState(() {
        _markers.clear();
        for (var place in response.results) {
          _markers.add(
            Marker(
              markerId: MarkerId(place.placeId!),
              position: LatLng(
                place.geometry!.location.lat,
                place.geometry!.location.lng,
              ),
              infoWindow: InfoWindow(
                title: place.name,
                snippet: place.vicinity,
              ),
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(
          'Résultat de Map',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
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
                      controller.setMapStyle(_mapStyle);
                    },
                    markers: _markers,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                  ),
          ),
        ],
      ),
    );
  }
}
