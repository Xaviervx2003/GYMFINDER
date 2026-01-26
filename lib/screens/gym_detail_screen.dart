import 'package:flutter/material.dart';
import '../models/gym.dart';
import 'checkout_screen.dart';
import '../widgets/activity_chart.dart'; 

class GymDetailScreen extends StatelessWidget {
  final Gym gym;

  const GymDetailScreen({super.key, required this.gym});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: CustomScrollView(
        slivers: [
          // 1. Cabeçalho com Foto
          SliverAppBar(
            expandedHeight: 250.0,
            floating: false,
            pinned: true,
            backgroundColor: const Color(0xFF121212),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                gym.name,
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
              background: Container(
                color: Colors.grey[800],
                child: const Center(
                  child: Icon(Icons.fitness_center, size: 80, color: Colors.white24),
                ),
              ),
            ),
          ),

          // 2. Conteúdo da Ficha
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Preço e Avaliação
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "R\$ ${gym.dayPassPrice.toStringAsFixed(2)} / dia",
                          style: const TextStyle(
                            color: Colors.greenAccent,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "⭐ ${gym.rating}",
                            style: const TextStyle(
                                color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),

                    // Gráfico de Lotação
                    const Text("Horários de Pico",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    
                    const SizedBox(height: 20),
                    
                    // Widget do Gráfico
                    const ActivityChart(),

                    const SizedBox(height: 30),

                    // Diferenciais
                    const Text("Diferenciais",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        _buildAmenity(Icons.ac_unit, "Ar Cond.", gym.hasAirConditioning),
                        const SizedBox(width: 15),
                        _buildAmenity(Icons.wifi, "Wi-Fi Grátis", true),
                        const SizedBox(width: 15),
                        _buildAmenity(Icons.shower, "Vestiário", true),
                      ],
                    ),

                    const SizedBox(height: 40),

                    // Botão de Ação
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurpleAccent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CheckoutScreen(gym: gym),
                            ),
                          );
                        },
                        child: const Text("Comprar Day Pass",
                            style: TextStyle(color: Colors.white, fontSize: 18)),
                      ),
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildAmenity(IconData icon, String label, bool isActive) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isActive ? Colors.grey[800] : Colors.grey[900],
            borderRadius: BorderRadius.circular(12),
            border: isActive ? Border.all(color: Colors.deepPurpleAccent) : null,
          ),
          child: Icon(icon, color: isActive ? Colors.white : Colors.grey),
        ),
        const SizedBox(height: 5),
        Text(label,
            style: TextStyle(
                color: isActive ? Colors.white : Colors.grey, fontSize: 10)),
      ],
    );
  }
}