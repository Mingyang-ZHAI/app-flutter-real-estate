import 'package:flutter/material.dart';
import 'package:real_estate/theme/color.dart';
import 'package:real_estate/widgets/chat_bubble.dart';
import 'package:real_estate/widgets/custom_image.dart';

class ChatDetailPage extends StatefulWidget {
  final Map<String, dynamic> chatData;

  const ChatDetailPage({Key? key, required this.chatData}) : super(key: key);

  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBgColor,
      appBar: AppBar(
        backgroundColor: AppColor.appBgColor,
        elevation: 0,
        title: Row(
          children: [
            CustomImage(
              widget.chatData['image'],
              width: 40,
              height: 40,
              radius: 15,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.chatData['name'],
                  style: TextStyle(
                    color: AppColor.darker,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  widget.chatData['isOnline'] ? 'Online' : 'Offline',
                  style: TextStyle(
                    color: widget.chatData['isOnline'] ? AppColor.secondary : Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.call, color: AppColor.primary),
            onPressed: () {},
          ),
        ],
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColor.darker),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return ListView.builder(
      padding: const EdgeInsets.all(15),
      itemCount: widget.chatData['messages'].length,
      reverse: true,
      itemBuilder: (context, index) {
        final message = widget.chatData['messages'][index];
        return ChatBubble(
          message: message['text'],
          isMe: message['isMe'],
          time: message['time'],
        );
      },
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColor.shadowColor.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(0, -1),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.attach_file, color: AppColor.primary),
              onPressed: () {},
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                height: 45,
                decoration: BoxDecoration(
                  color: AppColor.appBgColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Write a message...",
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.send_rounded, color: AppColor.primary),
              onPressed: () {
                if (_messageController.text.isNotEmpty) {
                  // 发送消息逻辑
                  setState(() {
                    widget.chatData['messages'].insert(0, {
                      'text': _messageController.text,
                      'isMe': true,
                      'time': DateTime.now().toString(),
                    });
                    _messageController.clear();
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}