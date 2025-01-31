import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final user = authService.user;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              // Naviguer vers l'écran de modification du profil
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Photo de profil
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(
                  user?.photoUrl ?? 'https://via.placeholder.com/150',
                ),
              ),
              SizedBox(height: 20),

              // Nom de l'utilisateur
              Text(
                user?.name ?? 'Nom de l\'utilisateur',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),

              // Email de l'utilisateur
              Text(
                user?.email ?? 'email@example.com',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 20),

              // Section des informations supplémentaires
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.location_on, color: Colors.blue),
                      title: Text('Adresse'),
                      subtitle: Text('Paris, France'), // Exemple d'adresse
                      trailing: Icon(Icons.edit),
                      onTap: () {
                        // Modifier l'adresse
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.phone, color: Colors.green),
                      title: Text('Téléphone'),
                      subtitle:
                          Text('+33 6 12 34 56 78'), // Exemple de téléphone
                      trailing: Icon(Icons.edit),
                      onTap: () {
                        // Modifier le téléphone
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Bouton pour se déconnecter
              ElevatedButton(
                onPressed: () async {
                  await authService.signOut();
                  // Rediriger vers l'écran de connexion
                  Navigator.pushReplacementNamed(context, '/welcome');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Couleur du bouton
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: Text(
                  'Se déconnecter',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
