enum PlaceType {
  atm,
  bank,
  mosque,
  beach,
  cinema,
  coffee,
  education,
  hotel,
  mall,
  restaurant,
  hospital,
  garden,
  pointOfInterest,
  church,
  movie_theater,
  cafe,
  school,
  shopping_mall,
  park,
  point_of_interest,
}

String getPlaceTypeString(PlaceType type) {
  switch (type) {
    case PlaceType.atm:
      return 'atm';
    case PlaceType.bank:
      return 'bank';
    case PlaceType.mosque:
      return 'church';
    case PlaceType.beach:
      return 'beach';
    case PlaceType.cinema:
      return 'movie_theater';
    case PlaceType.coffee:
      return 'cafe';
    case PlaceType.education:
      return 'school';
    case PlaceType.hotel:
      return 'hotel';
    case PlaceType.mall:
      return 'shopping_mall';
    case PlaceType.restaurant:
      return 'restaurant';
    case PlaceType.hospital:
      return 'hospital';
    case PlaceType.garden:
      return 'park';
    case PlaceType.pointOfInterest:
      return 'point_of_interest';
    case PlaceType.church:
      throw UnimplementedError();
    case PlaceType.movie_theater:
      throw UnimplementedError();
    case PlaceType.cafe:
      throw UnimplementedError();
    case PlaceType.school:
      throw UnimplementedError();
    case PlaceType.shopping_mall:
      throw UnimplementedError();
    case PlaceType.park:
      throw UnimplementedError();
    case PlaceType.point_of_interest:
      throw UnimplementedError();
  }
}
