import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart'; // O novo motor de mapa
import 'package:latlong2/latlong.dart'; // Coordenadas para este mapa
import 'package:geolocator/geolocator.dart';
import '../data/mock_data.dart';
import 'gym_detail_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // Posição padrão (Manaus)
  final LatLng _defaultLocation = const LatLng(-3.10719, -60.0261);
  LatLng? _currentPosition;
  bool _isLoading = true;
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() => _isLoading = false);
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() => _isLoading = false);
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition();
    
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
      _isLoading = false;
    });

    // Move a câmera para a posição do usuário
    _mapController.move(_currentPosition!, 15.0);
  }

  @override
  Widget build(BuildContext context) {
    // Definir o centro do mapa (Usuário ou Padrão)
    final center = _currentPosition ?? _defaultLocation;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mapa OpenSource"),
        backgroundColor: const Color(0xFF121212),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.deepPurpleAccent))
          : FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: center, // Posição inicial
                initialZoom: 14.0,
              ),
              children: [
                // 1. Camada do Desenho do Mapa (OpenStreetMap)
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.gymfinder',
                ),
                
                // 2. Camada dos Pinos (Marcadores)
                MarkerLayer(
                  markers: mockGyms.map((gym) {
                    // Calculando posição fake próxima
                    final gymPos = LatLng(
                      center.latitude + (mockGyms.indexOf(gym) * 0.005),
                      center.longitude + (mockGyms.indexOf(gym) * 0.005),
                    );

                    return Marker(
                      point: gymPos,
                      width: 80,
                      height: 80,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GymDetailScreen(gym: gym),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Colors.deepPurpleAccent,
                              size: 40,
                            ),
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                gym.name,
                                style: const TextStyle(
                                  fontSize: 10, 
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                
                // 3. Bolinha Azul da sua localização (Gambiarra visual simples)
                if (_currentPosition != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: _currentPosition!,
                        width: 20,
                        height: 20,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: const [BoxShadow(blurRadius: 5, color: Colors.black26)],
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
    );
  }
}