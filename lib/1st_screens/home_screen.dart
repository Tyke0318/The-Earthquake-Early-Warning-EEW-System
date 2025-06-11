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
          'https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final converted = convertUSGStoLocalFormat(response.body);
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
  int _selectedIndex = 0;

  // 底部导航栏对应的页面组件列表
  final List<Widget> _pages = [
    MainPage(),     // 首页内容组件
    FindScreen(),   // 搜索页组件
    SettingScreen(),// 设置页组件
  ];

  /// 底部导航栏项目点击事件处理
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
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

/// 首页主要内容组件（修改为StatefulWidget以支持刷新）
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  /// 下拉刷新回调方法
  Future<void> _onRefresh() async {
    try {
      // 触发数据更新
      await _fetchAndUpdateEarthquakeData();
      // 显示刷新成功提示
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('地震数据已更新')),
      );
    } catch (e) {
      // 显示刷新失败提示
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('更新数据失败: $e')),
      );
    }
  }

  /// 复用HomeScreen中的数据获取方法（需确保convertUSGStoLocalFormat已定义）
  Future<void> _fetchAndUpdateEarthquakeData() async {
    try {
      final url = Uri.parse(
          'https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // 解析USGS数据格式（假设convertUSGStoLocalFormat方法存在）
        final converted = convertUSGStoLocalFormat(response.body);
        final dir = await getApplicationDocumentsDirectory();
        final file = File('${dir.path}/quake_data.json');
        await file.writeAsString(jsonEncode(converted));
        debugPrint("✅ 地震数据从USGS更新成功");
      } else {
        debugPrint("❌ 获取USGS数据失败: ${response.statusCode}");
        throw Exception('获取数据失败: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint("⚠️ 获取USGS数据错误: $e");
      rethrow;
    }
  }

  /// 根据震级返回对应的颜色标识
  Color magnitudeToColor(String magnitude) {
    double mag = double.tryParse(magnitude) ?? 0.0;
    if (mag >= 6.0) return Colors.red;
    if (mag >= 4.5) return Colors.orange;
    return Colors.green;
  }

  /// 地震记录列表项组件
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
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                const SizedBox(width: 12),
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
            // 新记录标记
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
                  child: const Text(
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
                      offset: const Offset(0, 4),
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
              // 网格按钮部分
              SizedBox(
                height: 100,
                child: GridView.count(
                  crossAxisCount: 4,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildFeatureButton(
                      context: context,
                      icon: Icons.warning,
                      label: "Alert",
                      destination: AlertScreen(),
                      color: Colors.redAccent,
                    ),
                    _buildFeatureButton(
                      context: context,
                      icon: Icons.place_outlined,
                      label: "Shelters",
                      destination: ShelterScreen(),
                      color: Colors.teal,
                    ),
                    _buildFeatureButton(
                      context: context,
                      icon: Icons.build,
                      label: "Tools",
                      destination: EmergencySupplyListScreen(),
                      color: Colors.orange,
                    ),
                    _buildFeatureButton(
                      context: context,
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

              // 地震记录列表（包裹RefreshIndicator实现下拉刷新）
              Flexible(
                child: RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: FutureBuilder<List<Quake>>(
                    future: _loadQuakeData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error loading data: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('No earthquake data available'));
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
                            index == 0, // 第一条记录标记为NEW
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 功能按钮组件
Widget _buildFeatureButton({
  required BuildContext context,
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
                offset: const Offset(2, 4),
              ),
            ],
          ),
          child: Icon(
            icon,
            color: color,
            size: 28,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}

/// 加载本地地震数据
Future<List<Quake>> _loadQuakeData() async {
  try {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/quake_data.json');

    if (!await file.exists()) {
      throw Exception('File not found');
    }

    final String response = await file.readAsString();

    if (response.trim().isEmpty) {
      throw Exception('File is empty');
    }

    final dynamic data = json.decode(response);
    if (data is! List) {
      throw Exception('Invalid data format - expected List');
    }

    return data.map((json) => Quake.fromJson(json)).toList();
  } catch (e) {
    print('Error loading quake data: $e');
    return [];
  }
}