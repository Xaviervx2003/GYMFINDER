import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Importante para abrir o mapa
import '../models/gym.dart';

class GymCard extends StatelessWidget {
  final Gym gym;

  const GymCard({super.key, required this.gym});

  // Função para abrir o GPS do celular
  Future<void> _openMap() async {
    final googleMapsUrl = Uri.parse("google.navigation:q=${gym.latitude},${gym.longitude}&mode=d");
    try {
      await launchUrl(googleMapsUrl);
    } catch (e) {
      debugPrint("Erro ao abrir mapa: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
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
                // === A IMAGEM QUE CARREGA DA INTERNET ===
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    gym.imageUrl, 
                    width: 90, 
                    height: 90, 
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, _, __) => Container(
                      width: 90, 
                      height: 90, 
                      color: Colors.grey[800],
                      child: const Icon(Icons.fitness_center, color: Colors.white24),
                    ),
                  ),
                ),
                
                const SizedBox(width: 16),
                
                // Informações
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(gym.name, 
                        maxLines: 1, 
                        overflow: TextOverflow.ellipsis, 
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)
                      ),
                      const SizedBox(height: 4),
                      Text(gym.address, 
                        maxLines: 1, 
                        overflow: TextOverflow.ellipsis, 
                        style: TextStyle(color: Colors.grey[400], fontSize: 12)
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text("R\$${gym.dayPassPrice.toInt()}", 
                              style: const TextStyle(color: Colors.deepPurpleAccent, fontWeight: FontWeight.bold)),
                          const SizedBox(width: 8),
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          Text(" ${gym.rating}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // === O BOTÃO DE ROTA ===
                IconButton.filled(
                  onPressed: _openMap,
                  style: IconButton.styleFrom(backgroundColor: Colors.deepPurpleAccent),
                  icon: const Icon(Icons.directions, color: Colors.white),
                  tooltip: "Ir agora",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}