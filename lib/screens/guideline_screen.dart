import 'package:flutter/material.dart';

class GuidelineScreen extends StatelessWidget {
  final List<Map<String, dynamic>> guides = [
    {
      "title": "地震避险（室内）",
      "content": "在室内遇到地震时，应迅速躲避到坚固的家具旁，避免靠近玻璃窗和外墙。",
      "icon": Icons.home_work,
      "color": Colors.orange,
      "steps": [
        "远离玻璃窗和外墙",
        "躲到承重墙角落",
        "用枕头等保护头部",
        "震动停止后有序撤离"
      ]
    },
    {
      "title": "地震避险（室外）",
      "content": "在室外遇到地震时，应远离建筑物、电线杆等，寻找开阔地带躲避。",
      "icon": Icons.outdoor_grill,
      "color": Colors.orange,
      "steps": [
        "远离建筑物和电线杆",
        "寻找开阔地带",
        "注意避开广告牌等悬挂物",
        "蹲下保护头部"
      ]
    },
    {
      "title": "地震避险（学校）",
      "content": "在学校遇到地震时，应听从老师指挥，迅速躲避到课桌下，保护头部。",
      "icon": Icons.school,
      "color": Colors.orange,
      "steps": [
        "听从老师指挥",
        "躲到课桌下",
        "用书包保护头部",
        "震动停止后有序撤离"
      ]
    },
    {
      "title": "暴雨防范",
      "content": "暴雨天气应避免外出，远离积水区域，注意防范山洪和泥石流。",
      "icon": Icons.water,
      "color": Colors.blue,
      "steps": [
        "避免外出",
        "远离积水区域",
        "注意山洪泥石流",
        "准备防水用品"
      ]
    },
    {
      "title": "雷电防护",
      "content": "雷电天气应避免在户外停留，远离高大树木和电线杆，关闭电器设备。",
      "icon": Icons.flash_on,
      "color": Colors.yellow,
      "steps": [
        "避免在户外停留",
        "远离高大树木",
        "关闭电器设备",
        "待在室内安全区域"
      ]
    },
    {
      "title": "泥石流逃生",
      "content": "遇到泥石流时，应迅速向两侧山坡逃生，避免顺沟方向逃离。",
      "icon": Icons.terrain,
      "color": Colors.brown,
      "steps": [
        "向两侧山坡逃生",
        "避免顺沟方向逃离",
        "远离泥石流堆积区",
        "注意观察周围环境"
      ]
    },
    {
      "title": "滑坡避险",
      "content": "遇到滑坡时，应迅速向滑坡两侧逃离，避免在滑坡下方停留。",
      "icon": Icons.terrain,
      "color": Colors.brown,
      "steps": [
        "向滑坡两侧逃离",
        "避免在滑坡下方停留",
        "注意观察滑坡迹象",
        "远离滑坡危险区"
      ]
    },
    {
      "title": "海啸防范",
      "content": "海啸预警时，应迅速向高地或内陆转移，避免靠近海岸线。",
      "icon": Icons.beach_access,
      "color": Colors.blue,
      "steps": [
        "听到预警迅速撤离",
        "向高地或内陆转移",
        "避免靠近海岸线",
        "关注官方信息"
      ]
    },
    {
      "title": "燃气泄漏处理",
      "content": "发现燃气泄漏时，应迅速关闭燃气阀门，打开门窗通风，避免使用明火和电器。",
      "icon": Icons.gas_meter,
      "color": Colors.red,
      "steps": [
        "关闭燃气阀门",
        "打开门窗通风",
        "避免使用明火",
        "撤离现场并报警"
      ]
    },
    {
      "title": "触电急救",
      "content": "发现有人触电时，应迅速切断电源，使用绝缘物将触电者与电源分离，进行急救。",
      "icon": Icons.electrical_services,
      "color": Colors.yellow,
      "steps": [
        "迅速切断电源",
        "使用绝缘物分离",
        "进行心肺复苏",
        "拨打急救电话"
      ]
    },
    {
      "title": "溺水救援",
      "content": "发现有人溺水时，应立即呼救，使用救生设备施救，避免盲目下水。",
      "icon": Icons.pool,
      "color": Colors.blue,
      "steps": [
        "立即呼救",
        "使用救生设备",
        "避免盲目下水",
        "拨打急救电话"
      ]
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('避险指南', style: TextStyle(color: Colors.black87)),
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
              Text('具体步骤：', style: TextStyle(fontWeight: FontWeight.bold)),
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
            child: Text('知道了'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}