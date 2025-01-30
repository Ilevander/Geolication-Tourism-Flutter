import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';

class HomeScreen extends StatelessWidget {
  // Liste de points d'intérêt (POI) populaires
  final List<Map<String, String>> popularPlaces = [
    {
      'name': 'Tour Eiffel',
      'location': 'Paris, France',
      'image': 'https://via.placeholder.com/150',
    },
    {
      'name': 'Machu Picchu',
      'location': 'Cusco, Pérou',
      'image': 'https://via.placeholder.com/150',
    },
    {
      'name': 'Grand Canyon',
      'location': 'Arizona, USA',
      'image': 'https://via.placeholder.com/150',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Tourisme Places'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Ajouter une fonction de recherche
            },
          ),
          // Bouton pour accéder au profil ou se connecter
          IconButton(
            icon: Icon(authService.user != null ? Icons.person : Icons.login),
            onPressed: () {
              if (authService.user != null) {
                // Naviguer vers le profil utilisateur
                // Exemple : Navigator.pushNamed(context, '/profile');
              } else {
                // Naviguer vers l'écran de connexion
                Navigator.pushNamed(context, '/login');
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Titre et description de l'application
              Text(
                'Bienvenue sur Tourisme Places',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Découvrez des lieux incroyables et planifiez vos voyages en fonction de vos préférences.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 20),

              // Section des points d'intérêt populaires
              Text(
                'Lieux populaires',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Container(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: popularPlaces.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        // Naviguer vers la page détaillée du lieu
                      },
                      child: Card(
                        margin: EdgeInsets.only(right: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.network(
                              popularPlaces[index]['image']!,
                              width: 150,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    popularPlaces[index]['name']!,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    popularPlaces[index]['location']!,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),

              // Section des recommandations personnalisées
              Text(
                'Recommandations pour vous',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: popularPlaces.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(popularPlaces[index]['image']!),
                    ),
                    title: Text(popularPlaces[index]['name']!),
                    subtitle: Text(popularPlaces[index]['location']!),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // Naviguer vers la page détaillée du lieu
                    },
                  );
                },
              ),
              SizedBox(height: 20),

              // Bouton pour explorer plus de lieux
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Naviguer vers une page de découverte
                  },
                  child: Text('Explorer plus de lieux'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}