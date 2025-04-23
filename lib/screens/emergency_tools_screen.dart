// emergency_tools_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyToolsScreen extends StatefulWidget {
  @override
  _EmergencyToolsScreenState createState() => _EmergencyToolsScreenState();
}

class _EmergencyToolsScreenState extends State<EmergencyToolsScreen> {
  bool _isFlashlightOn = false;
  bool _isEmergencyCalling = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('应急工具'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Flashlight Tool
            Card(
              elevation: 4,
              child: ListTile(
                leading: Icon(Icons.flash_on, size: 36),
                title: Text('手电筒'),
                trailing: Switch(
                  value: _isFlashlightOn,
                  onChanged: (value) {
                    setState(() {
                      _isFlashlightOn = value;
                      if (_isFlashlightOn) {
                        // Turn screen white to simulate flashlight
                        SystemChrome.setSystemUIOverlayStyle(
                          SystemUiOverlayStyle.light.copyWith(
                            statusBarColor: Colors.white,
                            systemNavigationBarColor: Colors.white,
                          ),
                        );
                      } else {
                        // Restore default theme
                        SystemChrome.setSystemUIOverlayStyle(
                          SystemUiOverlayStyle.dark.copyWith(
                            statusBarColor: Colors.white,
                            systemNavigationBarColor: Colors.white,
                          ),
                        );
                      }
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 20),

            // Emergency Call Tool
            Card(
              elevation: 4,
              child: ListTile(
                leading: Icon(Icons.emergency, size: 36, color: Colors.red),
                title: Text('紧急呼叫'),
                trailing: IconButton(
                  icon: Icon(Icons.phone, color: Colors.red),
                  onPressed: () async {
                    setState(() {
                      _isEmergencyCalling = true;
                    });

                    const url = 'tel:110'; // Emergency number in China
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('无法拨打电话')),
                      );
                    }

                    setState(() {
                      _isEmergencyCalling = false;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 20),

            // Additional tools can be added here
            Card(
              elevation: 4,
              child: ListTile(
                leading: Icon(Icons.volume_up, size: 36),
                title: Text('警报声音'),
                trailing: IconButton(
                  icon: Icon(Icons.play_arrow),
                  onPressed: () {
                    // TODO: Implement alarm sound
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('播放警报声音')),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Ensure flashlight is turned off when leaving
    if (_isFlashlightOn) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: Colors.white,
          systemNavigationBarColor: Colors.white,
        ),
      );
    }
    super.dispose();
  }
}