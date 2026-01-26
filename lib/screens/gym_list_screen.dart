import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../widgets/gym_card.dart';
import 'gym_detail_screen.dart';
import 'map_screen.dart'; // Importe a tela do mapa

class GymListScreen extends StatelessWidget {
  const GymListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Academias Próximas'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      backgroundColor: const Color(0xFF121212),
      
      // AQUI ESTÁ O BOTÃO QUE LEVA PRO MAPA
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MapScreen()),
          );
        },
        label: const Text("Ver Mapa"),
        icon: const Icon(Icons.map),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      
      body: ListView.builder(
        itemCount: mockGyms.length,
        itemBuilder: (context, index) {
          final gym = mockGyms[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GymDetailScreen(gym: gym),
                ),
              );
            },
            child: GymCard(gym: gym),
          );
        },
      ),
    );
  }
}