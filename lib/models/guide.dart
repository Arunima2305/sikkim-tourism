class Guide {
  final String id;
  final String name;
  final double rating;
  final List<String> languages;
  final List<String> monasteries;
  final int pricePerPerson;     // INR
  final String photoUrl;

  const Guide({
    required this.id,
    required this.name,
    required this.rating,
    required this.languages,
    required this.monasteries,
    required this.pricePerPerson,
    required this.photoUrl,
  });
}
