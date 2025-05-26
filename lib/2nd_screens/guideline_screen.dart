import 'package:flutter/material.dart';
import 'package:eew/data/guide_data.dart';

class GuidelineScreen extends StatelessWidget {
  final List<Map<String, dynamic>> guides = GuideData.guides;


  GuidelineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Emergency Guidelines', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w700,
        )
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black87),
      ),
      body: ListView.builder(
        padding: EdgeInsets.fromLTRB(16, 8, 16, 24),
        itemCount: guides.length,
        itemBuilder: (context, index) => _buildGuideItem(context, guides[index]),
      ),
    );
  }

  Widget _buildGuideItem(BuildContext context, Map<String, dynamic> guide) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showDetailDialog(context, guide),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: guide['color'].withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(guide['icon'], color: guide['color']),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      guide['title'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Icon(Icons.chevron_right, color: Colors.grey),
                ],
              ),
              SizedBox(height: 12),
              Text(
                guide['content'],
                style: TextStyle(height: 1.5),
              ),
              SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: (guide['steps'] as List<String>).take(2).map((step) =>
                    Chip(
                      label: Text(step),
                      backgroundColor: guide['color'].withOpacity(0.1),
                      labelStyle: TextStyle(fontSize: 12),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                ).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDetailDialog(BuildContext context, Map<String, dynamic> guide) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(guide['icon'], color: guide['color']),
            SizedBox(width: 8),
            Text(guide['title']),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(guide['content'], style: TextStyle(height: 1.5)),
              SizedBox(height: 16),
              Text('Detailed Steps：', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              ...(guide['steps'] as List<String>).map((step) =>
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('• ', style: TextStyle(fontSize: 16)),
                        Expanded(child: Text(step)),
                      ],
                    ),
                  ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: Text('Got it!'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}