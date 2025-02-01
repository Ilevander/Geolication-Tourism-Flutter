import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';

class RegistrationScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _photoUrlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Inscription')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Champ pour le nom
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nom'),
            ),
            // Champ pour l'email
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            // Champ pour le mot de passe
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Mot de passe'),
              obscureText: true,
            ),
            // Champ pour le numéro de téléphone
            TextField(
              controller: _phoneNumberController,
              decoration: InputDecoration(labelText: 'Numéro de téléphone'),
            ),
            // Champ pour l'adresse
            TextField(
              controller: _addressController,
              decoration: InputDecoration(labelText: 'Adresse'),
            ),
            // Champ pour l'URL de la photo
            TextField(
              controller: _photoUrlController,
              decoration: InputDecoration(labelText: 'URL de la photo'),
            ),
            SizedBox(height: 20),
            // Bouton d'inscription
            ElevatedButton(
              onPressed: () async {
                try {
                  await authService.signUpWithEmail(
                    _emailController.text,
                    _passwordController.text,
                    _nameController.text,
                    _phoneNumberController.text,
                    _addressController.text,
                    _photoUrlController.text,
                  );
                  Navigator.pushReplacementNamed(context, '/home'); 
                } catch (e) {
                  print("Erreur d'inscription : $e");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erreur d\'inscription : $e')),
                  );
                }
              },
              child: Text('S\'inscrire'),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/login'); 
              },
              child: Text('Déjà un compte ? Se connecter'),
            ),
          ],
        ),
      ),
    );
  }
}