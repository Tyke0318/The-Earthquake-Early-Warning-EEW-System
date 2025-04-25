import 'package:flutter/material.dart';
import 'package:eer/screens/global_contacts.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool soundAlert = true;
  bool popupAlert = true;
  double warningLevel = 4.0;
  List<String> emergencyContacts = ['+12 345-6789', '', '']; // For storing 3 contact numbers
  final List<TextEditingController> _controllers = [];

  @override
  void initState() {
    super.initState();
    // Initialize controllers
    for (int i = 0; i < emergencyContacts.length; i++) {
      _controllers.add(TextEditingController(text: emergencyContacts[i]));
    }
  }

  @override
  void dispose() {
    // Dispose controllers
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
        fontWeight: FontWeight.w700, // 添加加粗样式
        ),
      ),
        automaticallyImplyLeading: false,
      ),

      body: Padding(
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
                          GlobalContacts.contacts[index] = _controllers[index].text; // 同步到全局
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
                      GlobalContacts.contacts[index] = value; // 同步到全局
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Contact ${index + 1} saved")),
                    );
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}