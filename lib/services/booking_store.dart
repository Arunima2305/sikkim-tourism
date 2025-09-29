import 'package:flutter/foundation.dart';
import '../models/booking.dart';

class BookingStore extends ChangeNotifier {
  static final BookingStore _i = BookingStore._();
  BookingStore._();
  factory BookingStore() => _i;

  final List<Booking> _bookings = [];
  List<Booking> get bookings => List.unmodifiable(_bookings);

  void add(Booking b) {
    _bookings.insert(0, b);
    notifyListeners();
  }
}
