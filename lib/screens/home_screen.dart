import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart'; // <--- Import
import '../widgets/gym_card.dart';
import '../models/gym.dart';
import '../services/gym_service.dart';
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
      backgroundColor: AppColors.background, // <--- Fundo Global
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        backgroundColor: AppColors.surface, // <--- Barra de Navegação
        indicatorColor: AppColors.primary,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.list_alt_outlined, color: AppColors.textWhite),
            selectedIcon: Icon(Icons.list_alt, color: AppColors.textWhite),
            label: 'Lista',
          ),
          NavigationDestination(
            icon: Icon(Icons.map_outlined, color: AppColors.textWhite),
            selectedIcon: Icon(Icons.map, color: AppColors.textWhite),
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
  final GymService _gymService = GymService();
  List<Gym> allGyms = [];
  List<Gym> filteredGyms = [];
  bool isLoading = true;
  String errorMessage = "";
  final TextEditingController _searchController = TextEditingController();
  bool _onlyOpen = false;
  double _searchRadiusKm = 2.0;

  @override
  void initState() {
    super.initState();
    _loadGyms();
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

  Future<void> _loadGyms() async {
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
      int radiusMeters = (_searchRadiusKm * 1000).toInt();

      List<Gym> gyms = await _gymService.fetchNearbyGyms(
        userPosition: position,
        radiusMeters: radiusMeters,
      );

      if (mounted) {
        setState(() {
          allGyms = gyms;
          filteredGyms = gyms;
          isLoading = false;
          if (_onlyOpen) _filterList();
        });
      }
    } catch (e) {
      if (mounted)
        setState(() {
          isLoading = false;
          errorMessage = e.toString().replaceAll("Exception:", "");
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: FloatingActionButton(
        onPressed: _loadGyms,
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.refresh, color: AppColors.textWhite),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180,
            floating: true,
            pinned: true,
            backgroundColor: AppColors.background,
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
                        color: AppColors.textWhite,
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 40,
                            child: TextField(
                              controller: _searchController,
                              onChanged: (value) => _filterList(),
                              style: const TextStyle(
                                color: AppColors.textWhite,
                                fontSize: 14,
                              ),
                              decoration: InputDecoration(
                                hintText: "Buscar...",
                                hintStyle: const TextStyle(
                                  color: AppColors.textGrey,
                                ),
                                prefixIcon: const Icon(
                                  Icons.search,
                                  color: AppColors.textGrey,
                                  size: 20,
                                ),
                                filled: true,
                                fillColor: AppColors
                                    .surface, // <--- Input usando Surface
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
                          backgroundColor: AppColors.surface,
                          selectedColor: AppColors.open.withOpacity(0.2),
                          labelStyle: TextStyle(
                            color: _onlyOpen
                                ? AppColors.open
                                : AppColors.textWhite,
                          ),
                          checkmarkColor: AppColors.open,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          side: BorderSide.none,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
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
                              activeTrackColor: AppColors.primary,
                              thumbColor: AppColors.primary,
                              overlayColor: AppColors.primary.withOpacity(0.2),
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
                                _loadGyms();
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
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            )
          else if (errorMessage.isNotEmpty)
            SliverFillRemaining(
              child: Center(
                child: Text(
                  errorMessage,
                  style: const TextStyle(color: AppColors.closed),
                ),
              ),
            )
          else if (filteredGyms.isEmpty)
            const SliverFillRemaining(
              child: Center(
                child: Text(
                  "Nada encontrado neste raio 🕵️",
                  style: TextStyle(color: AppColors.textWhite),
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
