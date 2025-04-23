import 'package:flutter/material.dart';

class EmergencyToolsMarketScreen extends StatelessWidget {
  final List<Map<String, dynamic>> tools = [
    {
      "name": "多功能应急手电筒",
      "price": 29.0,
      "originalPrice": 39.0,
      "rating": 4.8,
      "sales": 1250,
      "icon": Icons.flashlight_on,
      "features": ["防水", "太阳能充电", "破窗器"],
      "image": "assets/多功能应急手电筒.jpg"
    },
    {
      "name": "高频救援哨子",
      "price": 12.0,
      "originalPrice": 15.0,
      "rating": 4.5,
      "sales": 890,
      "icon": Icons.volume_up,
      "features": ["120分贝", "防滑设计", "便携挂绳"],
      "image": "assets/whistle.jpg"
    },
    {
      "name": "专业急救医药包",
      "price": 49.0,
      "originalPrice": 69.0,
      "rating": 4.9,
      "sales": 2100,
      "icon": Icons.medical_services,
      "features": ["30件套", "防水包装", "使用指南"],
      "image": "assets/first_aid.jpg"
    },
    {
      "name": "应急保温毯",
      "price": 8.0,
      "originalPrice": 12.0,
      "rating": 4.3,
      "sales": 650,
      "icon": Icons.night_shelter,
      "features": ["铝箔材质", "防风防水", "可重复使用"],
      "image": "assets/blanket.jpg"
    },
  ];

EmergencyToolsMarketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("应急工具商城"),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => _showSearchDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildPromoBanner(),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 8),
              itemCount: tools.length,
              itemBuilder: (context, index) => _buildProductCard(context, tools[index]),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.shopping_cart),
        onPressed: () => _showCart(context),
      ),
    );
  }

  Widget _buildPromoBanner() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orangeAccent, Colors.deepOrange],
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.local_offer, color: Colors.white),
          SizedBox(width: 8),
          Expanded(
            child: Text(
                "应急物资特惠 | 满¥100包邮 | 新用户首单9折",
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, Map<String, dynamic> product) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showProductDetail(context, product),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 商品图片
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: AssetImage(product['image']),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 12),
              // 商品信息
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product['name'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          "¥${product['price']}",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          "¥${product['originalPrice']}",
                          style: TextStyle(
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 16),
                        Text(" ${product['rating']}"),
                        SizedBox(width: 8),
                        Text("销量 ${product['sales']}"),
                      ],
                    ),
                    SizedBox(height: 4),
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: (product['features'] as List<String>).map((feature) =>
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              feature,
                              style: TextStyle(fontSize: 12, color: Colors.blue[800]),
                            ),
                          ),
                      ).toList(),
                    ),
                  ],
                ),
              ),
              // 购物车按钮
              IconButton(
                icon: Icon(Icons.add_shopping_cart, color: Colors.green),
                onPressed: () => _addToCart(context, product),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showProductDetail(BuildContext context, Map<String, dynamic> product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: EdgeInsets.all(16),
        height: MediaQuery.of(context).size.height * 0.8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(product['image']),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              product['name'],
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Text(
                  "¥${product['price']}",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  "¥${product['originalPrice']}",
                  style: TextStyle(
                    color: Colors.grey,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                Spacer(),
                Text(
                  "已售 ${product['sales']}件",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.star, color: Colors.amber),
                Text(" ${product['rating']}分"),
                SizedBox(width: 16),
                ...List.generate(5, (index) =>
                    Icon(
                      index < product['rating'].floor() ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 20,
                    ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text("产品特点", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Column(
              children: (product['features'] as List<String>).map((feature) =>
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.check_circle, color: Colors.green, size: 16),
                        SizedBox(width: 8),
                        Expanded(child: Text(feature)),
                      ],
                    ),
                  ),
              ).toList(),
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: Text("加入购物车", style: TextStyle(fontSize: 18)),
                onPressed: () {
                  Navigator.pop(context);
                  _addToCart(context, product);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addToCart(BuildContext context, Map<String, dynamic> product) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("已添加 ${product['name']} 到购物车"),
        action: SnackBarAction(
          label: "查看",
          onPressed: () => _showCart(context),
        ),
      ),
    );
  }

  void _showCart(BuildContext context) {
    // 实际项目中这里应该导航到购物车页面
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("购物车"),
        content: Text("购物车功能开发中，敬请期待"),
        actions: [
          TextButton(
            child: Text("好的"),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("搜索应急工具"),
        content: TextField(
          decoration: InputDecoration(
            hintText: "输入工具名称...",
            prefixIcon: Icon(Icons.search),
          ),
        ),
        actions: [
          TextButton(
            child: Text("取消"),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text("搜索"),
            onPressed: () {
              // 实际项目中执行搜索逻辑
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}