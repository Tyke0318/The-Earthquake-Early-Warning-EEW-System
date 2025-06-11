import 'dart:convert';
class Quake {
  final String magnitude;
  final String location;
  final String time;
  final String depth;
  final String coords;

  Quake({
    required this.magnitude,
    required this.location,
    required this.time,
    required this.depth,
    required this.coords,
  });

  factory Quake.fromJson(Map<String, dynamic> json) {
    return Quake(
      magnitude: json['magnitude'] ?? '',
      location: json['location'] ?? '',
      time: json['time'] ?? '',
      depth: json['depth'] ?? '',
      coords: json['coords'] ?? '',
    );
  }
}


List<Map<String, dynamic>> convertUSGStoLocalFormat(String geoJson) {
  try {
    final data = jsonDecode(geoJson);
    final features = data['features'] as List? ?? [];

    return features.map<Map<String, dynamic>>((feature) {
      try {
        final prop = feature['properties'] ?? {};
        final geom = feature['geometry'] ?? {};

        final double? mag = prop['mag'] is num ? prop['mag'].toDouble() : null;
        final String? location = prop['place'];
        final int? timestamp = prop['time'] is int ? prop['time'] : null;
        final List coords = geom['coordinates'] is List ? geom['coordinates'] : [0, 0, 0];

        return {
          "magnitude": mag?.toStringAsFixed(1) ?? "0.0",
          "location": location ?? "Unknown location",
          "time": _formatUSGSTime(timestamp),
          "depth": "${coords.length >= 3 ? coords[2].toStringAsFixed(0) : '0'} km",
          "coords": "${coords[1].toStringAsFixed(2)}, ${coords[0].toStringAsFixed(2)}",
        };
      } catch (e) {
        print('Error processing feature: $e');
        return {
          "magnitude": "0.0",
          "location": "Error in data",
          "time": "Unknown time",
          "depth": "0 km",
          "coords": "0.00, 0.00",
        };
      }
    }).toList();
  } catch (e) {
    print('Error converting USGS data: $e');
    return [];
  }
}

String _formatUSGSTime(int? millisSinceEpoch) {
  if (millisSinceEpoch == null) return "Unknown time";
  final dateTime = DateTime.fromMillisecondsSinceEpoch(millisSinceEpoch);
  return "${dateTime.year}-${_twoDigits(dateTime.month)}-${_twoDigits(dateTime.day)} "
      "${_twoDigits(dateTime.hour)}:${_twoDigits(dateTime.minute)}:${_twoDigits(dateTime.second)}";
}

String _twoDigits(int n) => n.toString().padLeft(2, '0');
