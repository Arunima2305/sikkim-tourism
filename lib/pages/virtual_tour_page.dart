import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/monastery.dart';
import '../data/monasteries.dart';

class VirtualTourPage extends StatefulWidget {
  final String? monastery;
  const VirtualTourPage({super.key, this.monastery});

  @override
  State<VirtualTourPage> createState() => _VirtualTourPageState();
}

class _VirtualTourPageState extends State<VirtualTourPage> {
  Monastery? _selectedMonastery;
  int _currentPanoramaIndex = 0;
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    if (widget.monastery != null) {
      _selectedMonastery = monasteries.firstWhere(
        (m) => m.name == widget.monastery,
        orElse: () => monasteries.first,
      );
    }
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
  }

  void _nextPanorama() {
    if (_selectedMonastery != null && _selectedMonastery!.panoramaUrls.isNotEmpty) {
      setState(() {
        _currentPanoramaIndex = (_currentPanoramaIndex + 1) % _selectedMonastery!.panoramaUrls.length;
      });
    }
  }

  void _previousPanorama() {
    if (_selectedMonastery != null && _selectedMonastery!.panoramaUrls.isNotEmpty) {
      setState(() {
        _currentPanoramaIndex = _currentPanoramaIndex > 0 
            ? _currentPanoramaIndex - 1 
            : _selectedMonastery!.panoramaUrls.length - 1;
      });
    }
  }

  Widget _buildMonasterySelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select a Monastery for Virtual Tour',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...monasteries.map((monastery) {
            final hasPanoramas = monastery.panoramaUrls.isNotEmpty;
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: hasPanoramas 
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey,
                  child: Icon(
                    hasPanoramas ? Icons.threesixty : Icons.image_not_supported,
                    color: Colors.white,
                  ),
                ),
                title: Text(monastery.name),
                subtitle: Text(
                  hasPanoramas 
                      ? '${monastery.panoramaUrls.length} 360° view${monastery.panoramaUrls.length > 1 ? 's' : ''} available'
                      : 'No 360° views available yet',
                ),
                trailing: hasPanoramas 
                    ? const Icon(Icons.arrow_forward_ios)
                    : null,
                onTap: hasPanoramas ? () {
                  setState(() {
                    _selectedMonastery = monastery;
                    _currentPanoramaIndex = 0;
                  });
                } : null,
                enabled: hasPanoramas,
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPanoramaViewer() {
    if (_selectedMonastery == null || _selectedMonastery!.panoramaUrls.isEmpty) {
      return const Center(
        child: Text('No 360° views available for this monastery'),
      );
    }

    return Stack(
      children: [
        // Panorama Viewer
        PanoramaViewer(
          imageUrl: _selectedMonastery!.panoramaUrls[_currentPanoramaIndex],
          onTap: _toggleControls,
        ),

        // Controls overlay
        if (_showControls) ...[
          // Top bar with title and close button
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.8),
                    Colors.transparent,
                  ],
                ),
              ),
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 8,
                left: 16,
                right: 16,
                bottom: 16,
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _selectedMonastery!.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (_selectedMonastery!.panoramaUrls.length > 1)
                          Text(
                            'View ${_currentPanoramaIndex + 1} of ${_selectedMonastery!.panoramaUrls.length}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _selectedMonastery = null;
                      });
                    },
                    icon: const Icon(Icons.list, color: Colors.white),
                    tooltip: 'Choose another monastery',
                  ),
                ],
              ),
            ),
          ),

          // Navigation arrows for multiple panoramas
          if (_selectedMonastery!.panoramaUrls.length > 1) ...[
            Positioned(
              left: 16,
              top: 0,
              bottom: 0,
              child: Center(
                child: FloatingActionButton(
                  heroTag: "previous",
                  mini: true,
                  onPressed: _previousPanorama,
                  backgroundColor: Colors.black54,
                  child: const Icon(Icons.chevron_left, color: Colors.white),
                ),
              ),
            ),
            Positioned(
              right: 16,
              top: 0,
              bottom: 0,
              child: Center(
                child: FloatingActionButton(
                  heroTag: "next",
                  mini: true,
                  onPressed: _nextPanorama,
                  backgroundColor: Colors.black54,
                  child: const Icon(Icons.chevron_right, color: Colors.white),
                ),
              ),
            ),
          ],

          // Bottom info bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.8),
                    Colors.transparent,
                  ],
                ),
              ),
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom + 16,
                left: 16,
                right: 16,
                top: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.info_outline, color: Colors.white70, size: 16),
                      const SizedBox(width: 8),
                      const Text(
                        'Tap screen to show/hide controls • Drag to look around',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                  if (_selectedMonastery!.panoramaUrls.length > 1)
                    const SizedBox(height: 8),
                  if (_selectedMonastery!.panoramaUrls.length > 1)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _selectedMonastery!.panoramaUrls.asMap().entries.map((entry) {
                        return Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentPanoramaIndex == entry.key
                                ? Colors.white
                                : Colors.white.withOpacity(0.4),
                          ),
                        );
                      }).toList(),
                    ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _selectedMonastery == null 
          ? SingleChildScrollView(child: _buildMonasterySelector())
          : _buildPanoramaViewer(),
    );
  }
}

// Custom PanoramaViewer widget with drag functionality
class PanoramaViewer extends StatefulWidget {
  final String imageUrl;
  final VoidCallback? onTap;

  const PanoramaViewer({
    super.key,
    required this.imageUrl,
    this.onTap,
  });

  @override
  State<PanoramaViewer> createState() => _PanoramaViewerState();
}

class _PanoramaViewerState extends State<PanoramaViewer> {
  double _offsetX = 0.0;
  double _offsetY = 0.0;
  double _scale = 1.0;
  double _baseScale = 1.0;
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onPanUpdate: (details) {
        setState(() {
          // Horizontal panning for 360-degree effect
          _offsetX += details.delta.dx * 2.0; // Multiply for more sensitivity
          
          // Vertical panning with limits
          _offsetY = (_offsetY + details.delta.dy * 2.0).clamp(-500.0, 500.0);
        });
      },
      onScaleStart: (details) {
        _baseScale = _scale;
      },
      onScaleUpdate: (details) {
        setState(() {
          _scale = (_baseScale * details.scale).clamp(0.5, 3.0);
        });
      },
      child: Container(
        width: double.infinity,
        height: double.infinity,
        child: ClipRect(
          child: Transform.scale(
            scale: _scale,
            child: Transform.translate(
              offset: Offset(_offsetX, _offsetY),
              child: CachedNetworkImage(
                imageUrl: widget.imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                placeholder: (context, url) => Container(
                  color: Colors.black,
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: Colors.white),
                        SizedBox(height: 16),
                        Text(
                          'Loading 360° image...',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.black,
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error, size: 64, color: Colors.red),
                        SizedBox(height: 16),
                        Text(
                          'Failed to load 360° image',
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Check your internet connection',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
