import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/monastery.dart';

class MonasteryDetailsPage extends StatefulWidget {
  final Monastery monastery;
  
  const MonasteryDetailsPage({super.key, required this.monastery});

  @override
  State<MonasteryDetailsPage> createState() => _MonasteryDetailsPageState();
}

class _MonasteryDetailsPageState extends State<MonasteryDetailsPage> {
  final PageController _pageController = PageController();
  int _currentImageIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch $url')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final monastery = widget.monastery;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with Image Carousel
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                monastery.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(blurRadius: 10, color: Colors.black54)],
                ),
              ),
              background: Stack(
                children: [
                  PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentImageIndex = index;
                      });
                    },
                    itemCount: monastery.imageUrls.length,
                    itemBuilder: (context, index) {
                      return CachedNetworkImage(
                        imageUrl: monastery.imageUrls[index],
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Colors.grey[300],
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[300],
                          child: const Icon(Icons.error),
                        ),
                      );
                    },
                  ),
                  // Gradient overlay
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black38,
                        ],
                      ),
                    ),
                  ),
                  // Image indicators
                  if (monastery.imageUrls.length > 1)
                    Positioned(
                      bottom: 60,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: monastery.imageUrls.asMap().entries.map((entry) {
                          return Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentImageIndex == entry.key
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.4),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Basic Info Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.location_on, color: Colors.red),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '${monastery.district}, Sikkim',
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Icon(Icons.access_time, color: Colors.blue),
                              const SizedBox(width: 8),
                              Text('Timings: ${monastery.timings}'),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.currency_rupee, color: Colors.green),
                              const SizedBox(width: 8),
                              Text('Entry: ${monastery.entryFee}'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pushNamed(
                              context, 
                              '/tour',
                              arguments: monastery.name,
                            );
                          },
                          icon: const Icon(Icons.threesixty),
                          label: const Text('Virtual Tour'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              '/book',
                              arguments: monastery.name,
                            );
                          },
                          icon: const Icon(Icons.person),
                          label: const Text('Book Guide'),
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Wiki Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _launchUrl(monastery.wikiUrl),
                      icon: const Icon(Icons.info_outline),
                      label: const Text('Learn More on Wikipedia'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Description
                  Text(
                    'About',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    monastery.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.justify,
                  ),

                  const SizedBox(height: 24),

                  // History
                  Text(
                    'History',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    monastery.history,
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.justify,
                  ),

                  const SizedBox(height: 24),

                  // Significance
                  Text(
                    'Significance',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      monastery.significance,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Features
                  Text(
                    'Key Features',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: monastery.features.map((feature) {
                      return Chip(
                        label: Text(feature),
                        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                        labelStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onSecondaryContainer,
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 32),

                  // Bottom spacing for FAB
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Open in maps
          final mapsUrl = 'https://www.google.com/maps/search/?api=1&query=${monastery.lat},${monastery.lng}';
          _launchUrl(mapsUrl);
        },
        icon: const Icon(Icons.directions),
        label: const Text('Get Directions'),
      ),
    );
  }
}