import 'package:flutter/material.dart';
import 'package:geo_app_fltr/screens/category_details_screen.dart';
import 'package:geo_app_fltr/screens/map_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, String>> categories = [
    {'icon': 'assets/images/atm.png', 'label': 'ATM'},
    {'icon': 'assets/images/bank.png', 'label': 'BANKS'},
    {'icon': 'assets/images/mosque.png', 'label': 'MOSQUE'},
    {'icon': 'assets/images/beach.png', 'label': 'BEACH'},
    {'icon': 'assets/images/cinema.png', 'label': 'CINEMA'},
    {'icon': 'assets/images/coffee.png', 'label': 'COFFEE'},
    {'icon': 'assets/images/education.png', 'label': 'EDUCATION'},
    {'icon': 'assets/images/hotel.png', 'label': 'HOTELS'},
    {'icon': 'assets/images/mall.png', 'label': 'MALL'},
    {'icon': 'assets/images/restaurant.png', 'label': 'RESTAURANT'},
    {'icon': 'assets/images/hospital.png', 'label': 'HOSPITAL'},
    {'icon': 'assets/images/garden.png', 'label': 'GARDEN'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade100,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 129, 231, 182),
        title: Text(
          'Tourism Place Finder',
          style: TextStyle(color: const Color.fromARGB(255, 110, 110, 110)),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MapScreen(category: "All Places"),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 129, 231, 182),
                foregroundColor: const Color.fromARGB(255, 110, 110, 110),
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              child: Text('Open Map'),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryDetailsScreen(
                            category: categories[index]['label']!),
                      ),
                    );
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        categories[index]['icon']!,
                        height: 40,
                      ),
                      SizedBox(height: 8),
                      Text(
                        categories[index]['label']!,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
