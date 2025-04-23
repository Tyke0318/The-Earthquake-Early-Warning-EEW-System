import 'package:flutter/material.dart';
import 'alert_screen.dart';
import 'shelter_screen.dart';
import 'emergency_tools_market_screen.dart';
import 'guideline_screen.dart';
import 'find_screen.dart';
import 'setting_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    MainPage(), // 首页主内容
    FindScreen(),
    SettingScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

// 首页内容封装为 MainPage 组件
class MainPage extends StatelessWidget {
  const MainPage({super.key});

  Color magnitudeToColor(String magnitude) {
    double mag = double.tryParse(magnitude) ?? 0.0;
    if (mag >= 6.0) return Colors.red;
    if (mag >= 4.5) return Colors.orange;
    return Colors.green;
  }

  Widget _quakeItem(String magnitude, String location, String time, String depth, String s) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: magnitudeToColor(magnitude),
            child: Text(magnitude, style: TextStyle(color: Colors.white)),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(location, style: TextStyle(fontWeight: FontWeight.bold)),
                Text("Time：$time"),
                Text("Earthquake focal depths：$depth"),
                Text("longitude, latitude：$s"),


              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Earthquake Early Warning",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center, // 确保文本在每行居中
            ),
            Text(
              "SYSTEM",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 4,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              physics: NeverScrollableScrollPhysics(),
              children: [
                _gridButton(context, Icons.warning, "Mock Alert", AlertScreen()),
                _gridButton(context, Icons.place_outlined, "Emergency Shelters", ShelterScreen()),
                _gridButton(context, Icons.shopping_bag, "Emergency Tools", EmergencyToolsMarketScreen()),
                _gridButton(context, Icons.menu_book, "Safety Guidelines", GuidelineScreen()),
              ],
            ),
            SizedBox(height: 24),
            Text("History Earthquake Record", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            Expanded(
              child: ListView(
                children: [
                  _quakeItem(
                    '3.1',
                    'Xinjiang Kizilsu Prefecture Wushi County',
                    '2024-12-31 16:05:19',
                    '10 km',
                    '75.75°, 39.99°',
                  ),
                  _quakeItem(
                    '3.5',
                    'Xinjiang Kizilsu Prefecture Atushi City',
                    '2024-12-30 05:52:53',
                    '15 km',
                    '77.49°, 40.22°',
                  ),
                  _quakeItem(
                    '4.4',
                    'Taiwan Chiayi County',
                    '2024-12-30 03:51:37',
                    '10 km',
                    '120.66°, 23.54°',
                  ),
                  _quakeItem(
                    '4.3',
                    'Xinjiang Aksu Prefecture Kuche City',
                    '2024-12-29 16:58:47',
                    '15 km',
                    '83.43°, 41.09°',
                  ),
                  _quakeItem(
                    '3.2',
                    'Xinjiang Kizilsu Prefecture Heqixian County',
                    '2024-12-29 06:24:02',
                    '12 km',
                    '78.51°, 41.06°',
                  ),
                  _quakeItem(
                    '6.8',
                    'Qun Dao Islands',
                    '2024-12-27 20:47:35',
                    '180 km',
                    '151.8°, 46.9°',
                  ),
                  _quakeItem(
                    '3',
                    'Xinjiang Kizilsu Prefecture Heqixian County',
                    '2024-12-27 10:34:11',
                    '23 km',
                    '77.71°, 40.75°',
                  ),
                  _quakeItem(
                    '3.3',
                    'Xinjiang Aksu Prefecture Kuche City',
                    '2024-12-27 07:32:36',
                    '20 km',
                    '83.01°, 41.89°',
                  ),
                  _quakeItem(
                    '5.8',
                    'Japan Southeast Offshore',
                    '2024-12-27 05:02:24',
                    '30 km',
                    '142.05°, 30.45°',
                  ),
                  _quakeItem(
                    '3',
                    'Sichuan Yibin City Chang',
                    '2024-12-27 00:17:59',
                    '10 km',
                    '104.89°, 28.36°',
                  ),
                  _quakeItem(
                    '3.1',
                    'Sichuan Luzhou City Longma District',
                    '2024-12-26 17:20:54',
                    '8 km',
                    '105.38°, 29.05°',
                  ),
                  _quakeItem(
                    '4.8',
                    'Taiwan Hualien County Offshore',
                    '2024-12-26 16:08:50',
                    '31 km',
                    '121.9°, 23.97°',
                  ),
                  _quakeItem(
                    '3.8',
                    'Xinjiang Aksu Prefecture Kuche City',
                    '2024-12-26 10:22:52',
                    '17 km',
                    '83.83°, 41.4°',
                  ),
                  _quakeItem(
                    '3.4',
                    'Inner Mongolia Autonomous Region Ar Horqin Left Banner',
                    '2024-12-25 10:11:26',
                    '15 km',
                    '106.62°, 40.04°',
                  ),
                  _quakeItem(
                    '3',
                    'Ningsia Yinchuan City Yongning County',
                    '2024-12-24 20:56:06',
                    '14 km',
                    '106.23°, 38.4°',
                  ),
                  _quakeItem(
                    '2.8',
                    'Ningsia Shizuishan City Pingluo County',
                    '2024-12-24 01:12:45',
                    '20 km',
                    '106.37°, 38.81°',
                  ),
                  _quakeItem(
                    '5.9',
                    'Cuba Southern Offshore',
                    '2024-12-23 14:00:55',
                    '10 km',
                    '-76.5°, 19.8°',
                  ),
                  _quakeItem(
                    '3.1',
                    'Tibet Nyingchi City Mainling County',
                    '2024-12-23 06:37:39',
                    '10 km',
                    '94.95°, 28.82°',
                  ),
                  _quakeItem(
                    '5.5',
                    'United States Alaska South Offshore',
                    '2024-12-22 11:55:59',
                    '10 km',
                    '-154.15°, 55.95°',
                  ),
                  _quakeItem(
                    '3',
                    'Xinjiang Aksu Prefecture Shaya County',
                    '2024-12-22 11:07:30',
                    '10 km',
                    '82.61°, 40.74°',
                  ),
                  _quakeItem(
                    '6.1',
                    'Vanuatu Islands',
                    '2024-12-21 23:30:53',
                    '50 km',
                    '167.95°, -17.75°',
                  ),
                  _quakeItem(
                    '3.4',
                    'Tibet Ali Prefecture Rutog County',
                    '2024-12-21 13:01:58',
                    '10 km',
                    '78.88°, 34.15°',
                  ),
                  _quakeItem(
                    '3',
                    'Xinjiang Aksu Prefecture Baicheng County',
                    '2024-12-21 12:49:03',
                    '10 km',
                    '81.18°, 41.78°',
                  ),
                  _quakeItem(
                    '3.9',
                    'Tibet Lhasa City ',
                    '2024-12-21 02:32:25',
                    '10 km',
                    '92.26°, 29.83°',
                  ),
                  _quakeItem(
                    '3.6',
                    'Inner Mongolia Hulunbuir City Genhe City',
                    '2024-12-19 08:59:37',
                    '18 km',
                    '123.17°, 49.93°',
                  ),
                  _quakeItem(
                    '3.8',
                    'Yunnan Dali Prefecture Bin',
                    '2024-12-19 00:46:41',
                    '10 km',
                    '100.5°, 25.96°',
                  ),
                  _quakeItem(
                    '3.3',
                    'Xinjiang Aksu Prefecture Korla City',
                    '2024-12-18 18:01:05',
                    '17 km',
                    '78.29°, 40.08°',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _gridButton(BuildContext context, IconData icon, String label, Widget page) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 26,
            child: Icon(icon, size: 26),
          ),
          SizedBox(height: 6),
          Text(label, style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
