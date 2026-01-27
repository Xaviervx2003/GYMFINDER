import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/map_screen.dart';
import 'screens/gym_detail_screen.dart';
import 'models/gym.dart';

void main() {
  runApp(const GymFinderApp());
}

class GymFinderApp extends StatelessWidget {
  const GymFinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GymFinder',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        primaryColor: Colors.deepPurpleAccent,
        scaffoldBackgroundColor: const Color(0xFF0F0F0F),
        cardTheme: CardThemeData(
          color: const Color(0xFF1E1E1E),
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      // AQUI ESTÁ O SEGREDO: Definimos a rota inicial explicitamente
      initialRoute: '/',
      routes: {
        // A rota '/' é a principal. Ela DEVE chamar HomeScreen (que tem as abas)
        '/': (context) => const HomeScreen(),
        '/map': (context) => const MapScreen(),
      },
      // Configuração para passar argumentos para a tela de detalhes
      onGenerateRoute: (settings) {
        if (settings.name == '/details') {
          final gym = settings.arguments as Gym;
          return MaterialPageRoute(builder: (_) => GymDetailScreen(gym: gym));
        }
        return null;
      },
    );
  }
}