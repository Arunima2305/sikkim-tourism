import '../models/event.dart';

final events = <TourismEvent>[
  TourismEvent(
    date: DateTime.now(),
    title: 'Mask Dance Festival',
    description: 'Colorful Cham dance at Rumtek.',
    location: 'Rumtek Monastery',
  ),
  TourismEvent(
    date: DateTime.now().add(const Duration(days: 7)),
    title: 'Buddhist Scripture Reading',
    description: 'Traditional reading and prayers.',
    location: 'Tashiding Monastery',
  ),
];
