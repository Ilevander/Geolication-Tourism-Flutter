import 'package:flutter/material.dart';
import "package:google_maps_webservice2/places.dart";

class SearchBar extends StatefulWidget {
  final Function(String) onPlaceSelected;

  SearchBar({required this.onPlaceSelected});

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _searchController = TextEditingController();
  final String apiKey = 'AIzaSyCfWJjWL1dS0AtLvkYIdduhISpbRvbjRi4'; 
  List<Prediction> _predictions = [];

  Future<void> _searchPlaces(String query) async {
    if (query.isEmpty) {
      setState(() {
        _predictions = [];
      });
      return;
    }

    final places = GoogleMapsPlaces(apiKey: apiKey);
    final response = await places.autocomplete(
      query,
      region: 'ma', 
    );

    if (response.isOkay) {
      setState(() {
        _predictions = response.predictions;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Rechercher une localisation au Maroc...',
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          onChanged: (value) {
            _searchPlaces(value);
          },
        ),
        if (_predictions.isNotEmpty)
          ListView.builder(
            shrinkWrap: true,
            itemCount: _predictions.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(_predictions[index].description!),
                onTap: () {
                  widget.onPlaceSelected(_predictions[index].description!);
                  setState(() {
                    _predictions = [];
                    _searchController.clear();
                  });
                },
              );
            },
          ),
      ],
    );
  }
}