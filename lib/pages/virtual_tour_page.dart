import 'package:flutter/material.dart';

class VirtualTourPage extends StatelessWidget {
  final String? monastery;
  const VirtualTourPage({super.key, this.monastery});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Virtual Tour (Placeholder)')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.vrpano, size: 96),
              const SizedBox(height: 16),
              Text(
                monastery == null
                    ? '360° and 3D experiences will appear here.'
                    : 'Coming soon: 360° tour of \"$monastery\".',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text('This prototype reserves space for panoramic images / Gaussian splats / Unity integration.'),
              const SizedBox(height: 24),
              OutlinedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Placeholder: 360 viewer not integrated in prototype')),
                  );
                },
                child: const Text('Open Sample 360 (placeholder)'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
