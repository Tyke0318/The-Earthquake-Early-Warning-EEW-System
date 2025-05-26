import 'package:flutter/material.dart';
import '../data/shelter_data.dart';
import '../3rd_screens/shelter_map_page.dart'; // Import the new map page

class ShelterScreen extends StatelessWidget {
  const ShelterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Emergency Shelter",
            style: TextStyle(fontWeight: FontWeight.w700)
        ),
        // Removed the map icon button from actions
      ),
      body: Column(
        children: [
          _buildEmergencyBanner(),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(bottom: 16),
              itemCount: shelters.length,
              itemBuilder: (context, index) => _buildShelterCard(context, shelters[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyBanner() {
    return Container(
      padding: EdgeInsets.all(12),
      color: Colors.red[50],
      child: Row(
        children: [
          Icon(Icons.warning_amber, color: Colors.orange),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              "Urgent reminder: Please choose the nearest shelter and pay attention to the safety signs along the way",
              style: TextStyle(color: Colors.red[800]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShelterCard(BuildContext context, Map<String, dynamic> shelter) {
    return Card(
      margin: EdgeInsets.fromLTRB(16, 12, 16, 0),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => _showShelterDetail(context, shelter),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: shelter['openStatus'] ? Colors.redAccent : Colors.grey,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      shelter['name'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: shelter['openStatus'] ? null : Colors.grey,
                      ),
                    ),
                  ),
                  if (!shelter['openStatus'])
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        "Temporarily Closed",
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  _buildInfoChip(Icons.directions_walk, "${shelter['distance']}Kilometers"),
                  SizedBox(width: 8),
                  _buildInfoChip(Icons.people, shelter['capacity']),
                ],
              ),
              SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: (shelter['facilities'] as List<String>).map((facility) =>
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        facility,
                        style: TextStyle(fontSize: 12, color: Colors.blue[800]),
                      ),
                    ),
                ).toList(),
              ),
              SizedBox(height: 8),
              if (shelter['openStatus'])
                TextButton.icon(
                  icon: Icon(Icons.directions, size: 18),
                  label: Text("Get Directions"),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.green,
                    padding: EdgeInsets.zero,
                  ),
                  onPressed: () => _navigateToShelter(context, shelter),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        SizedBox(width: 4),
        Text(text, style: TextStyle(fontSize: 14)),
      ],
    );
  }

  void _showShelterDetail(BuildContext context, Map<String, dynamic> shelter) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: EdgeInsets.all(16),
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 60,
                height: 6,
                margin: EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            Text(
              shelter['name'],
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Divider(),
            SizedBox(height: 8),
            _buildDetailRow(Icons.location_on, "Distance", "${shelter['distance']}Kilometers"),
            _buildDetailRow(Icons.people, "Capacity", shelter['capacity']),
            _buildDetailRow(Icons.phone, "Contact", shelter['contact']),
            _buildDetailRow(
              shelter['openStatus'] ? Icons.check_circle : Icons.cancel,
              "Status",
              shelter['openStatus'] ? "Opening" : "Temporarily Closed",
              color: shelter['openStatus'] ? Colors.green : Colors.red,
            ),
            SizedBox(height: 16),
            Text("Facility Services", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: (shelter['facilities'] as List<String>).map((facility) =>
                  Chip(
                    label: Text(facility),
                    backgroundColor: Colors.blue[50],
                    labelStyle: TextStyle(color: Colors.blue[800]),
                  ),
              ).toList(),
            ),
            Spacer(),
            if (shelter['openStatus'])
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  icon: Icon(Icons.directions),
                  label: Text("Get Directions"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    _navigateToShelter(context, shelter);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value, {Color? color}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: color ?? Colors.grey[700], size: 20),
          SizedBox(width: 12),
          Text("$label：", style: TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }

  void _navigateToShelter(BuildContext context, Map<String, dynamic> shelter) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Navigation Tips"),
        content: Text("启动导航至 ${shelter['name']}"),
        actions: [
          TextButton(
            child: Text("取消"),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text("确定"),
            onPressed: () {
              Navigator.pop(context);

              // 检查坐标数据
              if (shelter['coordinates'] == null || shelter['coordinates'].length != 2) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("该避难所缺少有效的坐标数据")),
                );
                return;
              }

              // 转换坐标格式
              final coords = shelter['coordinates'] as List<double>;
              final coordString = "${coords[0]},${coords[1]}";

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ShelterMapPage(
                    shelterName: shelter['name'] ?? "未知避难所",
                    shelterLocation: shelter['address'] ?? "位置信息缺失",
                    shelterCoordinates: coordString,
                    userLocation: "30.558824,104.008704", // 成都坐标
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}