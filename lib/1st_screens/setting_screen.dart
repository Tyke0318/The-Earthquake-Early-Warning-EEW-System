import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  SettingScreenState createState() => SettingScreenState();
}

class SettingScreenState extends State<SettingScreen> {
  bool soundAlert = true;
  bool popupAlert = true;
  bool vibration = true; // 新增：震动提醒
  bool smartLight = false; // 新增：智能灯提醒
  double warningLevel = 4.0;
  List<String> emergencyContacts = ['+12 345-6789', '', ''];
  final List<TextEditingController> _controllers = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < emergencyContacts.length; i++) {
      _controllers.add(TextEditingController(text: emergencyContacts[i]));
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Warning Settings", style: TextStyle(
          fontWeight: FontWeight.w700,
        )),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(  // 添加这一层包裹
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            SwitchListTile(
              title: Text("Voice Reminder"),
              value: soundAlert,
              onChanged: (val) => setState(() => soundAlert = val),
            ),
            SwitchListTile(
              title: Text("PopUp Reminder"),
              value: popupAlert,
              onChanged: (val) => setState(() => popupAlert = val),
            ),
            // 新增：Vibration 开关
            SwitchListTile(
              title: Text("Vibration Alert"),
              value: vibration,
              onChanged: (val) => setState(() => vibration = val),
            ),
            // 新增：Smart Light 开关
            SwitchListTile(
              title: Text("Smart Light Alert"),
              value: smartLight,
              onChanged: (val) => setState(() => smartLight = val),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Warning level：${warningLevel.toStringAsFixed(1)}"),
                Slider(
                  value: warningLevel,
                  min: 3.0,
                  max: 6.0,
                  divisions: 6,
                  label: warningLevel.toStringAsFixed(1),
                  onChanged: (val) => setState(() => warningLevel = val),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              "Emergency Contacts",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ...List.generate(emergencyContacts.length, (index) {
              return Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: TextField(
                  controller: _controllers[index],
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: "Contact ${index + 1}",
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.save),
                      onPressed: () {
                        setState(() {
                          emergencyContacts[index] = _controllers[index].text;
                          GlobalContacts.contacts[index] = _controllers[index].text;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Contact ${index + 1} saved")),
                        );
                      },
                    ),
                  ),
                  onSubmitted: (value) {
                    setState(() {
                      emergencyContacts[index] = value;
                      GlobalContacts.contacts[index] = value;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Contact ${index + 1} saved")),
                    );
                  },
                ),
              );
            }),
            SizedBox(height: 20), // 添加底部间距，确保键盘弹出后有足够空间
          ],
        ),
      ),
    );
  }
}

class GlobalContacts {
  static List<String> contacts = ['', '', ''];
}