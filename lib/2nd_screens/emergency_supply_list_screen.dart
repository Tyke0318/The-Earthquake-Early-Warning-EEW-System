import 'package:flutter/material.dart';
import 'package:eew/data/tools.dart';
class EmergencySupplyListScreen extends StatelessWidget {
  final List<Map<String, dynamic>> tools = ToolData.tools;

  EmergencySupplyListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Emergency Supplies', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w700,
          )
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: tools.length,
        itemBuilder: (context, index) {
          var category = tools[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 分类标题
              Text(
                category['category'],
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 12),
              // 物品列表
              for (var item in category['items']) ...[
                _buildItemCard(item),
                SizedBox(height: 12),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildItemCard(Map<String, dynamic> item) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      // color: Colors.blue[50], // 设置卡片背景颜色
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [

            // 物品名称和描述
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center, // 居中
                children: [
                  Text(
                    item['name'],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center, // 居中文本
                  ),
                  SizedBox(height: 4),
                  Text(
                    item['description'],
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center, // 居中文本
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
