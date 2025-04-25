import 'package:flutter/material.dart';

class ShelterScreen extends StatelessWidget {
  final List<Map<String, dynamic>> shelters = [
    {
      "name": "四川大学江安校区匹兹堡学院新大楼（南校区）",
      "distance": 0.2,
      "capacity": "Capacity: 5,000",
      "facilities": ["Drinking Water", "Temporary Toilets", "Medical Station"],
      "coordinates": [31.2287, 121.4812],
      "contact": "021-11223344",
      "openStatus": true,
    },
    {
      "name": "四川大学江安校区体育场",
      "distance": 0.8,
      "capacity": "Capacity: 2,000",
      "facilities": ["Drinking Water", "Temporary Toilets", "Material Distribution"],
      "coordinates": [31.2287, 121.4812],
      "contact": "021-11223344",
      "openStatus": false, // 临时关闭
    },
    {
      "name": "双流区体育馆应急避难所",
      "distance": 1.2,
      "capacity": "Capacity: 5,000",
      "facilities": ["Medical Station", "Drinking Water", "Temporary Toilets", "Material Distribution"],
      "coordinates": [31.2304, 121.4737],
      "contact": "021-12345678",
      "openStatus": true,
    },
    {
      "name": "成都七中林荫校区操场",
      "distance": 3.4,
      "capacity": "Capacity: 3,000",
      "facilities": ["Medical Station", "Makeshift Tents"],
      "coordinates": [31.2356, 121.4789],
      "contact": "021-87654321",
      "openStatus": true
    },
    {
      "name": "成都石室中学操场应急避难所",
      "distance": 3.8,
      "capacity": "Capacity: 3,000",
      "facilities": ["Medical Station", "Makeshift Tents"],
      "coordinates": [31.2356, 121.4789],
      "contact": "021-87654321",
      "openStatus": true
    },
    {
      "name": "人民公园应急避难所",
      "distance": 8.1,
      "capacity": "Capacity: 2,000",
      "facilities": ["Drinking Water", "Temporary Toilets"],
      "coordinates": [31.2287, 121.4812],
      "contact": "021-11223344",
      "openStatus": false, // 临时关闭
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Emergency Shelter", style: TextStyle(
        fontWeight: FontWeight.w700, // 添加加粗样式
          )
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.map),
            onPressed: () => _openMap(context),
          ),
        ],
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
    // 实际项目中应调用地图API导航
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Navigation Tips"),
        content: Text("Launching navigation to ${shelter['name']}"),
        actions: [
          TextButton(
            child: Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text("Enter"),
            onPressed: () {
              Navigator.pop(context);
              // 这里调用实际的地图导航功能
            },
          ),
        ],
      ),
    );
  }

  void _openMap(BuildContext context) {
    // 实际项目中应显示所有避难所的地图视图
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: Text("Shelter Map")),
          body: Center(child: Text("Map View (Coming Soon)")),
        ),
      ),
    );
  }
}