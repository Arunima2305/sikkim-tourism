import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/booking_store.dart';

class MyBookingsPage extends StatelessWidget {
  const MyBookingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final store = BookingStore();
    return Scaffold(
      appBar: AppBar(title: const Text('My Bookings')),
      body: AnimatedBuilder(
        animation: store,
        builder: (_, __) {
          if (store.bookings.isEmpty) {
            return const Center(child: Text('No bookings yet'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: store.bookings.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (_, i) {
              final b = store.bookings[i];
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.confirmation_num_outlined),
                  title: Text('${b.monastery} • ${b.guide.name}'),
                  subtitle: Text(
                    '${DateFormat.yMMMEd().format(b.date)} • ${b.timeSlot} • Group ${b.groupSize}\nTotal ₹${b.price}',
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
