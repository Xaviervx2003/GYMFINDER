import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; 
import '../models/gym.dart';

class GymCard extends StatelessWidget {
  final Gym gym;

  const GymCard({super.key, required this.gym});

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
                // IMAGEM
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
                
                // INFORMAÇÕES
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nome
                      Text(gym.name, 
                        maxLines: 1, 
                        overflow: TextOverflow.ellipsis, 
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)
                      ),
                      
                      const SizedBox(height: 4),
                      
                      // Endereço
                      Text(gym.address, 
                        maxLines: 1, 
                        overflow: TextOverflow.ellipsis, 
                        style: TextStyle(color: Colors.grey[400], fontSize: 12)
                      ),
                      
                      const SizedBox(height: 8),

                      // === LINHA DE DETALHES (PREÇO + NOTA + DISTÂNCIA) ===
                      Row(
                        children: [
                          // Preço
                          Text("R\$${gym.dayPassPrice.toInt()}", 
                              style: const TextStyle(color: Colors.deepPurpleAccent, fontWeight: FontWeight.bold)),
                          
                          const SizedBox(width: 10),
                          
                          // Nota
                          const Icon(Icons.star, color: Colors.amber, size: 14),
                          Text(" ${gym.rating}", style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),

                          const SizedBox(width: 10),

                          // === AQUI ESTÁ A DISTÂNCIA QUE FALTAVA! ===
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.white10,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.location_on, color: Colors.greenAccent, size: 10),
                                const SizedBox(width: 2),
                                Text(
                                  gym.distance, // Ex: "800 m" ou "1.2 km"
                                  style: const TextStyle(color: Colors.white70, fontSize: 10),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // BOTÃO DE ROTA
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