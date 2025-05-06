import 'package:flutter/material.dart';
import 'package:real_estate/theme/color.dart';
import 'package:real_estate/utils/chat_data.dart';
import 'package:real_estate/widgets/chat_item.dart';
import 'package:real_estate/widgets/custom_textbox.dart';
import 'package:real_estate/pages/chat_detail.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({Key? key}) : super(key: key);

  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBgColor,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: AppColor.appBgColor,
            pinned: true,
            snap: true,
            floating: true,
            title: _buildHeader(),
          ),
          SliverToBoxAdapter(
            child: _buildBody(),
          )
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Chats",
          style: TextStyle(
            color: AppColor.darker,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.search, color: AppColor.darker),
          onPressed: () {
            // 实现搜索功能
          },
        ),
      ],
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 5, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: CustomTextBox(
                hint: "Search",
                prefix: Icon(Icons.search, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 20),
            _buildChatList(),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildChatList() {
    return Column(
      children: List.generate(
        chatData.length,
            (index) => ChatItem(
          data: chatData[index],
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatDetailPage(
                  chatData: chatData[index],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}