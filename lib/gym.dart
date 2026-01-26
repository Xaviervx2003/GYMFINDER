import 'package:flutter/material.dart';
import '../models/gym.dart'; // Importante: Importando o modelo

class GymCard extends StatelessWidget {
  final Gym gym; // Agora o card pede uma "Academia" para ser construído

  const GymCard({super.key, required this.gym});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Ajustei o espaçamento
      height: 120,
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Miniatura (Placeholder)
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 90,
                    height: 90,
                    color: Colors.grey[800],
                    child: const Icon(Icons.fitness_center, color: Colors.white24),
                  ),
                ),
                // Se tiver ar-condicionado, mostra um ícone pequeno
                if (gym.hasAirConditioning)
                  Positioned(
                    bottom: 5,
                    right: 5,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.blueAccent,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.ac_unit, size: 10, color: Colors.white),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 15),
            // Informações Dinâmicas
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    gym.name, // Nome vindo do Mock Data
                    style: const TextStyle(
                      fontWeight: FontWeight.bold, 
                      fontSize: 16,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "${gym.distance} • ⭐ ${gym.rating}", // Distância e Nota
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Day Pass: R\$ ${gym.dayPassPrice.toStringAsFixed(2)}", // Preço Formatado
                    style: TextStyle(
                      color: Colors.deepPurpleAccent[100],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}