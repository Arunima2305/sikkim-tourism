import '../models/guide.dart';

const guides = <Guide>[
  Guide(
    id: 'g1',
    name: 'Tenzing Bhutia',
    rating: 4.8,
    languages: ['English', 'Hindi', 'Nepali'],
    monasteries: ['Rumtek Monastery', 'Phodong Monastery'],
    pricePerPerson: 900,
    photoUrl: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?q=80&w=800', // placeholder
  ),
  Guide(
    id: 'g2',
    name: 'Sonam Lepcha',
    rating: 4.6,
    languages: ['English', 'Hindi'],
    monasteries: ['Pemayangtse Monastery', 'Tashiding Monastery'],
    pricePerPerson: 800,
    photoUrl: 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?q=80&w=800',
  ),
  Guide(
    id: 'g3',
    name: 'Pema Sherpa',
    rating: 4.9,
    languages: ['English', 'Hindi', 'Tibetan'],
    monasteries: ['Ralang Monastery', 'Pemayangtse Monastery'],
    pricePerPerson: 1000,
    photoUrl: 'https://images.unsplash.com/photo-1547425260-76bcadfb4f2c?q=80&w=800',
  ),
];
