import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import '../models/user_model.dart' as app_model;

class AuthService with ChangeNotifier {
  app_model.User? _user;

  app_model.User? get user => _user;

  Future<void> signUpWithEmail(
      String email, String password, String name) async {
    try {
      firebase_auth.UserCredential userCredential = await firebase_auth
          .FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      if (userCredential.user != null) {
        await userCredential.user!.updateDisplayName(name);

        _user = app_model.User(
          id: userCredential.user!.uid,
          email: userCredential.user!.email!,
          name: name,
          photoUrl: userCredential.user!.photoURL ?? '',
        );

        notifyListeners();
      } else {
        throw Exception("Aucun utilisateur trouvé après l'inscription.");
      }
    } catch (e) {
      print("Erreur d'inscription : $e");
      rethrow;
    }
  }

  Future<void> signInWithEmail(String email, String password) async {
    print("Tentative de connexion avec email : $email");
    try {
      firebase_auth.UserCredential userCredential = await firebase_auth
          .FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      print(
          "Connexion réussie pour l'utilisateur : ${userCredential.user!.uid}");
      _user = app_model.User(
        id: userCredential.user!.uid,
        email: userCredential.user!.email!,
        name: userCredential.user!.displayName ?? 'Utilisateur',
        photoUrl: userCredential.user!.photoURL ?? '',
      );

      notifyListeners();
    } on firebase_auth.FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'user-not-found') {
        errorMessage = "Aucun utilisateur trouvé avec cet email.";
      } else if (e.code == 'wrong-password') {
        errorMessage = "Mot de passe incorrect.";
      } else {
        errorMessage = "Erreur de connexion : ${e.message}";
      }
      print(errorMessage);
      rethrow;
    } catch (e) {
      print("Erreur inattendue : $e");
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await firebase_auth.FirebaseAuth.instance.signOut();
      _user = null;
      notifyListeners();
    } catch (e) {
      print("Erreur lors de la déconnexion : $e");
      rethrow;
    }
  }

  Future<void> checkAuthState() async {
    firebase_auth.User? firebaseUser =
        firebase_auth.FirebaseAuth.instance.currentUser;

    if (firebaseUser != null && firebaseUser.email != null) {
      _user = app_model.User(
        id: firebaseUser.uid,
        email: firebaseUser.email!,
        name: firebaseUser.displayName ?? 'Utilisateur',
        photoUrl: firebaseUser.photoURL ?? '',
      );
      notifyListeners();
    }
  }
}
