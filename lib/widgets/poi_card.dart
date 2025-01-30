import 'package:flutter/material.dart';
import '../models/poi_model.dart';

class POICard extends StatelessWidget {
  final POI poi;

  POICard({required this.poi});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(poi.name),
        subtitle: Text(poi.description),
        trailing: Text('Note: ${poi.rating}'),
      ),
    );
  }
}