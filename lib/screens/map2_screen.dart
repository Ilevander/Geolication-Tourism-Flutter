// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_maps_webservice2/places.dart';
// import 'package:flutter_google_places/flutter_google_places.dart';

// const kGoogleApiKey = "AIzaSyCfWJjWL1dS0AtLvkYIdduhISpbRvbjRi4";
// final GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

// class MapScreen extends StatefulWidget {
//   @override
//   _MapScreenState createState() => _MapScreenState();
// }

// class _MapScreenState extends State<MapScreen> {
//   static final CameraPosition _kInitialPosition = CameraPosition(
//     target: LatLng(37.42796133580664, -122.085749655962),
//     zoom: 14.4746,
//   );

//   late GoogleMapController _controller;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: GoogleMap(
//         mapType: MapType.normal,
//         initialCameraPosition: _kInitialPosition,
//         onMapCreated: (GoogleMapController controller) {
//           _controller = controller;
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _handlePressButton,
//         tooltip: 'Search',
//         child: Icon(Icons.search),
//       ),
//     );
//   }

//   Future<void> _handlePressButton() async {
//     Prediction? p = await PlacesAutocomplete.show(
//       context: context,
//       apiKey: kGoogleApiKey,
//       onError: (response) => print(response.errorMessage),
//       mode: Mode.fullscreen,
//       language: "en",
//       components: [Component(Component.country, "us")],
//     );

//     if (p != null) {
//       displayPrediction(p);
//     }
//   }

//   Future<void> displayPrediction(Prediction p) async {
//     PlacesDetailsResponse detail =
//         await _places.getDetailsByPlaceId(p.placeId!);
//     double lat = detail.result.geometry!.location.lat;
//     double lng = detail.result.geometry!.location.lng;

//     _controller.animateCamera(CameraUpdate.newCameraPosition(
//       CameraPosition(target: LatLng(lat, lng), zoom: 14.0),
//     ));
//   }
// }
