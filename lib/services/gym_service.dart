import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import '../models/gym.dart';

class GymService {
  // A chave agora fica protegida aqui (idealmente viria de um .env, mas aqui já melhora)
  final String _googleApiKey = "AIzaSyBBnswbr2JOFi70hMAmTU5-scnTF942CAE";

  // Função auxiliar para montar a URL da foto
  String _getPhotoUrl(var photoReference) {
    if (photoReference == null) {
      return "https://images.unsplash.com/photo-1534438327276-14e5300c3a48?q=80&w=1470&auto=format&fit=crop";
    }
    return 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=$photoReference&key=$_googleApiKey';
  }

  // A função principal que busca, converte e ordena
  Future<List<Gym>> fetchNearbyGyms({
    required Position userPosition,
    required int radiusMeters,
  }) async {
    final url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${userPosition.latitude},${userPosition.longitude}&radius=$radiusMeters&type=gym&key=$_googleApiKey';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List results = data['results'];

        List<Gym> loadedGyms = [];

        for (var place in results) {
          // 1. Extrair dados básicos
          bool isOpenNow = place['opening_hours']?['open_now'] ?? false;
          double gymLat = place['geometry']['location']['lat'];
          double gymLng = place['geometry']['location']['lng'];

          // 2. Tratar Foto
          String? photoRef;
          if (place['photos'] != null && place['photos'].length > 0) {
            photoRef = place['photos'][0]['photo_reference'];
          }

          // 3. Calcular Distância
          double distMeters = Geolocator.distanceBetween(
            userPosition.latitude,
            userPosition.longitude,
            gymLat,
            gymLng,
          );

          // 4. Formatar Distância
          String formattedDistance = distMeters >= 1000
              ? "${(distMeters / 1000).toStringAsFixed(1)} km"
              : "${distMeters.toInt()} m";

          // 5. Criar Objeto
          loadedGyms.add(
            Gym(
              id: place['place_id'],
              name: place['name'] ?? "Academia",
              address: place['vicinity'] ?? "Endereço não informado",
              imageUrl: _getPhotoUrl(photoRef),
              dayPassPrice: 25.0, // Mockado por enquanto
              rating: place['rating']?.toDouble() ?? 0.0,
              hasAirConditioning: true, // Mockado
              isOpen: isOpenNow,
              latitude: gymLat,
              longitude: gymLng,
              distance: formattedDistance,
            ),
          );
        }

        // 6. Ordenar por proximidade (Lógica de Negócio)
        loadedGyms.sort((a, b) {
          double distA = _parseDistance(a.distance);
          double distB = _parseDistance(b.distance);
          return distA.compareTo(distB);
        });

        return loadedGyms;
      } else {
        throw Exception("Erro na API do Google: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Erro de conexão: $e");
    }
  }

  // Auxiliar para ajudar na ordenação
  double _parseDistance(String distance) {
    if (distance.contains("km")) {
      return double.parse(distance.split(" ")[0]) * 1000;
    }
    return double.parse(distance.split(" ")[0]);
  }
}
