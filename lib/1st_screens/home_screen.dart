import 'dart:convert';
import 'package:eew/model/quake_model.dart';
import 'dart:io';
// 导入Flutter核心库
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

// 一级页面导入 - 底部导航栏对应的主要页面
import 'find_screen.dart';          // 搜索功能页面
import 'setting_screen.dart';       // 应用设置页面

// 二级页面导入 - 从主页点击进入的功能页面
import '../2nd_screens/alert_screen.dart';                 // 地震警报模拟页面
import '../2nd_screens/shelter_screen.dart';               // 应急避难所信息页面
import '../2nd_screens/emergency_supply_list_screen.dart'; // 应急物资清单页面
import '../2nd_screens/guideline_screen.dart';             // 安全指南页面
import '../2nd_screens/map_page.dart';                     // 地震地图页面

/// 应用主页面，包含底部导航栏结构
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
    _fetchAndUpdateEarthquakeData();
  }
  Future<void> _fetchAndUpdateEarthquakeData() async {
    try {
      final url = Uri.parse(
          'https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_hour.geojson');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // 👇 新解析
        final converted = convertUSGStoLocalFormat(response.body);

        // 📦 写入本地文件
        final dir = await getApplicationDocumentsDirectory();
        final file = File('${dir.path}/quake_data.json');
        await file.writeAsString(jsonEncode(converted));

        debugPrint("✅ Earthquake data updated from USGS");
      } else {
        debugPrint("❌ Failed to fetch USGS data: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("⚠️ Error fetching USGS data: $e");
    }
  }

  // 当前选中的底部导航栏索引
  // 0=首页，1=搜索页，2=设置页
  int _selectedIndex = 0;

  // 底部导航栏对应的页面组件列表
  final List<Widget> _pages = [
    MainPage(),     // 首页内容组件
    FindScreen(),   // 搜索页组件
    SettingScreen(),// 设置页组件
  ];

  /// 底部导航栏项目点击事件处理
  /// [index] 被点击项目的索引
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;  // 更新当前选中索引，触发界面重建
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // 填充安全区域
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Find'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Setting'),
        ],
      ),
    );
  }
}

/// 首页主要内容组件
class MainPage extends StatelessWidget {
  const MainPage({super.key});

  /// 根据震级返回对应的颜色标识
  /// [magnitude] 地震震级字符串
  /// 返回颜色值：
  ///   - ≥6.0：红色（严重）
  ///   - ≥4.5：橙色（中等）
  ///   - 其他：绿色（轻微）
  Color magnitudeToColor(String magnitude) {
    double mag = double.tryParse(magnitude) ?? 0.0;
    if (mag >= 6.0) return Colors.red;
    if (mag >= 4.5) return Colors.orange;
    return Colors.green;
  }

  Widget _quakeItem(BuildContext context, String magnitude, String location,
      String time, String depth, String coords, bool isNew) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EarthquakeMapPage(
              location: location,
              coordinates: coords,
              magnitude: magnitude,
              time: time,
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: magnitudeToColor(magnitude),
                  child: Text(
                      magnitude,
                      style: TextStyle(color: Colors.white, fontSize: 16)
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(location, style: TextStyle(fontWeight: FontWeight.bold)),
                      Text("Time：$time"),
                      Text("Earthquake focal depths：$depth"),
                      Text("longitude, latitude：$coords"),
                    ],
                  ),
                )
              ],
            ),
            // 添加NEW标志
            if (isNew)
              Positioned(
                left: 2,
                top: 5,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "NEW",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 标题部分
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withAlpha((0.3 * 255).round()),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Text(
                        "Earthquake Early Warning",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Welcome to Our EEW System!",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 10),
              // 网格按钮部分 - 使用固定高度
              // 直接替换原来的 GridView.count 部分
              SizedBox(
                height: 100, // 更高点，适应新按钮
                child: GridView.count(
                  crossAxisCount: 4,
                  childAspectRatio: 0.8, // Adjust this value (default is 1.0)
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildFeatureButton(
                      context: context, // 加上这行！
                      icon: Icons.warning,
                      label: "Alert",
                      destination: AlertScreen(),
                      color: Colors.redAccent,
                    ),
                    _buildFeatureButton(
                      context: context, // 加上这行！
                      icon: Icons.place_outlined,
                      label: "Shelters",
                      destination: ShelterScreen(),
                      color: Colors.teal,
                    ),
                    _buildFeatureButton(
                      context: context, // 加上这行！
                      icon: Icons.build,
                      label: "Tools",
                      destination: EmergencySupplyListScreen(),
                      color: Colors.orange,
                    ),
                    _buildFeatureButton(
                      context: context, // 加上这行！
                      icon: Icons.menu_book,
                      label: "Guidelines",
                      destination: GuidelineScreen(),
                      color: Colors.indigo,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),
              const Text(
                "History Earthquake Record",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 14),

              // 地震记录列表 - 使用Flexible替代Expanded
              Flexible(

                child: FutureBuilder<List<Quake>>(
                  future: _loadQuakeData(), // 加载JSON数据的方法
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error loading data'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No earthquake data available'));
                    }

                    final quakeData = snapshot.data!;
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: quakeData.length,
                      itemBuilder: (context, index) {
                        final quake = quakeData[index];
                        return _quakeItem(
                          context,
                          quake.magnitude,
                          quake.location,
                          quake.time,
                          quake.depth,
                          quake.coords,
                          index == 0, // 第一条数据标记为NEW
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildFeatureButton({
  required BuildContext context, // 加在这里！
  required IconData icon,
  required String label,
  required Widget destination,
  required Color color,
}) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => destination),
      );
    },
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withAlpha((0.1 * 255).round()),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withAlpha((0.3 * 255).round()),
                blurRadius: 6,
                offset: Offset(2, 4),
              ),
            ],
          ),
          child: Icon(
            icon,
            color: color,
            size: 28,
          ),
        ),
        SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}

Future<List<Quake>> _loadQuakeData() async {
  try {
    // 获取可写目录
    final dir = await getApplicationDocumentsDirectory();

    final file = File('${dir.path}/quake_data.json');

    // 读取文件内容
    final String response = await file.readAsString();

    // 解析 JSON
    final List<dynamic> data = json.decode(response);

    // 转换为 Quake 对象列表
    return data.map((json) => Quake.fromJson(json)).toList();
  } catch (e) {
    return [];
  }
}