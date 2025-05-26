import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class EarthquakeMapPage extends StatefulWidget {
  final String location;
  final String coordinates;
  final String magnitude;
  final String time;

  const EarthquakeMapPage({
    super.key,
    required this.location,
    required this.coordinates,
    required this.magnitude,
    required this.time,
  });

  @override
  State<EarthquakeMapPage> createState() => _EarthquakeMapPageState();
}

class _EarthquakeMapPageState extends State<EarthquakeMapPage> with SingleTickerProviderStateMixin {
  late final LatLng _earthquakeLocation;
  final LatLng _userLocation = const LatLng(30.56166, 104.017627);
  final MapController _mapController = MapController();

  bool _mapReady = false;
  late LatLng _mapCenter;
  late double _zoomLevel;

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    try {
      final coords = widget.coordinates.split(',');
      final lat = _parseCoordinate(coords[0]);
      final lng = _parseCoordinate(coords[1]);
      _earthquakeLocation = LatLng(lat, lng);
      _calculateViewport();
      _mapReady = true;

      // Initialize animation controller
      _animationController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 3),
      )..repeat();

      _animation = Tween(begin: 0.0, end: 1.0).animate(_animationController);

    } catch (e) {
      _earthquakeLocation = LatLng(0.0, 0.0);
      debugPrint('Invalid coordinates: $e');
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  double _parseCoordinate(String coord) {
    coord = coord.toUpperCase().replaceAll(RegExp(r'[^\d\.\-]'), '');
    return double.parse(coord);
  }

  void _calculateViewport() {
    final bounds = LatLngBounds.fromPoints([_earthquakeLocation, _userLocation]);
    _mapCenter = bounds.center;

    final distance = const Distance().distance(_earthquakeLocation, _userLocation);
    if (distance < 10000) {
      _zoomLevel = 12;
    } else if (distance < 50000) {
      _zoomLevel = 10;
    } else if (distance < 200000) {
      _zoomLevel = 8;
    } else if (distance < 1000000) {
      _zoomLevel = 6;
    } else if (distance < 5000000) {
      _zoomLevel = 4;
    } else {
      _zoomLevel = 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Earthquake Details', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w700,
            )
          )
        ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Info section
            Expanded(
              child: _mapReady
                  ? Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 6,
                clipBehavior: Clip.antiAlias,
                child: FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _mapCenter,
                    initialZoom: _zoomLevel,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: _userLocation,
                          width: 80,
                          height: 70,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                                child: const Text(
                                  'You',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const Icon(Icons.location_on, color: Colors.blue, size: 30),
                            ],
                          ),
                        ),
                      ],
                    ),
                    CircleLayer(
                      circles: [
                        CircleMarker(
                          point: _earthquakeLocation,
                          radius: 10,
                          color: Colors.red.withOpacity(0.8),
                          borderColor: Colors.red,
                          borderStrokeWidth: 2,
                        ),
                      ],
                    ),
                    // Ripple effect layer
                    AnimatedCircleLayer(animation: _animation, epicenter: _earthquakeLocation),
                  ],
                ),
              )
                  : const Center(
                child: Text(
                  '❌ Invalid coordinates provided.',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
            const SizedBox(height: 16),

            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow(Icons.location_on, 'Location: ${widget.location}'),
                      _buildInfoRow(Icons.language, 'Coordinates: ${widget.coordinates}'),
                      _buildInfoRow(Icons.warning_amber, 'Magnitude: ${widget.magnitude}'),
                      _buildInfoRow(Icons.access_time, 'Time: ${widget.time}'),
                      _buildInfoRow(Icons.person_pin_circle, 'Your Location: $_userLocation'),
                    ],
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueGrey),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }
}

class AnimatedCircleLayer extends StatelessWidget {
  final Animation<double> animation;
  final LatLng epicenter;

  const AnimatedCircleLayer({
    super.key,
    required this.animation,
    required this.epicenter,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return CircleLayer(
          circles: [
            // First ripple
            CircleMarker(
              point: epicenter,
              radius: 30 * animation.value,
              color: Colors.red.withOpacity(1 - animation.value * 0.7),
              borderColor: Colors.red.withOpacity(1 - animation.value),
              borderStrokeWidth: 2,
            ),
            // Second ripple (delayed)
            if (animation.value > 0.33)
              CircleMarker(
                point: epicenter,
                radius: 30 * (animation.value - 0.33) / 0.67,
                color: Colors.red.withOpacity(0.7 - (animation.value - 0.33) * 0.7),
                borderColor: Colors.red.withOpacity(0.7 - (animation.value - 0.33)),
                borderStrokeWidth: 2,
              ),
            // Third ripple (more delayed)
            if (animation.value > 0.66)
              CircleMarker(
                point: epicenter,
                radius: 30 * (animation.value - 0.66) / 0.34,
                color: Colors.red.withOpacity(0.4 - (animation.value - 0.66) * 0.4),
                borderColor: Colors.red.withOpacity(0.4 - (animation.value - 0.66)),
                borderStrokeWidth: 2,
              ),
          ],
        );
      },
    );
  }
}