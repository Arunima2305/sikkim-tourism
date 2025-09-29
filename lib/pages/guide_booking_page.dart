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
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book a Guide'),
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.surface,
              theme.colorScheme.surface.withOpacity(0.95),
            ],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          children: [
            // Header Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withOpacity(0.3),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: theme.colorScheme.outline.withOpacity(0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.temple_buddhist,
                        color: theme.colorScheme.primary,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Destination',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    initialValue: monastery ?? '',
                    decoration: InputDecoration(
                      hintText: 'e.g., Rumtek Monastery',
                      filled: true,
                      fillColor: theme.colorScheme.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                    onChanged: (v) => monastery = v,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Guides Section Header
            Row(
              children: [
                Icon(
                  Icons.people_alt_outlined,
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Select Your Guide',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Choose from our experienced local guides',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 16),

            // Professional Guide Cards
            SizedBox(
              height: 300,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                itemCount: guides.length,
                separatorBuilder: (_, __) => const SizedBox(width: 16),
                itemBuilder: (_, i) {
                  final g = guides[i];
                  final isSel = selectedGuide?.id == g.id;
                  return GestureDetector(
                    onTap: () => setState(() => selectedGuide = g),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: isSel 
                              ? theme.colorScheme.primary.withOpacity(0.2)
                              : Colors.black.withOpacity(0.08),
                            blurRadius: isSel ? 12 : 8,
                            offset: const Offset(0, 4),
                            spreadRadius: isSel ? 2 : 0,
                          ),
                        ],
                      ),
                      child: Card(
                        elevation: 0,
                        margin: EdgeInsets.zero,
                        color: isSel 
                          ? theme.colorScheme.primaryContainer.withOpacity(0.1)
                          : theme.colorScheme.surface,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: isSel 
                              ? theme.colorScheme.primary
                              : theme.colorScheme.outline.withOpacity(0.2),
                            width: isSel ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(18),
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl: g.photoUrl,
                                    height: 140,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(
                                      height: 140,
                                      color: theme.colorScheme.surfaceVariant,
                                      child: const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    ),
                                  ),
                                ),
                                if (isSel)
                                  Positioned(
                                    top: 12,
                                    right: 12,
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: theme.colorScheme.primary,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.check,
                                        color: theme.colorScheme.onPrimary,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      g.name,
                                      style: theme.textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: theme.colorScheme.onSurface,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.amber.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                                size: 14,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                '${g.rating}',
                                                style: theme.textTheme.bodySmall?.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Spacer(),
                                        Text(
                                          '₹${g.pricePerPerson}',
                                          style: theme.textTheme.titleSmall?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: theme.colorScheme.primary,
                                          ),
                                        ),
                                        Text(
                                          '/person',
                                          style: theme.textTheme.bodySmall?.copyWith(
                                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Flexible(
                                      child: Wrap(
                                        spacing: 6,
                                        runSpacing: 4,
                                        children: g.languages.take(3).map((l) => 
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: theme.colorScheme.secondaryContainer.withOpacity(0.5),
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              l,
                                              style: theme.textTheme.bodySmall?.copyWith(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ).toList(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 32),

            // Booking Details Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: theme.colorScheme.outline.withOpacity(0.2),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.event_note,
                        color: theme.colorScheme.primary,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Booking Details',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // Date & Group size
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: theme.colorScheme.outline.withOpacity(0.3),
                            ),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () async {
                                final now = DateTime.now();
                                final picked = await showDatePicker(
                                  context: context,
                                  firstDate: now,
                                  lastDate: now.add(const Duration(days: 120)),
                                  initialDate: now.add(const Duration(days: 1)),
                                );
                                if (picked != null) setState(() => selectedDate = picked);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today,
                                      color: theme.colorScheme.primary,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Date',
                                            style: theme.textTheme.bodySmall?.copyWith(
                                              color: theme.colorScheme.onSurface.withOpacity(0.6),
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            selectedDate == null
                                              ? 'Select Date'
                                              : DateFormat.yMMMEd().format(selectedDate!),
                                            style: theme.textTheme.titleSmall?.copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: theme.colorScheme.outline.withOpacity(0.3),
                            ),
                          ),
                          child: DropdownButtonFormField<int>(
                            decoration: InputDecoration(
                              labelText: 'Group Size',
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(16),
                              labelStyle: TextStyle(
                                color: theme.colorScheme.onSurface.withOpacity(0.6),
                              ),
                            ),
                            value: groupSize,
                            items: [1,2,3,4,5,6,7,8]
                                .map((i) => DropdownMenuItem(
                                  value: i, 
                                  child: Text('$i ${i == 1 ? 'person' : 'people'}'),
                                ))
                                .toList(),
                            onChanged: (v) => setState(() => groupSize = v ?? 2),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Time slots
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        color: theme.colorScheme.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Select Time Slot',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 2.5,
                    ),
                    itemCount: _slots.length,
                    itemBuilder: (context, index) {
                      final slot = _slots[index];
                      final isSelected = selectedSlot == slot;
                      return GestureDetector(
                        onTap: () => setState(() => selectedSlot = slot),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            color: isSelected 
                              ? theme.colorScheme.primary
                              : theme.colorScheme.surfaceVariant.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected 
                                ? theme.colorScheme.primary
                                : theme.colorScheme.outline.withOpacity(0.3),
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              slot,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: isSelected 
                                  ? theme.colorScheme.onPrimary
                                  : theme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Price Summary and Continue Button
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primaryContainer.withOpacity(0.3),
                    theme.colorScheme.secondaryContainer.withOpacity(0.2),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: theme.colorScheme.outline.withOpacity(0.2),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Amount',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '₹$price',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          if (selectedDate != null && (selectedDate!.weekday == DateTime.saturday || selectedDate!.weekday == DateTime.sunday))
                            Text(
                              'Weekend pricing applied',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.primary,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.payments,
                          color: theme.colorScheme.primary,
                          size: 32,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: (selectedGuide != null && 
                                 selectedDate != null && 
                                 selectedSlot != null && 
                                 (monastery?.isNotEmpty ?? false))
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
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Continue to Checkout',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.arrow_forward,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
