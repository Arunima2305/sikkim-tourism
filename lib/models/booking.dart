import 'guide.dart';

class Booking {
  final Guide guide;
  final DateTime date;
  final String timeSlot;   // e.g., "09:00–11:00"
  final int groupSize;
  final String monastery;
  final int price; // in INR

  Booking({
    required this.guide,
    required this.date,
    required this.timeSlot,
    required this.groupSize,
    required this.monastery,
    required this.price,
  });
}
