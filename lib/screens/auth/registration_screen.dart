import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth_service.dart';

class RegistrationScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Inscription')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nom'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Mot de passe'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  await authService.signUpWithEmail(
                    _emailController.text,
                    _passwordController.text,
                    _nameController.text,
                  );
                  Navigator.pushReplacementNamed(context, '/map'); // Rediriger vers la carte après inscription
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
                Navigator.pushReplacementNamed(context, '/login'); // Retour à l'écran de connexion
              },
              child: Text('Déjà un compte ? Se connecter'),
            ),
          ],
        ),
      ),
    );
  }
}