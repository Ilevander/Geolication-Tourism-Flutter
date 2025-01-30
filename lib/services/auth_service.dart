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

      await userCredential.user!.updateDisplayName(name);

      _user = app_model.User(
        id: userCredential.user!.uid,
        email: userCredential.user!.email!,
        name: name,
        photoUrl: userCredential.user!.photoURL ?? '',
      );

      notifyListeners();
    } catch (e) {
      print("Erreur d'inscription : $e");
      rethrow;
    }
  }

  Future<void> signInWithEmail(String email, String password) async {
    try {
      firebase_auth.UserCredential userCredential = await firebase_auth
          .FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      _user = app_model.User(
        id: userCredential.user!.uid,
        email: userCredential.user!.email!,
        name: userCredential.user!.displayName ?? 'Utilisateur',
        photoUrl: userCredential.user!.photoURL ?? '',
      );

      notifyListeners();
    } catch (e) {
      print("Erreur de connexion : $e");
      rethrow;
    }
  }

  Future<void> signOut() async {
    await firebase_auth.FirebaseAuth.instance
        .signOut(); 
    _user = null;
    notifyListeners();
  }

  Future<void> checkAuthState() async {
  firebase_auth.User? firebaseUser = firebase_auth.FirebaseAuth.instance.currentUser;

  if (firebaseUser != null) {
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
