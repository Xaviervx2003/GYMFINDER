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
              background: Image.network(
                gym.imageUrl, // Usa Internet
                fit: BoxFit.cover,
                errorBuilder: (ctx, error, stack) => Container(color: Colors.grey[900]),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("R\$ ${gym.dayPassPrice.toInt()}", style: const TextStyle(fontSize: 28, color: Colors.deepPurpleAccent, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  const Text("Endereço", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(gym.address, style: const TextStyle(color: Colors.white70)),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurpleAccent),
                      child: const Text("Check-in", style: TextStyle(color: Colors.white)),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}