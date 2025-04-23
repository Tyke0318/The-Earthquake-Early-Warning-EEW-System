import 'dart:async';
import 'package:flutter/material.dart';

class AlertScreen extends StatefulWidget {
  const AlertScreen({super.key});

  @override
  _AlertScreenState createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen> {
  int _countdown = 20;
  Timer? _timer;
  Color _warningColor = Colors.orange; // 根据预警等级变化的颜色

  @override
  void initState() {
    super.initState();
    startCountdown();
    // 模拟根据震级设置预警颜色
    _setWarningColor(5.0);
  }

  void _setWarningColor(double magnitude) {
    setState(() {
      if (magnitude >= 7.0) {
        _warningColor = Colors.red;
      } else if (magnitude >= 5.0) {
        _warningColor = Colors.orange;
      } else {
        _warningColor = Colors.yellow;
      }
    });
  }

  void startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        if (_countdown > 0) {
          _countdown--;
        } else {
          timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/shelter');
        break;
      case 1:
        Navigator.pushNamed(context, '/emergency');
        break;
      case 2:
        Navigator.pushNamed(context, '/flashlight');
        break;
      case 3:
        Navigator.pushNamed(context, '/guideline');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // 当前位置信息
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "当前位置",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 地震波到达警告
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                decoration: BoxDecoration(
                  color: _warningColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "地震波 ${_countdown > 0 ? "即将到达" : "已到达"}",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: _warningColor,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 中央大矩形区域 - 倒计时和地震信息
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  color: _warningColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _warningColor.withOpacity(0.3)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 倒计时显示
                    Text(
                      _countdown.toString(),
                      style: TextStyle(
                        fontSize: 80,
                        fontWeight: FontWeight.bold,
                        color: _warningColor,
                      ),
                    ),
                    const Text(
                      "秒",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 30),

                    // 地震信息
                    _buildQuakeInfo(
                      magnitude: '8.0',
                      location: '四川成都模拟震中',
                      time: '2025-04-14 14:30',
                      depth: '15 km',
                      coordinates: '104.06°, 30.67°',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 避险建议
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "避险建议:",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 10),
                  _GuidelineText("1. 保持冷静，迅速采取避险措施"),
                  _GuidelineText("2. 远离窗户、悬挂物和高大家具"),
                  _GuidelineText("3. 不要使用电梯"),
                  _GuidelineText("4. 选择坚固的桌子下或内墙角躲避"),
                ],
              ),
            ),

            const SizedBox(height: 20),

          ],
        ),
      ),

      // 底部导航栏
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey[200]!)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _BottomIcon(
              icon: Icons.place_outlined,
              label: "避难场所",
              onTap: () => _onItemTapped(0),
            ),
            _BottomIcon(
              icon: Icons.contacts_outlined,
              label: "紧急联系人",
              onTap: () => _onItemTapped(1),
            ),
            _BottomIcon(
              icon: Icons.highlight_outlined,
              label: "手电筒",
              onTap: () => _onItemTapped(2),
            ),
            _BottomIcon(
              icon: Icons.menu_book_outlined,
              label: "避险指南",
              onTap: () => _onItemTapped(3),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuakeInfo({
    required String magnitude,
    required String location,
    required String time,
    required String depth,
    required String coordinates,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildInfoRow('震级', '$magnitude级'),
          _buildInfoRow('位置', location),
          _buildInfoRow('时间', time),
          _buildInfoRow('深度', depth),
          _buildInfoRow('坐标', coordinates),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 60,
            child: Text(
              '$title:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 避险指南文本组件
class _GuidelineText extends StatelessWidget {
  final String text;

  const _GuidelineText(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 底部图标组件
class _BottomIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _BottomIcon({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 28, color: Colors.blue),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.blue),
          ),
        ],
      ),
    );
  }
}