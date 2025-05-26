// 导入Flutter Material库，包含大多数Widget和工具
import 'package:flutter/material.dart';
// 从1st_screens目录导入首页
import '1st_screens/home_screen.dart';

// 应用主入口函数（使用箭头语法简化单行函数）
void main() => runApp(EEWApp());

// 主应用类（无状态Widget）
class EEWApp extends StatelessWidget {
  const EEWApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp是应用根Widget，提供Material Design基础框架
    return MaterialApp(
      // 应用名称（系统识别用）
      title: 'eew',
      
      // 全局主题设置
      theme: ThemeData(
        brightness: Brightness.light,       // 明亮主题
        primarySwatch: Colors.blue,         // 主色调（生成多种蓝色变体）
        scaffoldBackgroundColor: Colors.white,  // 页面背景色
        
        // 应用栏统一样式
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,  // 背景色
          foregroundColor: Colors.black,  // 文字/图标色
          elevation: 1,                  // 阴影高度
        ),
        
        // 底部导航栏统一样式
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.white,    // 背景色
          selectedItemColor: Colors.blue,   // 选中项颜色
          unselectedItemColor: Colors.grey,// 未选中项颜色
        ),
        
        // 默认文本样式
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.black87),  // 正文文本颜色
        ),
      ),

      // 初始页面（首页）
      home: HomeScreen(),

      // 关闭调试标志（右上角DEBUG标签）
      debugShowCheckedModeBanner: false,
    );
  }
}