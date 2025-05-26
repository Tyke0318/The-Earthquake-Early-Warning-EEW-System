import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
/// 信息查询页面 - 用于展示和搜索地震相关信息
class FindScreen extends StatefulWidget {
  const FindScreen({super.key});

  @override
  FindScreenState createState() => FindScreenState();
}

class FindScreenState extends State<FindScreen> {
  // 原始新闻数据列表
  List<Map<String, dynamic>> news = [];

  // 过滤后的新闻数据列表
  List<Map<String, dynamic>> filteredNews = [];

  // 当前搜索关键词
  String? _searchQuery;

  // 当前选中的标签
  String? _selectedTag;

  // 加载状态标识
  bool _isLoading = true;

  // 所有可用标签
  final List<String> _tags = ["All", "快讯", "科普", "救援"];

  @override
  void initState() {

    super.initState();
    _selectedTag = "All";
    _loadNews(); // 初始化时加载数据
  }

  /// 模拟加载新闻数据
  Future<void> _loadNews() async {
    setState(() => _isLoading = true);

    // 模拟网络请求延迟
    await Future.delayed(Duration(seconds: 1));

    // 模拟数据
    final mockData = await loadMockData();

    setState(() {
      news = mockData;
      filteredNews = _filterNews(); // 初始过滤
      _isLoading = false;
    });
  }

  /// 根据搜索词和选中标签过滤新闻
  List<Map<String, dynamic>> _filterNews() {
    return news.where((item) {
      // 匹配搜索条件
      final matchesSearch = _searchQuery == null ||
          item['title'].toLowerCase().contains(_searchQuery!.toLowerCase()) ||
          item['subtitle'].toLowerCase().contains(_searchQuery!.toLowerCase());

      // 匹配标签条件
      final matchesTag = _selectedTag == null ||
          _selectedTag == "All" ||
          item['tags'].contains(_selectedTag);

      return matchesSearch && matchesTag;
    }).toList();
  }

  /// 显示新闻详情页
  void _showNewsDetail(BuildContext context, Map<String, dynamic> news) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: Text(news['title'])),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  news['subtitle'],
                  style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                ),
                SizedBox(height: 16),
                Text(
                  news['content'],
                  style: TextStyle(fontSize: 16, height: 1.6),
                ),
                SizedBox(height: 24),
                Text(
                  "来源：${news['source']}",
                  style: TextStyle(color: Colors.grey),
                ),
                Text(
                  "发布时间：${news['time']}",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 构建标签筛选栏
  Widget _buildTagFilter() {
    return Container(
      height: 48,
      color: Colors.grey[50],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _tags.map((tag) =>
            GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTag = _selectedTag == tag ? null : tag;
                  filteredNews = _filterNews();
                });
              },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: _selectedTag == tag ? Colors.orange : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  tag,
                  style: TextStyle(
                    color: _selectedTag == tag ? Colors.orange : Colors.grey[700],
                    fontWeight: _selectedTag == tag ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
        ).toList(),
      ),
    );
  }

  /// 构建单个新闻条目
  Widget _buildNewsItem(Map<String, dynamic> news) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 1,
      child: ListTile(
        contentPadding: EdgeInsets.all(12),
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: news['isEmergency']
                ? Colors.red
                : Colors.orange,
            shape: BoxShape.circle,
          ),
          child: Icon(
            news['isEmergency'] ? Icons.warning : Icons.article,
            color: Colors.white, // 修改图标颜色为白色
          ),
        ),
        title: Text(
          news['title'],
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: news['isEmergency'] ? Colors.red : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(news['subtitle']),
            SizedBox(height: 4),
            Text(
              news['time'],
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        onTap: () => _showNewsDetail(context, news),
      ),
    );
  }

  /// 构建搜索框
  Widget _buildSearchField() {
    return TextField(
      decoration: InputDecoration(
        hintText: "Search ...",
        border: InputBorder.none,
        prefixIcon: Icon(Icons.search),
        suffixIcon: _searchQuery != null ? IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            setState(() {
              _searchQuery = null;
              filteredNews = _filterNews();
            });
          },
        ) : null,
      ),
      onChanged: (query) {
        setState(() {
          _searchQuery = query;
          filteredNews = _filterNews();
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _buildSearchField(),
        automaticallyImplyLeading: false, // 隐藏返回箭头
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // 加载中显示进度条
          : Column(
        children: [
          _buildTagFilter(), // 标签筛选栏
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadNews, // 下拉刷新
              child: filteredNews.isEmpty
                  ? Center(
                child: Text(
                  _searchQuery != null
                      ? "No relevant information was found"
                      : "No information data available for now",
                  style: TextStyle(color: Colors.grey),
                ),
              )
                  : ListView.builder(
                itemCount: filteredNews.length,
                itemBuilder: (context, index) =>
                    _buildNewsItem(filteredNews[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<List<Map<String, dynamic>>> loadMockData() async {
  try {
    final String response = await rootBundle.loadString('assets/mock_data.json');
    final List<dynamic> data = json.decode(response);
    return data.cast<Map<String, dynamic>>();
  } catch (e) {
    return [];
  }
}