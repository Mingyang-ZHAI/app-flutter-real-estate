// filepath: /Users/kxzhu/Desktop/workspace_vscode/app-flutter-real-estate/lib/pages/property_detail.dart
import 'package:flutter/material.dart';
import 'package:real_estate/theme/color.dart';
import 'package:real_estate/services/stream_chat_service.dart';
import 'package:real_estate/pages/stream_chat_detail.dart';

class PropertyDetailPage extends StatefulWidget {
  final Map<String, dynamic> property;

  const PropertyDetailPage({Key? key, required this.property})
      : super(key: key);

  @override
  _PropertyDetailPageState createState() => _PropertyDetailPageState();
}

class _PropertyDetailPageState extends State<PropertyDetailPage> {
  // 页面实现...例如map component

  @override
  Widget build(BuildContext context) {
    // 这个方法是必须的
    return Scaffold(
      backgroundColor: AppColor.appBgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          widget.property['name'] ?? "房产详情",
          style: TextStyle(color: AppColor.darker),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColor.darker),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 房产图片
            _buildPropertyImage(),

            // 房产信息
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPropertyInfo(),
                  SizedBox(height: 20),
                  _buildPropertyFeatures(),
                  SizedBox(height: 20),
                  _buildContactButton(), // 添加联系按钮
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 房产图片
  Widget _buildPropertyImage() {
    return Container(
      height: 240,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
              widget.property['image'] ?? 'https://via.placeholder.com/300'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  // 房产基本信息
  Widget _buildPropertyInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.property['name'] ?? "未命名房产",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 5),
        Text(
          widget.property['location'] ?? "位置未知",
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Text(
              widget.property['price'] ?? "\$0",
              style: TextStyle(
                fontSize: 20,
                color: AppColor.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // 房产特点
  Widget _buildPropertyFeatures() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "特点",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildFeatureItem(
                Icons.king_bed, "${widget.property['bedrooms'] ?? 0} 卧室"),
            _buildFeatureItem(
                Icons.bathtub, "${widget.property['bathrooms'] ?? 0} 卫生间"),
            _buildFeatureItem(
                Icons.square_foot, "${widget.property['area'] ?? 0} 平方米"),
          ],
        ),
      ],
    );
  }

  // 特点项
  Widget _buildFeatureItem(IconData icon, String text) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColor.primary),
          SizedBox(height: 5),
          Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  // 联系经纪人按钮
  Widget _buildContactButton() {
    return ElevatedButton(
      onPressed: () async {
        try {
          final chatService = StreamChatService();
          // 创建与该房产相关的聊天频道
          final channel = await chatService.createPropertyChannel(
            widget.property['id'].toString(),
            "关于 ${widget.property['name']}",
            widget.property['image'],
          );

          // 导航到聊天页面
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      StreamChatDetailPage(channel: channel)));
        } catch (e) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('创建聊天失败: $e')));
        }
      },
      style: ElevatedButton.styleFrom(
        // backgroundColor: AppColor.primary,
        primary: AppColor.primary,
        padding: EdgeInsets.symmetric(vertical: 12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline, size: 20),
          SizedBox(width: 8),
          Text('联系经纪人', style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
