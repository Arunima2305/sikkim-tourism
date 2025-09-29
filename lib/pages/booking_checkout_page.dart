import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/booking.dart';
import '../services/payment_service.dart';
import '../services/booking_store.dart';

class BookingCheckoutPage extends StatefulWidget {
  final Booking booking;
  const BookingCheckoutPage({super.key, required this.booking});

  @override
  State<BookingCheckoutPage> createState() => _BookingCheckoutPageState();
}

class _BookingCheckoutPageState extends State<BookingCheckoutPage> {
  bool paying = false;
  String? txnId;

  @override
  Widget build(BuildContext context) {
    final b = widget.booking;
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Guide: ${b.guide.name} • ⭐ ${b.guide.rating}'),
            Text('Monastery: ${b.monastery}'),
            Text('Date: ${DateFormat.yMMMEd().format(b.date)}'),
            Text('Time: ${b.timeSlot}'),
            Text('Group size: ${b.groupSize}'),
            const SizedBox(height: 8),
            Text('Total: ₹${b.price}', style: Theme.of(context).textTheme.titleLarge),
            const Spacer(),
            if (txnId != null)
              Card(
                child: ListTile(
                  title: const Text('Payment Successful'),
                  subtitle: Text('Transaction: $txnId'),
                  trailing: FilledButton(
                    onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/mybookings', (r) => r.isFirst),
                    child: const Text('My Bookings'),
                  ),
                ),
              ),
            FilledButton.icon(
              onPressed: paying
                  ? null
                  : () async {
                      setState(() => paying = true);
                      final id = await PaymentService.payINR(b.price, note: 'Guide booking');
                      BookingStore().add(b); // SAVE
                      setState(() {
                        txnId = id;
                        paying = false;
                      });
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Booking confirmed! Added to My Bookings.')),
                        );
                      }
                    },
              icon: const Icon(Icons.lock),
              label: Text(paying ? 'Processing...' : 'Pay Securely (Mock)'),
            ),
          ],
        ),
      ),
    );
  }
}
