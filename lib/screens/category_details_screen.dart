import 'package:flutter/material.dart';
import 'package:geo_app_fltr/screens/place_details_screen.dart';
import 'package:google_maps_webservice2/places.dart';
import 'package:geolocator/geolocator.dart';

class CategoryDetailsScreen extends StatefulWidget {
  final String category;

  const CategoryDetailsScreen({Key? key, required this.category}) : super(key: key);

  @override
  _CategoryDetailsScreenState createState() => _CategoryDetailsScreenState();
}

class _CategoryDetailsScreenState extends State<CategoryDetailsScreen> {
  final String _apiKey = 'AIzaSyCfWJjWL1dS0AtLvkYIdduhISpbRvbjRi4'; 
  final GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: 'AIzaSyCfWJjWL1dS0AtLvkYIdduhISpbRvbjRi4');

  List<PlacesSearchResult> _placesList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) throw 'Les services de localisation sont désactivés.';

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

      _fetchPlaces(position.latitude, position.longitude);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur : $e')),
      );
    }
  }

  Future<void> _fetchPlaces(double lat, double lng) async {
    try {
      PlacesSearchResponse response = await _places.searchNearbyWithRadius(
        Location(lat: lat, lng: lng),
        5000, // Rayon de recherche de 5 km
        type: _mapCategoryToPlaceType(widget.category),
      );

      if (response.isOkay) {
        setState(() {
          _placesList = response.results;
          _isLoading = false;
        });
      } else {
        throw 'Erreur API Google Places: ${response.errorMessage}';
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la récupération des lieux : $e')),
      );
    }
  }

  String _mapCategoryToPlaceType(String category) {
    switch (category.toLowerCase()) {
      case 'atm': return 'atm';
      case 'bank': return 'bank';
      case 'mosque': return 'mosque';
      case 'beach': return 'beach';
      case 'cinema': return 'movie_theater';
      case 'coffee': return 'cafe';
      case 'education': return 'school';
      case 'hotel': return 'lodging';
      case 'mall': return 'shopping_mall';
      case 'restaurant': return 'restaurant';
      case 'hospital': return 'hospital';
      case 'garden': return 'park';
      default: return 'point_of_interest'; // Par défaut
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade100,
      appBar: AppBar(
        title: Text('${widget.category} Places'),
        backgroundColor: const Color.fromARGB(255, 129, 231, 182),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _placesList.isEmpty
              ? const Center(child: Text('Aucun lieu trouvé'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _placesList.length,
                  itemBuilder: (context, index) {
                    final place = _placesList[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.place, color: Colors.teal),
                        title: Text(place.name),
                        subtitle: Text(place.vicinity ?? 'Adresse non disponible'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlaceDetailsScreen(
                                placeName: place.name,
                                address: place.vicinity ?? 'Adresse non disponible',
                                description: 'Une belle description de cet endroit.',
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
