class Monastery {
  final String id;
  final String name;
  final double lat;
  final double lng;
  final String district;
  final String description;
  final String history;
  final List<String> imageUrls;
  final List<String> panoramaUrls;
  final String wikiUrl;
  final List<String> features;
  final String timings;
  final String entryFee;
  final String significance;

  const Monastery({
    required this.id,
    required this.name,
    required this.lat,
    required this.lng,
    required this.district,
    required this.description,
    required this.history,
    required this.imageUrls,
    this.panoramaUrls = const [],
    required this.wikiUrl,
    required this.features,
    required this.timings,
    required this.entryFee,
    required this.significance,
  });
}
