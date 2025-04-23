import 'package:eer/screens/alert_screen.dart';
import 'package:eer/screens/emergency_tools_screen.dart';
import 'package:eer/screens/shelter_screen.dart';
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/guideline_screen.dart';

void main() => runApp(EEWApp());

class EEWApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Earthquake Early Warning',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
        ),
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.black87),
        ),
      ),
      home: HomeScreen(),
      routes: {

        '/home': (context) => HomeScreen(),
        '/shelter': (context) => ShelterScreen(),
        '/alert': (context) => AlertScreen(),
        '/tools': (context) => EmergencyToolsScreen(),
        '/guideline': (context) => GuidelineScreen(),

      },
      debugShowCheckedModeBanner: false,
    );
  }
}