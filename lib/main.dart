import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geo_app_fltr/screens/favorites_screen.dart';
import 'package:geo_app_fltr/screens/home_screen.dart';
import 'package:geo_app_fltr/screens/map_screen.dart';
import 'package:provider/provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/registration_screen.dart';
import 'screens/main_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/welcome_screen.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthService()),
        ],
        child: MyApp(),
      ),
    );
  } catch (e) {
    print("Erreur d'initialisation de Firebase : $e");
  }
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tourisme Personnalisé',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Consumer<AuthService>(
        builder: (context, authService, child) {
          authService.checkAuthState();

          if (authService.user != null) {
            return MainScreen();
          }
          return WelcomeScreen();
        },
      ),
      routes: {
        '/login': (context) => LoginScreen(),
        '/main': (context) => MainScreen(),
        '/map': (context) => MapScreen(),
        '/register': (context) => RegistrationScreen(),
        '/profile': (context) => ProfileScreen(),
        '/favorites': (context) => FavoritesScreen(),
        '/welcome': (context) => WelcomeScreen(),
        '/home': (context) => HomeScreen(),
      },
    );
  }
}
