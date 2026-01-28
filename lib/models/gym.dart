class Gym {
  final String id;
  final String name;
  final String address;
  final String imageUrl;
  final double dayPassPrice;
  final double rating;
  final String distance;
  final bool hasAirConditioning;
  final bool isOpen; // <--- NOVO CAMPO
  final double latitude;
  final double longitude;

  Gym({
    required this.id,
    required this.name,
    this.address = "Endereço não informado",
    this.imageUrl = "https://images.unsplash.com/photo-1534438327276-14e5300c3a48?q=80&w=1470&auto=format&fit=crop",
    required this.dayPassPrice,
    required this.rating,
    this.distance = "Calculando...",
    required this.hasAirConditioning,
    this.isOpen = true, // Valor padrão
    this.latitude = 0.0,
    this.longitude = 0.0,
  });
}