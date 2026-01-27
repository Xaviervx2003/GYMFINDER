import 'package:flutter/material.dart';
import '../models/gym.dart';

class GymDetailScreen extends StatelessWidget {
  final Gym gym;

  const GymDetailScreen({super.key, required this.gym});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(gym.name, style: const TextStyle(color: Colors.white, fontSize: 16)),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // CORREÇÃO PRINCIPAL: Usar Image.network
                  Image.network(
                    gym.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, error, stack) => Container(color: Colors.grey[850]),
                  ),
                  // Gradiente para o texto ficar legível
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        // ignore: deprecated_member_use
                        colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "R\$ ${gym.dayPassPrice.toInt()}",
                        style: const TextStyle(
                            fontSize: 28, 
                            fontWeight: FontWeight.bold, 
                            color: Colors.deepPurpleAccent),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber),
                          Text(" ${gym.rating}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text("Diária Avulsa", style: TextStyle(color: Colors.grey[400])),
                  const SizedBox(height: 24),
                  
                  const Text("Endereço", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.deepPurpleAccent, size: 20),
                      const SizedBox(width: 8),
                      Expanded(child: Text(gym.address, style: const TextStyle(fontSize: 16))),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  const Text("Comodidades", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  _buildAmenity(Icons.ac_unit, "Ar Condicionado", gym.hasAirConditioning),
                  _buildAmenity(Icons.wifi, "Wi-Fi Grátis", true),
                  _buildAmenity(Icons.shower, "Vestiários", true),
                  _buildAmenity(Icons.water_drop, "Bebedouro", true),

                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Check-in realizado com sucesso! Bom treino! 💪")),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurpleAccent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      child: const Text("Fazer Check-in Agora", style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmenity(IconData icon, String label, bool isAvailable) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: isAvailable ? Colors.greenAccent : Colors.grey),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              color: isAvailable ? Colors.white : Colors.grey,
              decoration: isAvailable ? null : TextDecoration.lineThrough,
            ),
          ),
        ],
      ),
    );
  }
}