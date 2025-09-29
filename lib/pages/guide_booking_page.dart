import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/guides.dart';
import '../models/booking.dart';
import '../models/guide.dart';

class GuideBookingPage extends StatefulWidget {
  final String? monastery;
  const GuideBookingPage({super.key, this.monastery});

  @override
  State<GuideBookingPage> createState() => _GuideBookingPageState();
}

class _GuideBookingPageState extends State<GuideBookingPage> {
  Guide? selectedGuide;
  DateTime? selectedDate;
  String? selectedSlot;
  int groupSize = 2;
  String? monastery;

  final _slots = const [
    '08:00–10:00',
    '10:30–12:30',
    '13:30–15:30',
    '16:00–18:00',
  ];

  @override
  void initState() {
    super.initState();
    monastery = widget.monastery;
  }

  int _computePrice() {
    if (selectedGuide == null) return 0;
    // simple pricing: base per-person × group, with tiny weekend premium
    final base = selectedGuide!.pricePerPerson * groupSize;
    if (selectedDate == null) return base;
    final dow = selectedDate!.weekday; // 6,7 weekend
    return (dow == DateTime.saturday || dow == DateTime.sunday) ? (base * 1.1).round() : base;
  }

  @override
  Widget build(BuildContext context) {
    final price = _computePrice();

    return Scaffold(
      appBar: AppBar(title: const Text('Book a Guide')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextFormField(
            initialValue: monastery ?? '',
            decoration: const InputDecoration(
              labelText: 'Monastery',
              hintText: 'e.g., Rumtek Monastery',
              prefixIcon: Icon(Icons.temple_buddhist),
            ),
            onChanged: (v) => monastery = v,
          ),
          const SizedBox(height: 16),

          Text('Available Guides', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),

          // Guides as cards
          SizedBox(
            height: 230,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: guides.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (_, i) {
                final g = guides[i];
                final isSel = selectedGuide?.id == g.id;
                return GestureDetector(
                  onTap: () => setState(() => selectedGuide = g),
                  child: SizedBox(
                    width: 280,
                    child: Card(
                      color: isSel ? Theme.of(context).colorScheme.surfaceTint.withOpacity(0.08) : null,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                            child: CachedNetworkImage(
                              imageUrl: g.photoUrl,
                              height: 120,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(g.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                                const SizedBox(height: 2),
                                Text('⭐ ${g.rating} • ₹${g.pricePerPerson}/person'),
                                const SizedBox(height: 6),
                                Wrap(
                                  spacing: 6,
                                  children: g.languages.map((l) => Chip(label: Text(l))).toList(),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // Date & Group size
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.date_range),
                  onPressed: () async {
                    final now = DateTime.now();
                    final picked = await showDatePicker(
                      context: context,
                      firstDate: now,
                      lastDate: now.add(const Duration(days: 120)),
                      initialDate: now.add(const Duration(days: 1)),
                    );
                    if (picked != null) setState(() => selectedDate = picked);
                  },
                  label: Text(selectedDate == null
                      ? 'Select Date'
                      : DateFormat.yMMMEd().format(selectedDate!)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<int>(
                  decoration: const InputDecoration(labelText: 'Group Size'),
                  value: groupSize,
                  items: [1,2,3,4,5,6,7,8]
                      .map((i) => DropdownMenuItem(value: i, child: Text('$i')))
                      .toList(),
                  onChanged: (v) => setState(() => groupSize = v ?? 2),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Time slots
          Text('Time Slot', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            children: _slots.map((s) {
              final sel = selectedSlot == s;
              return ChoiceChip(
                label: Text(s),
                selected: sel,
                onSelected: (_) => setState(() => selectedSlot = s),
              );
            }).toList(),
          ),

          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: Text('Total • ₹$price',
                    style: Theme.of(context).textTheme.titleLarge),
              ),
              FilledButton(
                onPressed: (selectedGuide != null && selectedDate != null && selectedSlot != null && (monastery?.isNotEmpty ?? false))
                    ? () {
                        final booking = Booking(
                          guide: selectedGuide!,
                          date: selectedDate!,
                          timeSlot: selectedSlot!,
                          groupSize: groupSize,
                          monastery: monastery!,
                          price: price,
                        );
                        Navigator.pushNamed(context, '/checkout', arguments: booking);
                      }
                    : null,
                child: const Text('Continue'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
