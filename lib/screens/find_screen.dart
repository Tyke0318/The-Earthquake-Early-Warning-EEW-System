import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class FindScreen extends StatefulWidget {
  @override
  _FindScreenState createState() => _FindScreenState();
}

class _FindScreenState extends State<FindScreen> {
  List<Map<String, dynamic>> news = [];
  List<Map<String, dynamic>> filteredNews = [];
  String? _searchQuery;
  String? _selectedTag;
  bool _isLoading = true;
  final List<String> _tags = ["All", "News", "Knowledge", "Rescue"];

  @override
  void initState() {
    super.initState();
    _loadNews();
  }

  Future<void> _loadNews() async {
    setState(() => _isLoading = true);
    // 模拟网络请求
    await Future.delayed(Duration(seconds: 1));

    final mockData = [
      {
        "title": "甘肃发生6.3级地震",
        "subtitle": "震中位于陇南市，暂无人员伤亡报告",
        "time": "2025-04-09 19:30",
        "content": "详细报道内容...",
        "source": "中国地震台网",
        "isEmergency": true,
        "tags": ["News"]
      },
      {
        "title": "专家解读近期频发地震",
        "subtitle": "地壳活动仍属正常范围，无需恐慌",
        "time": "2025-04-25 14:15",
        "content": "专家分析内容...",
        "source": "地震科学研究院",
        "isEmergency": false,
        "tags": ["Knowledge"]
      },
      {
        "title": "四川开展地震应急演练",
        "subtitle": "提升民众防灾避险能力",
        "time": "2025-04-07 09:20",
        "content": "演练详情内容...",
        "source": "四川省应急管理厅",
        "isEmergency": false,
        "tags": ["Rescue"]
      },
      {
        "title": "云南发生3.5级地震",
        "subtitle": "震中位于大理市，暂无人员伤亡报告",
        "time": "2025-04-10 08:45",
        "content": "详细报道内容...",
        "source": "中国地震台网",
        "isEmergency": false,
        "tags": ["News"]
      },
      {
        "title": "地震科普知识讲座",
        "subtitle": "专家讲解地震防范知识",
        "time": "2025-04-06 10:00",
        "content": "讲座详情内容...",
        "source": "地震科学研究院",
        "isEmergency": false,
        "tags": ["Knowledge"]
      },
      {
        "title": "青海开展地震应急救援演练",
        "subtitle": "提升救援队伍应急能力",
        "time": "2025-04-05 15:30",
        "content": "演练详情内容...",
        "source": "青海省应急管理厅",
        "isEmergency": false,
        "tags": ["Rescue"]
      },
      {
        "title": "北京发布地震预警",
        "subtitle": "预计地震将在10分钟后到达",
        "time": "2025-04-11 12:00",
        "content": "详细报道内容...",
        "source": "中国地震台网",
        "isEmergency": true,
        "tags": ["News"]
      },
      {
        "title": "地震专家解读地震预警系统",
        "subtitle": "如何正确理解和应对地震预警",
        "time": "2025-04-12 11:00",
        "content": "专家分析内容...",
        "source": "地震科学研究院",
        "isEmergency": false,
        "tags": ["Knowledge"]
      },
      {
        "title": "上海开展地震应急演练",
        "subtitle": "提高城市抗震救灾能力",
        "time": "2025-04-13 09:00",
        "content": "演练详情内容...",
        "source": "上海市应急管理厅",
        "isEmergency": false,
        "tags": ["Rescue"]
      },
      {
        "title": "地震应急救援装备展示",
        "subtitle": "展示最新地震救援设备",
        "time": "2025-04-14 14:00",
        "content": "展示详情内容...",
        "source": "中国地震台网",
        "isEmergency": false,
        "tags": ["Rescue"]
      },
      {
        "title": "地震科普进校园活动",
        "subtitle": "向学生普及地震防范知识",
        "time": "2025-04-15 10:00",
        "content": "活动详情内容...",
        "source": "地震科学研究院",
        "isEmergency": false,
        "tags": ["Knowledge"]
      }
    ];

    setState(() {
      news = mockData;
      filteredNews = _filterNews();
      _isLoading = false;
    });
  }

  List<Map<String, dynamic>> _filterNews() {
    return news.where((item) {
      final matchesSearch = _searchQuery == null ||
          item['title'].toLowerCase().contains(_searchQuery!.toLowerCase()) ||
          item['subtitle'].toLowerCase().contains(_searchQuery!.toLowerCase());

      final matchesTag = _selectedTag == null ||
          _selectedTag == "All" ||
          item['tags'].contains(_selectedTag);

      return matchesSearch && matchesTag;
    }).toList();
  }

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
                ? Colors.red.withOpacity(0.2)
                : Colors.orange.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            news['isEmergency'] ? Icons.warning : Icons.article,
            color: news['isEmergency'] ? Colors.red : Colors.orange,
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
        trailing: IconButton(
          icon: Icon(Icons.share, size: 20),
          onPressed: () => Share.share(
              '${news['title']}\n${news['subtitle']}\n发布于${news['time']}'
          ),
        ),
        onTap: () => _showNewsDetail(context, news),
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      decoration: InputDecoration(
        hintText: "Search for earthquake information...",
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
        automaticallyImplyLeading: false,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          _buildTagFilter(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadNews,
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