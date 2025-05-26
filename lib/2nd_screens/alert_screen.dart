import 'dart:async';
import 'package:eew/2nd_screens/guideline_screen.dart';
import 'package:eew/2nd_screens/shelter_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../1st_screens/setting_screen.dart';
import 'map_page.dart';

class AlertScreen extends StatefulWidget {
  const AlertScreen({super.key});

  @override
  AlertScreenState createState() => AlertScreenState();
}

class AlertScreenState extends State<AlertScreen> {
  int _countdown = 30; // 动态倒计时
  double _selectedMagnitude = 3.5; // 默认3.5级
  Timer? _timer;
  Color _warningColor = Colors.green; // 根据预警等级变化的颜色

  @override
  void initState() {
    super.initState();
    startCountdown();
    // 模拟根据震级设置预警颜色
    _setWarningColor(_selectedMagnitude); // 初始化时设置颜色
  }

  // 新增方法：根据震级初始化倒计时
  void _initCountdown() {
    // 停止原有计时器
    _timer?.cancel();

    // 计算倒计时（示例算法：震级越大时间越短）
    final baseTime = 30;
    final magnitudeFactor = _selectedMagnitude.clamp(5.0, 9.0);
    _countdown = (baseTime - (magnitudeFactor * 2)).toInt().clamp(10, 30);

    // 启动新计时器
    startCountdown();

    // 更新颜色
    _setWarningColor(_selectedMagnitude);
  }

