import 'package:flutter/material.dart';
import '../models/gym.dart';

class GymCard extends StatelessWidget {
  final Gym gym;

  const GymCard({super.key, required this.gym});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          // ignore: deprecated_member_use
          colors: [Colors.deepPurple.withOpacity(0.1), Colors.black12],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Card(
        elevation: 0,
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => Navigator.pushNamed(context, '/details', arguments: gym),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Imagem com bordas arredondadas
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    gym.imageUrl,
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),
                // Informações
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        gym.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        gym.address,
                        style: TextStyle(color: Colors.grey[400], fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            gym.rating.toString(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 12),
                          Icon(Icons.ac_unit, 
                            color: gym.hasAirConditioning ? Colors.cyan : Colors.grey, 
                            size: 16
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Preço em destaque
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Day Pass", style: TextStyle(fontSize: 10, color: Colors.grey)),
                    Text(
                      "R\$${gym.dayPassPrice.toInt()}",
                      style: const TextStyle(
                        color: Colors.deepPurpleAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}