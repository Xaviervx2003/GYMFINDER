import 'package:flutter/material.dart';
import '../data/mock_data.dart'; // Importa a lista mockGyms
import '../widgets/gym_card.dart'; // Importa o visual do card

class GymListScreen extends StatelessWidget {
  const GymListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Academias Próximas'),
        backgroundColor: Colors.transparent, // Estilo moderno
        elevation: 0,
      ),
      backgroundColor: const Color(0xFF121212), // Fundo Dark
      // ListView.builder é OTIMIZADO: só renderiza o que está na tela
      body: ListView.builder(
        itemCount: mockGyms.length, // Quantas academias temos? 5.
        itemBuilder: (context, index) {
          final gym = mockGyms[index]; // Pega a academia da vez (0, 1, 2...)
          return GymCard(gym: gym); // Cria o card passando os dados dela
        },
      ),
    );
  }
}