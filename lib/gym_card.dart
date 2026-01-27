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
        // Fundo com gradiente sutil
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
          // Ao clicar, vai para os detalhes
          onTap: () => Navigator.pushNamed(context, '/details', arguments: gym),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // --- 1. A IMAGEM (Correção do erro vermelho) ---
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    // Link direto da internet para não dar erro de arquivo não encontrado
                    "https://images.unsplash.com/photo-1534438327276-14e5300c3a48?q=80&w=1470&auto=format&fit=crop",
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                    // Se falhar (sem internet), mostra um ícone cinza
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 90,
                        height: 90,
                        color: Colors.grey[850],
                        child: const Icon(Icons.fitness_center, color: Colors.white54),
                      );
                    },
                  ),
                ),
                
                const SizedBox(width: 16),
                
                // --- 2. O TEXTO (Correção das listras amarelas) ---
                Expanded( // <--- O SEGREDO: Ocupa só o espaço disponível
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        gym.name,
                        maxLines: 1, // Limita a 1 linha
                        overflow: TextOverflow.ellipsis, // Coloca "..." se for grande
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        gym.address,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis, // "..." no endereço também
                        style: TextStyle(color: Colors.grey[400], fontSize: 12),
                      ),
                      const SizedBox(height: 8),
                      // Estrelas e Ícones
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            gym.rating.toString(),
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // --- 3. O PREÇO ---
                const SizedBox(width: 8),
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