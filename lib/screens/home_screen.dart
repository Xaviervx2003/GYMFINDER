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
    const HomeTab(),      
    const MapScreen(),    
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
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

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final String googleApiKey = "AIzaSyBBnswbr2JOFi70hMAmTU5-scnTF942CAE";
  
  List<Gym> allGyms = []; 
  List<Gym> filteredGyms = []; 
  bool isLoading = true;
  String errorMessage = "";
  
  final TextEditingController _searchController = TextEditingController();
  bool _onlyOpen = false;

  @override
  void initState() {
    super.initState();
    _fetchRealGyms();
  }

  void _filterList() {
    final query = _searchController.text.toLowerCase();
    
    setState(() {
      filteredGyms = allGyms.where((gym) {
        final matchesName = gym.name.toLowerCase().contains(query);
        final matchesOpen = _onlyOpen ? gym.isOpen : true;
        return matchesName && matchesOpen;
      }).toList();
    });
  }

  Future<void> _fetchRealGyms() async {
    setState(() {
      isLoading = true;
      errorMessage = "";
    });

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

      final url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${position.latitude},${position.longitude}&radius=10000&type=gym&key=$googleApiKey';
      
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List results = data['results'];

        List<Gym> loadedGyms = [];

        for (var place in results) {
          bool isOpenNow = place['opening_hours']?['open_now'] ?? false;
          double gymLat = place['geometry']['location']['lat'];
          double gymLng = place['geometry']['location']['lng'];

          // === A MÁGICA DO CÁLCULO DE DISTÂNCIA COMEÇA AQUI ===
          
          // 1. Calcula a distância em metros
          double distMeters = Geolocator.distanceBetween(
            position.latitude, 
            position.longitude, 
            gymLat, 
            gymLng
          );

          // 2. Formata para ficar bonito (Km ou m)
          String formattedDistance;
          if (distMeters >= 1000) {
            // Se for mais de 1000m, converte para km com 1 casa decimal (Ex: 1.2 km)
            formattedDistance = "${(distMeters / 1000).toStringAsFixed(1)} km";
          } else {
            // Se for perto, mostra só os metros (Ex: 800 m)
            formattedDistance = "${distMeters.toInt()} m";
          }
          // ====================================================

          loadedGyms.add(Gym(
            id: place['place_id'],
            name: place['name'] ?? "Academia",
            address: place['vicinity'] ?? "Endereço não informado",
            imageUrl: "https://images.unsplash.com/photo-1534438327276-14e5300c3a48?q=80&w=1470&auto=format&fit=crop",
            dayPassPrice: 25.0,
            rating: place['rating']?.toDouble() ?? 4.0,
            hasAirConditioning: true,
            isOpen: isOpenNow,
            latitude: gymLat,
            longitude: gymLng,
            distance: formattedDistance, // <--- Aqui passamos o cálculo real!
          ));
        }

        // Ordena a lista: as mais próximas aparecem primeiro! 📍
        loadedGyms.sort((a, b) {
            // Gambiarra inteligente: converte a string de volta pra numero para ordenar
            double distA = a.distance.contains("km") 
                ? double.parse(a.distance.split(" ")[0]) * 1000 
                : double.parse(a.distance.split(" ")[0]);
            double distB = b.distance.contains("km") 
                ? double.parse(b.distance.split(" ")[0]) * 1000 
                : double.parse(b.distance.split(" ")[0]);
            return distA.compareTo(distB);
        });

        if (mounted) {
          setState(() {
            allGyms = loadedGyms;
            filteredGyms = loadedGyms;
            isLoading = false;
            if (_onlyOpen) _filterList();
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
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchRealGyms,
        backgroundColor: Colors.deepPurpleAccent,
        child: const Icon(Icons.my_location, color: Colors.white),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 140, 
            floating: true,
            pinned: true,
            backgroundColor: const Color(0xFF0F0F0F),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.zero,
              background: Padding(
                padding: const EdgeInsets.fromLTRB(16, 50, 16, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("GymFinder", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onChanged: (value) => _filterList(), 
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: "Buscar academia...",
                              hintStyle: TextStyle(color: Colors.grey[600]),
                              prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                              filled: true,
                              fillColor: const Color(0xFF1E1E1E),
                              contentPadding: const EdgeInsets.symmetric(vertical: 0),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        FilterChip(
                          label: const Text("Aberto"),
                          selected: _onlyOpen,
                          onSelected: (bool selected) {
                            setState(() {
                              _onlyOpen = selected;
                              _filterList();
                            });
                          },
                          backgroundColor: const Color(0xFF1E1E1E),
                          selectedColor: Colors.greenAccent.withOpacity(0.2),
                          labelStyle: TextStyle(color: _onlyOpen ? Colors.greenAccent : Colors.white),
                          checkmarkColor: Colors.greenAccent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          side: BorderSide.none,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          if (isLoading)
            const SliverFillRemaining(child: Center(child: CircularProgressIndicator(color: Colors.deepPurpleAccent)))
          else if (errorMessage.isNotEmpty)
             SliverFillRemaining(child: Center(child: Text(errorMessage, style: const TextStyle(color: Colors.red))))
          else if (filteredGyms.isEmpty)
             const SliverFillRemaining(child: Center(child: Text("Nenhuma academia encontrada 😕", style: TextStyle(color: Colors.white))))
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  // Passamos a academia que JÁ TEM a distância calculada
                  return GymCard(gym: filteredGyms[index]);
                },
                childCount: filteredGyms.length,
              ),
            ),
        ],
      ),
    );
  }
}