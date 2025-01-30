import 'package:flutter/material.dart';

import '../models/place_model.dart';

class FavoritesService with ChangeNotifier {
  final List<Place> _favorites = [];

  List<Place> get favorites => _favorites;

  void addToFavorites(Place place) {
    if (!_favorites.contains(place)) {
      _favorites.add(place);
      notifyListeners();
    }
  }

  void removeFromFavorites(Place place) {
    _favorites.remove(place);
    notifyListeners();
  }

  bool isFavorite(Place place) {
    return _favorites.contains(place);
  }
}