  void _setWarningColor(double magnitude) {
    setState(() {
      if (magnitude >= 6.0) {
        _warningColor = Colors.red;
      } else if (magnitude >= 4.5) {
        _warningColor = Colors.orange;
      } else {
        _warningColor = Colors.green;
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
      case 0: // Shelters
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ShelterScreen()),
        );
        break;
      case 1:
        _showEmergencyContacts(context);
        break;
      case 2:
        Navigator.pushNamed(context, '/flashlight');
        break;
      case 3: // Guidelines
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GuidelineScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          children: [
            // 当前位置信息
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 返回按钮
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    color: Colors.grey[600],
                    iconSize: 24,
                    onPressed: () {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                    },
                  ),

                  // 当前位置文字
                  Expanded(
                    child: Text(
                      "双流区四川大学江安校区",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  // 设置按钮
                  IconButton(
                    icon: const Icon(Icons.tune_rounded),
                    color: Colors.grey[600],
                    iconSize: 24,
                    onPressed: _showMagnitudeDialog,
                    tooltip: 'Set the early warning level',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 地震波到达警告
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                decoration: BoxDecoration(
                  color: _warningColor.withAlpha((0.2 * 255).round()),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "Seismic Waves ${_countdown > 0 ? "Incoming" : "Arrived"}",
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
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: _warningColor.withAlpha((0.1 * 255).round()),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _warningColor.withAlpha((0.3 * 255).round())),
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
                  const SizedBox(height: 10),

                  // 地震信息
                  _buildQuakeInfo(
                    magnitude: _selectedMagnitude.toStringAsFixed(1),
                    location: '四川甘孜州白玉县',
                    time: DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()),
                    depth: '8 km',
                    coordinates: '98.92°, 30.90°',
                  ),

                  // 了解详情按钮 - 现在放在地震信息下面，靠右对齐
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _warningColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EarthquakeMapPage(
                                location: 'Chengdu, China',
                                coordinates: '30.2728,104.3668',
                                magnitude: '5.1',
                                time: '2025-05-10 18:03:00',
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          'Go to Map',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
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
                    "Emergency Protocols:",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  _GuidelineText("1. Stay calm and act immediately"),
                  _GuidelineText("2. Avoid windows, hanging objects and tall furniture"),
                  _GuidelineText("3. Do NOT use elevators"),
                  _GuidelineText("4. Shelter under sturdy tables or in corners"),
                ],
              ),
            ),
            const SizedBox(height: 20), // 为底部导航栏留出空间
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
              label: "Shelters",
              onTap: () => _onItemTapped(0),
            ),
            _BottomIcon(
              icon: Icons.contacts_outlined,
              label: "Emergency Call",
              onTap: () => _onItemTapped(1),
            ),
            _BottomIcon(
              icon: Icons.highlight_outlined,
              label: "Flashlight",
              onTap: () => _onItemTapped(2),
            ),
            _BottomIcon(
              icon: Icons.menu_book_outlined,
              label: "Guidelines",
              onTap: () => _onItemTapped(3),
            ),
          ],
        ),
      ),
    );
  }

  // 添加震级选择对话框方法
  void _showMagnitudeDialog() {
    double tempMagnitude = _selectedMagnitude;
    String? errorText; // 错误提示

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Select Warning Magnitude', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w700,
          )
        ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: 'Enter Warning Magnitude',
                      hintText: 'Example: 6.5',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.landscape_rounded),
                      errorText: errorText, // 错误提示
                    ),
                    onChanged: (value) {
                      // 实时验证输入
                      final parsed = double.tryParse(value);
                      if (parsed == null || parsed < 0 || parsed > 12) {
                        setDialogState(() {
                          errorText = 'Please enter a value 0 to 12';
                        });
                      } else {
                        setDialogState(() {
                          tempMagnitude = parsed;
                          errorText = null;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    children: [3.0, 5.0, 7.0].map((mag) {
                      Color chipColor;
                      // 根据震级设置颜色
                      if (mag < 4.5) {
                        chipColor = Colors.green;
                      } else if (mag < 6.0) {
                        chipColor = Colors.orange;
                      } else {
                        chipColor = Colors.red;
                      }
                      return ChoiceChip(
                        label: Text("${mag}M", style: const TextStyle(color: Colors.white)),
                        selected: tempMagnitude == mag,
                        selectedColor: chipColor,
                        backgroundColor: chipColor.withAlpha((0.6 * 255).round()),
                        onSelected: (selected) {
                          if (selected) {
                            setDialogState(() {
                              tempMagnitude = mag;
                              errorText = null; // 清除错误提示
                            });
                          }
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  // 更新主界面状态
                  onPressed: (errorText == null)
                      ? () {
                    setState(() {
                      _selectedMagnitude = tempMagnitude;
                      _setWarningColor(tempMagnitude);
                      _initCountdown(); // 关键：重新初始化倒计时
                    });
                    Navigator.pop(context);
                  }
                      : null, // 输入非法时禁用按钮
                  child: const Text('Enter'),
                ),
              ],
            );
          },
        );
      },
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
          _buildInfoRow('Magnitude', '$magnitude M', minLabelWidth: 100),
          _buildInfoRow('Location', location, minLabelWidth: 100),
          _buildInfoRow('Time', time, minLabelWidth: 100),
          _buildInfoRow('Depth', depth, minLabelWidth: 100),
          _buildInfoRow('Coordinates', coordinates, minLabelWidth: 100),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String title, String value, {double minLabelWidth = 80}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 使用ConstrainedBox确保最小宽度
          ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: minLabelWidth, // 设置最小宽度
              maxWidth: 120, // 设置最大宽度防止过大
            ),
            child: Text(
              '$title:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
                fontSize: 14, // 适当减小字号
              ),
            ),
          ),
          const SizedBox(width: 8), // 增加间距
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 14, // 统一字号
                letterSpacing: 0.3,
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


// 添加弹窗显示方法
void _showEmergencyContacts(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Emergency Contact', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w700,
        )
        ),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: GlobalContacts.contacts.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (context, index) => ListTile(
            title: Text(GlobalContacts.contacts[index].isEmpty
                ? "Not Set Yet"
                : GlobalContacts.contacts[index]),
            trailing: IconButton(
              icon: const Icon(Icons.call, color: Colors.blue),
              onPressed: () {
                if (GlobalContacts.contacts[index].isNotEmpty) {
                  // 这里可以添加模拟拨号逻辑
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Dial ${GlobalContacts.contacts[index]}"))
                  );
                }
              },
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    ),
  );
}