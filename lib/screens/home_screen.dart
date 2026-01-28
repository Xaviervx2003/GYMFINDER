import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
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
  final List<Widget> _pages = [const HomeTab(), const MapScreen()];

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

// === ABA LISTA ===
class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final String googleApiKey =
      "AIzaSyBBnswbr2JOFi70hMAmTU5-scnTF942CAE"; // SUA CHAVE

  List<Gym> allGyms = [];
  List<Gym> filteredGyms = [];
  bool isLoading = true;
  String errorMessage = "";

  final TextEditingController _searchController = TextEditingController();
  bool _onlyOpen = false;

  // === NOVO FILTRO DE RAIO (Padrão 2km) ===
  double _searchRadiusKm = 2.0;

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

  // Função para pegar fotos (igual antes)
  String _getPhotoUrl(var photoReference) {
    if (photoReference == null)
      return "https://images.unsplash.com/photo-1534438327276-14e5300c3a48?q=80&w=1470&auto=format&fit=crop";
    return 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=$photoReference&key=$googleApiKey';
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
          if (mounted)
            setState(() {
              isLoading = false;
              errorMessage = "Sem permissão GPS";
            });
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition();

      // USA O RAIO SELECIONADO NA URL
      int radiusMeters = (_searchRadiusKm * 1000).toInt();
      final url =
          'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${position.latitude},${position.longitude}&radius=$radiusMeters&type=gym&key=$googleApiKey';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List results = data['results'];

        List<Gym> loadedGyms = [];

        for (var place in results) {
          bool isOpenNow = place['opening_hours']?['open_now'] ?? false;
          double gymLat = place['geometry']['location']['lat'];
          double gymLng = place['geometry']['location']['lng'];

          String? photoRef;
          if (place['photos'] != null && place['photos'].length > 0) {
            photoRef = place['photos'][0]['photo_reference'];
          }

          double distMeters = Geolocator.distanceBetween(
            position.latitude,
            position.longitude,
            gymLat,
            gymLng,
          );
          String formattedDistance = distMeters >= 1000
              ? "${(distMeters / 1000).toStringAsFixed(1)} km"
              : "${distMeters.toInt()} m";

          loadedGyms.add(
            Gym(
              id: place['place_id'],
              name: place['name'] ?? "Academia",
              address: place['vicinity'] ?? "Endereço não informado",
              imageUrl: _getPhotoUrl(photoRef),
              dayPassPrice: 25.0,
              rating: place['rating']?.toDouble() ?? 0.0,
              hasAirConditioning: true,
              isOpen: isOpenNow,
              latitude: gymLat,
              longitude: gymLng,
              distance: formattedDistance,
            ),
          );
        }

        // Ordenar por distância real
        loadedGyms.sort((a, b) {
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
        if (mounted)
          setState(() {
            isLoading = false;
            errorMessage = "Erro API: ${response.statusCode}";
          });
      }
    } catch (e) {
      if (mounted)
        setState(() {
          isLoading = false;
          errorMessage = "Erro Internet";
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchRealGyms,
        backgroundColor: Colors.deepPurpleAccent,
        child: const Icon(Icons.refresh, color: Colors.white),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180, // Aumentei para caber o slider
            floating: true,
            pinned: true,
            backgroundColor: const Color(0xFF0F0F0F),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.zero,
              background: Padding(
                padding: const EdgeInsets.fromLTRB(16, 40, 16, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "GymFinder",
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // === BARRA DE PESQUISA ===
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 40,
                            child: TextField(
                              controller: _searchController,
                              onChanged: (value) => _filterList(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                              decoration: InputDecoration(
                                hintText: "Buscar...",
                                hintStyle: TextStyle(color: Colors.grey[600]),
                                prefixIcon: const Icon(
                                  Icons.search,
                                  color: Colors.grey,
                                  size: 20,
                                ),
                                filled: true,
                                fillColor: const Color(0xFF1E1E1E),
                                contentPadding: EdgeInsets.zero,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        FilterChip(
                          label: const Text(
                            "Aberto",
                            style: TextStyle(fontSize: 12),
                          ),
                          selected: _onlyOpen,
                          onSelected: (bool selected) {
                            setState(() {
                              _onlyOpen = selected;
                              _filterList();
                            });
                          },
                          backgroundColor: const Color(0xFF1E1E1E),
                          selectedColor: Colors.green.withOpacity(0.2),
                          labelStyle: TextStyle(
                            color: _onlyOpen ? Colors.green : Colors.white,
                          ),
                          checkmarkColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          side: BorderSide.none,
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // === NOVO FILTRO DE RAIO (SLIDER) ===
                    Row(
                      children: [
                        Text(
                          "Raio: ${_searchRadiusKm.toInt()} km",
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                        Expanded(
                          child: SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: Colors.deepPurpleAccent,
                              thumbColor: Colors.deepPurpleAccent,
                              overlayColor: Colors.deepPurpleAccent.withOpacity(
                                0.2,
                              ),
                              trackHeight: 2,
                              thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 6,
                              ),
                            ),
                            child: Slider(
                              value: _searchRadiusKm,
                              min: 1,
                              max: 10,
                              divisions: 9,
                              label: "${_searchRadiusKm.toInt()} km",
                              onChanged: (double value) {
                                setState(() {
                                  _searchRadiusKm = value;
                                });
                              },
                              onChangeEnd: (double value) {
                                // Só recarrega quando soltar o dedo
                                _fetchRealGyms();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          if (isLoading)
            const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.deepPurpleAccent,
                ),
              ),
            )
          else if (filteredGyms.isEmpty)
            const SliverFillRemaining(
              child: Center(
                child: Text(
                  "Nada encontrado neste raio 🕵️",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => GymCard(gym: filteredGyms[index]),
                childCount: filteredGyms.length,
              ),
            ),
        ],
      ),
    );
  }
}
