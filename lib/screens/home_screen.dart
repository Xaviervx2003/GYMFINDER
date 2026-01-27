import 'package:flutter/material.dart';
import '../widgets/gym_card.dart';
import '../data/mock_data.dart';
import 'map_screen.dart'; // Importamos o mapa aqui

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Controla qual aba está ativa

  // Aqui definimos as 3 telas do App
  final List<Widget> _pages = [
    const HomeTab(),      // Aba 1: Lista (Código extraído lá embaixo)
    const SocialTab(),    // Aba 2: Rede Social (Novo!)
    const MapScreen(),    // Aba 3: O Mapa que já criamos
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // O corpo muda dependendo da aba clicada
      body: _pages[_selectedIndex],
      
      // Barra de Navegação Inferior
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        backgroundColor: const Color(0xFF1E1E1E),
        indicatorColor: Colors.deepPurpleAccent,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined, color: Colors.white),
            selectedIcon: Icon(Icons.home, color: Colors.white),
            label: 'Início',
          ),
          NavigationDestination(
            icon: Icon(Icons.camera_alt_outlined, color: Colors.white),
            selectedIcon: Icon(Icons.camera_alt, color: Colors.white),
            label: 'Social',
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
// ABA 1: HOME TAB (A lista que já existia)
// =======================================================
class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverAppBar(
          expandedHeight: 100,
          floating: true,
          backgroundColor: Color(0xFF0F0F0F),
          flexibleSpace: FlexibleSpaceBar(
            titlePadding: EdgeInsets.only(left: 16, bottom: 16),
            title: Text(
              "GymFinder",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ),
        // Barra de Busca
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Buscar academia...",
                prefixIcon: const Icon(Icons.search, color: Colors.deepPurpleAccent),
                filled: true,
                fillColor: const Color(0xFF1E1E1E),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
        // Lista
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => GymCard(gym: mockGyms[index]),
            childCount: mockGyms.length,
          ),
        ),
      ],
    );
  }
}

// =======================================================
// ABA 2: SOCIAL TAB (Novo Feed de Fotos)
// =======================================================
class SocialTab extends StatelessWidget {
  const SocialTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Comunidade Fit"),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_a_photo, color: Colors.deepPurpleAccent),
            onPressed: () {}, 
          )
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, 
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.8,
        ),
        itemCount: 10, 
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: const Color(0xFF1E1E1E),
              image: const DecorationImage(
                // MUDANÇA AQUI: Trocamos AssetImage por NetworkImage
                image: NetworkImage("https://images.unsplash.com/photo-1517836357463-d25dfeac3438?q=80&w=1470&auto=format&fit=crop"), 
                fit: BoxFit.cover,
                opacity: 0.7,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Row(
                    children: [
                      const Icon(Icons.favorite, color: Colors.redAccent, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        "${(index + 1) * 15}", 
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}