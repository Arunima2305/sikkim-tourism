// Detailed monastery data for Sikkim tourism
import '../models/monastery.dart';

const monasteries = <Monastery>[
  Monastery(
    id: 'm1', 
    name: 'Rumtek Monastery', 
    lat: 27.3172, 
    lng: 88.6220, 
    district: 'Gangtok',
    description: 'Rumtek Monastery, also known as the Dharmachakra Centre, is one of the most significant monasteries in Sikkim. It serves as the seat-in-exile of the Gyalwa Karmapa, head of the Karma Kagyu lineage.',
    history: 'Built in the 1960s by the 16th Karmapa, Rangjung Rigpe Dorje, it was designed as a replica of the Karmapa\'s original seat at Tsurphu Monastery in Tibet. The monastery was constructed to preserve Tibetan Buddhist culture after the Chinese occupation of Tibet.',
    imageUrls: [
      'https://images.unsplash.com/photo-1583846862638-d6fb84c5a7a8?w=800',
      'https://images.unsplash.com/photo-1544717297-fa95b6ee9643?w=800',
      'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=800',
    ],
    panoramaUrls: [
      'https://pannellum.org/images/alma.jpg',
      'https://pannellum.org/images/cerro-toco-0.jpg',
    ],
    wikiUrl: 'https://en.wikipedia.org/wiki/Rumtek_Monastery',
    features: [
      'Golden Stupa',
      'Tibetan Buddhist Art',
      'Sacred Relics',
      'Traditional Architecture',
      'Prayer Wheels',
      'Meditation Halls'
    ],
    timings: '6:00 AM - 6:00 PM',
    entryFee: 'Free',
    significance: 'Seat of the Karmapa lineage and center for Tibetan Buddhist learning'
  ),
  Monastery(
    id: 'm2', 
    name: 'Pemayangtse Monastery', 
    lat: 27.2887, 
    lng: 88.2454, 
    district: 'Pelling',
    description: 'Pemayangtse Monastery is one of the oldest and most important monasteries in Sikkim, belonging to the Nyingma sect of Tibetan Buddhism. The name means "Perfect Sublime Lotus".',
    history: 'Founded in 1705 by Lama Lhatsun Chempo, it was built to house monks of pure Tibetan stock. The monastery has played a crucial role in Sikkim\'s history and was once the second most important monastery after Samding.',
    imageUrls: [
      'https://images.unsplash.com/photo-1590736969955-71cc94901144?w=800',
      'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=800',
      'https://images.unsplash.com/photo-1583846862638-d6fb84c5a7a8?w=800',
    ],
    panoramaUrls: [
      'https://pannellum.org/images/bma-0.jpg',
      'https://pannellum.org/images/from-tree.jpg',
    ],
    wikiUrl: 'https://en.wikipedia.org/wiki/Pemayangtse_Monastery',
    features: [
      'Ancient Murals',
      '7-tiered Wooden Structure',
      'Statue of Guru Rinpoche',
      'Religious Artifacts',
      'Traditional Library',
      'Mountain Views'
    ],
    timings: '7:00 AM - 5:00 PM',
    entryFee: '₹10 for Indians, ₹20 for Foreigners',
    significance: 'One of the oldest monasteries and royal monastery of former Sikkim kingdom'
  ),
  Monastery(
    id: 'm3', 
    name: 'Tashiding Monastery', 
    lat: 27.2751, 
    lng: 88.2696, 
    district: 'West Sikkim',
    description: 'Tashiding Monastery is situated on a hilltop between the Rathong and Rangeet rivers. It is considered one of the most sacred monasteries in Sikkim and holds special significance for all Buddhist sects.',
    history: 'Built in 1717 by Ngadak Sempa Chenpo, it is famous for the Bhumchu festival where sacred water is distributed. Legend says that a drop of water from every sacred place in the world can be found in its holy water.',
    imageUrls: [
      'https://images.unsplash.com/photo-1544717297-fa95b6ee9643?w=800',
      'https://images.unsplash.com/photo-1590736969955-71cc94901144?w=800',
      'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=800',
    ],
    panoramaUrls: [
      'https://pannellum.org/images/jfk.jpg',
    ],
    wikiUrl: 'https://en.wikipedia.org/wiki/Tashiding_Monastery',
    features: [
      'Sacred Stupas',
      'Holy Water Source',
      'Prayer Flags',
      'River Confluence Views',
      'Ancient Texts',
      'Festival Grounds'
    ],
    timings: '6:00 AM - 6:00 PM',
    entryFee: 'Free',
    significance: 'Most sacred monastery in Sikkim, believed to wash away sins'
  ),
  Monastery(
    id: 'm4', 
    name: 'Phodong Monastery', 
    lat: 27.3940, 
    lng: 88.6014, 
    district: 'North Sikkim',
    description: 'Phodong Monastery is one of the six most important monasteries of Sikkim, rebuilt in the early 18th century. It belongs to the Kagyupa sect and is known for its beautiful murals and religious festivals.',
    history: 'Originally built in 1721 and later rebuilt in 1740, the monastery was founded by Chogyal Gyurmed Namgyal. It has been a center of learning and religious practice for centuries.',
    imageUrls: [
      'https://images.unsplash.com/photo-1583846862638-d6fb84c5a7a8?w=800',
      'https://images.unsplash.com/photo-1590736969955-71cc94901144?w=800',
      'https://images.unsplash.com/photo-1544717297-fa95b6ee9643?w=800',
    ],
    wikiUrl: 'https://en.wikipedia.org/wiki/Phodong_Monastery',
    features: [
      'Beautiful Murals',
      'Ancient Manuscripts',
      'Traditional Thangkas',
      'Buddhist Sculptures',
      'Monastery School',
      'Panoramic Views'
    ],
    timings: '6:30 AM - 5:30 PM',
    entryFee: 'Free',
    significance: 'Important center for Kagyu sect teachings and traditional arts'
  ),
  Monastery(
    id: 'm5', 
    name: 'Ralang Monastery', 
    lat: 27.2594, 
    lng: 88.3719, 
    district: 'South Sikkim',
    description: 'Ralang Monastery is famous for its sacred Cham dances performed during festivals. It belongs to the Kagyu sect and is known for its peaceful atmosphere and beautiful location.',
    history: 'Built in 1768 by the fourth Chogyal Tenzin Namgyal, it was established to commemorate the victory over the Bhutanese. The monastery is renowned for its annual Pang Lhabsol festival.',
    imageUrls: [
      'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=800',
      'https://images.unsplash.com/photo-1583846862638-d6fb84c5a7a8?w=800',
      'https://images.unsplash.com/photo-1544717297-fa95b6ee9643?w=800',
    ],
    wikiUrl: 'https://en.wikipedia.org/wiki/Ralang_Monastery',
    features: [
      'Sacred Cham Dances',
      'Festival Masks',
      'Traditional Costumes',
      'Buddhist Artifacts',
      'Meditation Halls',
      'Scenic Location'
    ],
    timings: '7:00 AM - 5:00 PM',
    entryFee: 'Free',
    significance: 'Famous for traditional Cham dances and Pang Lhabsol festival'
  ),
];
