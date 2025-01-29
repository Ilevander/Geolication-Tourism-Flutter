import 'package:flutter/material.dart';

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

  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Tourism Place Finder',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                Text(
                  'Search areas in the simplest way',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search here...',
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: Icon(Icons.tune),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ],
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
                return Column(
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
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite, color: Colors.blue),
            label: 'Favorite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.teal),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings, color: Colors.blue),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
