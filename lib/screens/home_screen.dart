import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import '../widgets/gym_card.dart';
import '../models/gym.dart';
import 'map_screen.dart'; 

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; 

  final List<Widget> _pages = [
    const HomeTab(),      // Aba 1: Lista
    const MapScreen(),    // Aba 2: Mapa Global
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        backgroundColor: const Color(0xFF1E1E1E),
        indicatorColor: Colors.deepPurpleAccent,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.list_alt_outlined, color: Colors.white),
            selectedIcon: Icon(Icons.list_alt, color: Colors.white),
            label: 'Lista',
          ),
          NavigationDestination(
            icon: Icon(Icons.map_outlined, color: Colors.white),
            selectedIcon: Icon(Icons.map, color: Colors.white),
            label: 'Mapa',
          ),
        ],
      ),
    );
  }
}

// =======================================================
// ABA LISTA (HomeTab)
// =======================================================
class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final String googleApiKey = "AIzaSyBBnswbr2JOFi70hMAmTU5-scnTF942CAE";
  List<Gym> nearbyGyms = [];
  bool isLoading = true;
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    _fetchRealGyms();
  }

  Future<void> _fetchRealGyms() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) setState(() { isLoading = false; errorMessage = "Sem permissão de GPS"; });
          return;
        }
      }
      
      Position position = await Geolocator.getCurrentPosition();

      final url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${position.latitude},${position.longitude}&radius=2000&type=gym&key=$googleApiKey';
      
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List results = data['results'];

        List<Gym> loadedGyms = [];

        for (var place in results) {
          loadedGyms.add(Gym(
            id: place['place_id'],
            name: place['name'] ?? "Academia",
            address: place['vicinity'] ?? "Endereço não informado",
            imageUrl: "https://images.unsplash.com/photo-1534438327276-14e5300c3a48?q=80&w=1470&auto=format&fit=crop",
            dayPassPrice: 25.0,
            rating: place['rating']?.toDouble() ?? 4.0,
            hasAirConditioning: true,
            latitude: place['geometry']['location']['lat'],
            longitude: place['geometry']['location']['lng'],
            distance: "Perto",
          ));
        }

        if (mounted) {
          setState(() {
            nearbyGyms = loadedGyms;
            isLoading = false;
          });
        }
      } else {
        if (mounted) setState(() { isLoading = false; errorMessage = "Erro Google: ${response.statusCode}"; });
      }
    } catch (e) {
      if (mounted) setState(() { isLoading = false; errorMessage = "Verifique sua internet"; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            expandedHeight: 100,
            floating: true,
            backgroundColor: Color(0xFF0F0F0F),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.only(left: 16, bottom: 16),
              title: Text("Academias Perto", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ),
          if (isLoading)
            const SliverFillRemaining(child: Center(child: CircularProgressIndicator(color: Colors.deepPurpleAccent)))
          else if (errorMessage.isNotEmpty)
             SliverFillRemaining(child: Center(child: Text(errorMessage, style: const TextStyle(color: Colors.red))))
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => GymCard(gym: nearbyGyms[index]),
                childCount: nearbyGyms.length,
              ),
            ),
        ],
      ),
    );
  }
}