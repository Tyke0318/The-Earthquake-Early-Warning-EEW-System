import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';


//  ShelterMapPage implementation
class ShelterMapPage extends StatefulWidget {
  final String shelterName;
  final String shelterLocation;
  final String shelterCoordinates;
  final String userLocation;

  const ShelterMapPage({
    super.key,
    required this.shelterName,
    required this.shelterLocation,
    required this.shelterCoordinates,
    required this.userLocation,
  });

  @override
  State<ShelterMapPage> createState() => _ShelterMapPageState();
}

class _ShelterMapPageState extends State<ShelterMapPage> {
  late LatLng _shelterLocation;
  late LatLng _userLocation;
  final MapController _mapController = MapController();
  late double _zoomLevel;
  bool _mapReady = false;
  late LatLng _mapCenter;

  @override
  void initState() {
    super.initState();
    _initializeLocations();
  }

  void _initializeLocations() {
    try {
      // 处理避难所坐标（支持字符串和数组两种格式）
      // 字符串格式 "lat,lng"
      final coords = (widget.shelterCoordinates).split(',');
      if (coords.length != 2) throw FormatException("Invalid coordinate string");
      _shelterLocation = LatLng(
        double.parse(coords[0].trim()),
        double.parse(coords[1].trim()),
      );
    
      // 处理用户坐标（始终是字符串格式）
      final userCoords = widget.userLocation.split(',');
      if (userCoords.length != 2) throw FormatException("Invalid user coordinates");
      _userLocation = LatLng(
        double.parse(userCoords[0].trim()),
        double.parse(userCoords[1].trim()),
      );

      _calculateMapViewport();
      _mapReady = true;
    } catch (e) {
      debugPrint('Error initializing map: $e');
      // 使用成都默认坐标
      _shelterLocation = const LatLng(30.562186, 104.017371);
      _userLocation = const LatLng(30.562186, 104.017371);
      _mapReady = true;
    }
  }


  void _calculateMapViewport() {
    final bounds = LatLngBounds.fromPoints([_shelterLocation, _userLocation]);
    _mapCenter = bounds.center;

    final distance = const Distance().distance(_shelterLocation, _userLocation);

    if (distance < 10000) { // 10km
      _zoomLevel = 15.0;
    } else if (distance < 50000) { // 50km
      _zoomLevel = 12.0;
    } else {
      _zoomLevel = 8.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shelter Navigation'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Shelter: ${widget.shelterName}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                SizedBox(height: 8),
                Text('Address: ${widget.shelterLocation}'),
                SizedBox(height: 8),
                Text('Coordinates: ${widget.shelterCoordinates}'),
                SizedBox(height: 8),
                Text('Your location: Chengdu (${widget.userLocation})'),
              ],
            ),
          ),
          Expanded(
            child: _mapReady
                ? FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _mapCenter,
                initialZoom: _zoomLevel,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                ),
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: [_userLocation, _shelterLocation],
                      color: Colors.blue,
                      strokeWidth: 3,
                    ),
                  ],
                ),
                MarkerLayer(
                  markers: [
                    // Shelter location marker
                    Marker(
                      point: _shelterLocation,
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
                              'shelter',
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Icon(Icons.location_on, color: Colors.green, size: 30),
                        ],
                      ),
                    ),
                    // User location marker
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

              ],
            )
                : Center(child: Text('Invalid coordinates provided')),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // Here you would implement actual navigation functionality
                // For now just show a dialog
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Navigation Started'),
                    content: Text('Starting navigation to ${widget.shelterName}'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('OK'),
                      ),
                    ],
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text('Start Navigation'),
            ),
          ),
        ],
      ),
    );
  }
}