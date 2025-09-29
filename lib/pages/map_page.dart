import 'dart:math' show min;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';
import '../data/monasteries.dart';
import '../services/location_service.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  LatLng? _userLatLng;
  double _radiusKm = 15; // change radius to taste
  final _mapController = MapController();
  final _distance = const Distance(); // from latlong2

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    final pos = await LocationService.getCurrent();
    if (pos != null && mounted) {
      setState(() => _userLatLng = LatLng(pos.latitude, pos.longitude));
      // Soft-center map to user
      _mapController.move(_userLatLng!, 12);
    }
  }

  List<_NearbyItem> _nearby() {
    if (_userLatLng == null) return const [];
    return monasteries
        .map((m) {
          final d = _distance.as(
            LengthUnit.Kilometer,
            _userLatLng!,
            LatLng(m.lat, m.lng),
          );
          return _NearbyItem(name: m.name, district: m.district, lat: m.lat, lng: m.lng, km: d);
        })
        .where((x) => x.km <= _radiusKm)
        .toList()
      ..sort((a, b) => a.km.compareTo(b.km));
  }

  @override
  Widget build(BuildContext context) {
    final sikkimCenter = const LatLng(27.3389, 88.6065);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sikkim Monasteries'),
        actions: [
          IconButton(
            tooltip: 'My Location',
            onPressed: _initLocation,
            icon: const Icon(Icons.my_location),
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: sikkimCenter,
              initialZoom: 8.8,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c'],
                userAgentPackageName: 'com.example.sikkim_tourism_prototype',
              ),
              // Monastery markers
              MarkerLayer(
                markers: monasteries.map((m) {
                  return Marker(
                    point: LatLng(m.lat, m.lng),
                    width: 40,
                    height: 40,
                    child: GestureDetector(
                      onTap: () => _openMonasterySheet(name: m.name, district: m.district),
                      child: const Icon(Icons.location_on, size: 36),
                    ),
                  );
                }).toList(),
              ),
              // Live location marker (blue dot + heading)
              CurrentLocationLayer(
                // Defaults are fine; shows a pulsing blue marker.
                // See package docs to customize if you want.
              ),
              // Show a circle around user location for "nearby" radius
              if (_userLatLng != null)
                CircleLayer(circles: [
                  CircleMarker(
                    point: _userLatLng!,
                    useRadiusInMeter: true,
                    radius: (_radiusKm * 1000),
                    color: Colors.green.withOpacity(0.08),
                    borderColor: Colors.green.withOpacity(0.25),
                    borderStrokeWidth: 2,
                  ),
                ]),
            ],
          ),

          // Nearby panel
          Positioned(
            left: 12,
            right: 12,
            bottom: 16,
            child: _NearbyPanel(
              enabled: _userLatLng != null,
              radiusKm: _radiusKm,
              onRadiusChanged: (v) => setState(() => _radiusKm = v),
              items: _nearby(),
              onTapItem: (item) {
                _mapController.move(LatLng(item.lat, item.lng), 14);
                _openMonasterySheet(name: item.name, district: item.district);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _openMonasterySheet({required String name, required String district}) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) => _MonasterySheet(name: name, district: district),
    );
  }
}

class _MonasterySheet extends StatelessWidget {
  final String name;
  final String district;

  const _MonasterySheet({required this.name, required this.district});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 6),
          Text('District: $district'),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () => Navigator.pushNamed(context, '/book', arguments: name),
            child: const Text('Book a Guide for this Monastery'),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () => Navigator.pushNamed(context, '/tour', arguments: name),
            child: const Text('Open Virtual Tour (Placeholder)'),
          ),
        ],
      ),
    );
  }
}

class _NearbyItem {
  final String name;
  final String district;
  final double lat;
  final double lng;
  final double km;

  _NearbyItem({
    required this.name,
    required this.district,
    required this.lat,
    required this.lng,
    required this.km,
  });
}

class _NearbyPanel extends StatelessWidget {
  final bool enabled;
  final double radiusKm;
  final ValueChanged<double> onRadiusChanged;
  final List<_NearbyItem> items;
  final ValueChanged<_NearbyItem> onTapItem;

  const _NearbyPanel({
    required this.enabled,
    required this.radiusKm,
    required this.onRadiusChanged,
    required this.items,
    required this.onTapItem,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Icon(Icons.near_me_outlined),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    enabled ? 'Nearby monasteries (${items.length})' : 'Enable location to see nearby',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                // Radius selector (8–30 km)
                DropdownButton<double>(
                  value: radiusKm,
                  onChanged: (v) => onRadiusChanged(v ?? radiusKm),
                  items: const [8, 12, 15, 20, 25, 30]
                      .map((e) => DropdownMenuItem(value: e.toDouble(), child: Text('${e} km')))
                      .toList(),
                ),
              ],
            ),
            if (enabled)
              Flexible(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 180),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (_, i) {
                      final it = items[i];
                      return ListTile(
                        dense: true,
                        title: Text(it.name),
                        subtitle: Text('${it.district} • ${it.km.toStringAsFixed(1)} km'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () => onTapItem(it),
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
