import '../models/gym.dart';

final List<Gym> mockGyms = [
  Gym(
    id: 'g1',
    name: 'Ironberg Iron',
    address: 'Av. Jornalista Umberto Calderaro Filho, 455 - Adrianópolis',
    // Link direto da internet
    imageUrl: 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?q=80&w=1470&auto=format&fit=crop',
    rating: 4.8,
    dayPassPrice: 29.90,
    distance: '800m',
    hasAirConditioning: true,
    latitude: -3.10719,
    longitude: -60.0261,
  ),
  Gym(
    id: 'g2',
    name: 'Smart Fit Centro',
    address: 'R. Ramos Ferreira, 1189 - Centro',
    imageUrl: 'https://images.unsplash.com/photo-1571902943202-507ec2618e8f?q=80&w=1375&auto=format&fit=crop',
    rating: 4.5,
    dayPassPrice: 19.90,
    distance: '1.2km',
    hasAirConditioning: true,
    latitude: -3.1328,
    longitude: -60.0248,
  ),
  Gym(
    id: 'g3',
    name: 'CrossFit Box',
    address: 'Av. Djalma Batista, 2010 - Chapada',
    imageUrl: 'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?q=80&w=1470&auto=format&fit=crop',
    rating: 4.9,
    dayPassPrice: 45.00,
    distance: '2.5km',
    hasAirConditioning: false,
    latitude: -3.1030,
    longitude: -60.0230,
  ),
];