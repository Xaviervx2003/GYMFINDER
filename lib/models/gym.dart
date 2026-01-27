class Gym {
  final String id;
  final String name;
  final String address;      // Novo (para o mapa)
  final String imageUrl;
  final double dayPassPrice;
  final double rating;
  final String distance;     // <--- RECUPERADO (para a lista não quebrar)
  final bool hasAirConditioning;
  final double latitude;     // Novo (para o mapa)
  final double longitude;    // Novo (para o mapa)

  Gym({
    required this.id,
    required this.name,
    this.address = "Endereço não informado", // Valor padrão se não vier da API
    this.imageUrl = "assets/gym_1.jpg",      // Valor padrão para não ficar vazio
    required this.dayPassPrice,
    required this.rating,
    this.distance = "Calculando...",         // Valor padrão se não tivermos a distância exata
    required this.hasAirConditioning,
    this.latitude = 0.0,
    this.longitude = 0.0,
  });
}