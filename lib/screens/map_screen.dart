import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'gym_detail_screen.dart';
import '../models/gym.dart'; 

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static const LatLng _defaultLocation = LatLng(-3.10719, -60.0261);
  
  // MANTENHA SUA CHAVE AQUI
  final String googleApiKey = "AIzaSyBBnswbr2JOFi70hMAmTU5-scnTF942CAE"; 

  GoogleMapController? mapController;
  LatLng? _currentPosition;
  bool _isLoading = true;
  Set<Marker> _markers = {};

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
      if (mounted) setState(() => _isLoading = false);
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (mounted) setState(() => _isLoading = false);
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition();
    
    if (!mounted) return;

    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });

    await _searchNearbyGyms(position.latitude, position.longitude);
  }

  Future<void> _searchNearbyGyms(double lat, double lng) async {
    final url = 
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$lat,$lng&radius=2000&type=gym&key=$googleApiKey';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List results = data['results'];

        Set<Marker> realGymMarkers = {};

        for (var place in results) {
          final gymName = place['name'];
          final gymLat = place['geometry']['location']['lat'];
          final gymLng = place['geometry']['location']['lng'];
          final rating = place['rating']?.toDouble() ?? 4.5;
          // Verifica se está aberto
          final isOpen = place['opening_hours']?['open_now'] ?? true;
          
          final String realAddress = place['vicinity'] ?? "Endereço indisponível";

          final tempGym = Gym(
            id: place['place_id'],
            name: gymName,
            address: realAddress,
            imageUrl: "https://images.unsplash.com/photo-1571902943202-507ec2618e8f?q=80&w=1375&auto=format&fit=crop",
            dayPassPrice: 25.0,
            rating: rating,
            hasAirConditioning: true,
            isOpen: isOpen, // <--- ADICIONADO: Passa se está aberto ou fechado
            latitude: gymLat,
            longitude: gymLng,
            distance: "Perto de você",
          );

          realGymMarkers.add(
            Marker(
              markerId: MarkerId(place['place_id']),
              position: LatLng(gymLat, gymLng),
              infoWindow: InfoWindow(
                title: gymName,
                snippet: isOpen ? "Aberto • ⭐ $rating" : "Fechado",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GymDetailScreen(gym: tempGym)),
                  );
                },
              ),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
            ),
          );
        }

        if (mounted) {
          setState(() {
            _markers = realGymMarkers;
            _isLoading = false;
          });
        }
        
        mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(LatLng(lat, lng), 14),
        );

      } else {
        if (mounted) setState(() => _isLoading = false);
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Academias Reais"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false, 
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.deepPurpleAccent))
          : GoogleMap(
              onMapCreated: (controller) => mapController = controller,
              initialCameraPosition: CameraPosition(
                target: _currentPosition ?? _defaultLocation,
                zoom: 14.0,
              ),
              markers: _markers,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),
    );
  }
}