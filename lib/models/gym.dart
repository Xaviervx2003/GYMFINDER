class Gym {
  final String id;
  final String name;
  final double rating;
  final double dayPassPrice;
  final String distance;
  final bool hasAirConditioning;

  Gym({
    required this.id,
    required this.name,
    required this.rating,
    required this.dayPassPrice,
    required this.distance,
    this.hasAirConditioning = true,
  });
}
