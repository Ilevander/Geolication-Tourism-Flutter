import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class LocationAutoComplete extends StatefulWidget {
  const LocationAutoComplete({super.key});

  @override
  _LocationAutoCompleteState createState() => _LocationAutoCompleteState();
}

class _LocationAutoCompleteState extends State<LocationAutoComplete> {
  final searchController = TextEditingController();
  final String token = '12345678910';
  var uuid = Uuid();
  List<dynamic> listOfLocation = [];
  @override
  void initState() {
    searchController.addListener(() {
      _onChange();
    });
    super.initState();
  }

  _onChange() {
    placeSuggestion(searchController.text);
  }

  void placeSuggestion(String input) async {
    const String apiKey = "AIzaSyCfWJjWL1dS0AtLvkYIdduhISpbRvbjRi4";
    try {
      String baseURL =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json";
      String request = '$baseURL?inpute=$input&key=$apiKey&sessiontoken=$token';
      var response = await http.get(Uri.parse(Uri.parse(request) as String));
      var data = json.decode(response.body);
      if (kDebugMode) {
        print(data);
      }
      if (response.statusCode == 200) {
        setState(() {
          listOfLocation = json.decode(response.body)['predictions'];
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(
          'Location Auto Complete',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(hintText: 'Enter a location'),
              onChanged: (value) {
                setState(() {});
              },
            ),
            Visibility(
              visible: searchController.text.isEmpty ? false : true,
              child: Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                          onTap: () {},
                          child: ListTile(
                            title: Text(
                              listOfLocation[index]['description'],
                            ),
                          ));
                    }),
              ),
            ),
            Visibility(
                visible: searchController.text.isEmpty ? true : false,
                child: Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.my_location,
                            color: Colors.green,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "My Location",
                            style: TextStyle(
                                color: Colors.teal,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    )))
          ],
        ),
      ),
    );
  }
}
