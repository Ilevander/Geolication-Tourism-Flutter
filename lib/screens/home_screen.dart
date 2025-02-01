import 'package:flutter/material.dart';
import 'package:google_maps_webservice2/places.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class HomeScreen extends StatelessWidget {
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
              showSearch(
                context: context,
                delegate: CustomSearchDelegate(), // Utiliser un delegate de recherche
              );
            },
          ),
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
                    Navigator.pushNamed(context, '/map');
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

class CustomSearchDelegate extends SearchDelegate<String> {
  final String apiKey = 'AIzaSyCfWJjWL1dS0AtLvkYIdduhISpbRvbjRi4'; // Remplacez par votre clé API

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null!);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Text('Vous avez sélectionné : $query'),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final places = GoogleMapsPlaces(apiKey: apiKey);

    return FutureBuilder<List<Prediction>>(
      future: places.autocomplete(query, region: 'ma').then((response) {
        if (response.isOkay) {
          return response.predictions;
        } else {
          return [];
        }
      }),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erreur : ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Aucun résultat trouvé'));
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final prediction = snapshot.data![index];
              return ListTile(
                title: Text(prediction.description!),
                onTap: () {
                  close(context, prediction.description!);
                },
              );
            },
          );
        }
      },
    );
  }
}