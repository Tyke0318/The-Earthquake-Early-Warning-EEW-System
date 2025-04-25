import 'package:flutter/material.dart';

class EmergencySupplyListScreen extends StatelessWidget {
  final List<Map<String, dynamic>> tools = [
    {
      "category": "生活用品",
      "items": [
        {
          "name": "便携式水净化器",
          "description": "适合户外使用，净水功能强大。",
        },
        {
          "name": "多功能折叠刀具",
          "description": "包含刀、剪、锯等多种工具。",
        },
        {
          "name": "防风打火机",
          "description": "高温强风中也能点燃，防水设计。",
        },
        {
          "name": "露营帐篷",
          "description": "防水、抗风设计，适合各种天气。",
        },
      ],
    },
    {
      "category": "应急用品",
      "items": [
        {
          "name": "急救医药包",
          "description": "包含常用药品及急救工具。",
        },
        {
          "name": "应急手电筒",
          "description": "防水太阳能充电，光照强。",
        },
        {
          "name": "应急保温毯",
          "description": "铝箔材质，防风防水，紧急保暖。",
        },
        {
          "name": "防毒面具",
          "description": "保护呼吸道免受有毒气体侵害。",
        },
        {
          "name": "便携式灭火器",
          "description": "适用于小范围火灾扑灭。",
        },
      ],
    },
    {
      "category": "食品和水",
      "items": [
        {
          "name": "高能量压缩食品",
          "description": "长时间保存，高热量，适合紧急食用。",
        },
        {
          "name": "瓶装水",
          "description": "每人每天需要至少3升水。",
        },
        {
          "name": "应急食物包",
          "description": "含有多种即食食品，方便储备。",
        },
        {
          "name": "饮用水过滤器",
          "description": "过滤河水或雨水，提供饮用水。",
        },
      ],
    },
    {
      "category": "通讯设备",
      "items": [
        {
          "name": "紧急通讯卫星电话",
          "description": "无论在任何地方都能保持通讯。",
        },
        {
          "name": "无线电对讲机",
          "description": "用于群体协作时保持通讯。",
        },
        {
          "name": "太阳能充电宝",
          "description": "太阳能充电，支持设备长时间使用。",
        },
      ],
    },
    {
      "category": "工具与装备",
      "items": [
        {
          "name": "防水背包",
          "description": "防水设计，容量大，适合长时间使用。",
        },
        {
          "name": "紧急雨衣",
          "description": "适用于恶劣天气，快速穿戴。",
        },
        {
          "name": "紧急刀具套件",
          "description": "多功能刀具，适应多种紧急场景。",
        },
        {
          "name": "睡袋",
          "description": "适合低温环境，保温性能强。",
        },
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("List of Emergency Supplies"),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          ),
        ],
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
            // 图标
            Icon(Icons.check_circle_outline, color: const Color.fromARGB(255, 156, 156, 156), size: 24),
            SizedBox(width: 16),
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
