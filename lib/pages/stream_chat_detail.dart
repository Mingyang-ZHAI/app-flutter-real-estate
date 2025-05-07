import 'package:flutter/material.dart';
import 'package:real_estate/theme/color.dart';
import 'package:real_estate/services/stream_chat_service.dart';
import 'package:real_estate/widgets/custom_image.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:intl/intl.dart';

class StreamChatDetailPage extends StatefulWidget {
  final Channel channel;

  const StreamChatDetailPage({Key? key, required this.channel}) : super(key: key);

  @override
  _StreamChatDetailPageState createState() => _StreamChatDetailPageState();
}

class _StreamChatDetailPageState extends State<StreamChatDetailPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final _chatService = StreamChatService();
  List<Message> _messages = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMessages();
    _subscribeToMessages();
  }

  Future<void> _loadMessages() async {
    try {
      setState(() {
        _isLoading = true;
      });

      // 获取消息历史
      final channelState = await widget.channel.query(
        messagesPagination: PaginationParams(limit: 30),
      );

      setState(() {
        _messages = channelState.messages;
        _isLoading = false;
      });

      // 标记所有消息为已读
      await widget.channel.markRead();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('加载消息失败: $e');
    }
  }

  void _subscribeToMessages() {
    widget.channel.on('message.new').listen((event) {
      if (event.message != null) {  // 增加空值检查
        setState(() {
          _messages = [..._messages, event.message!];  // 使用非空断言
        });
        // 自动标记为已读
        widget.channel.markRead();
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 获取频道信息
    final name = widget.channel.extraData['name'] as String? ?? '未命名对话';
    final image = widget.channel.extraData['image'] as String? ?? 'https://via.placeholder.com/150';

    return Scaffold(
      backgroundColor: AppColor.appBgColor,
      appBar: AppBar(
        backgroundColor: AppColor.appBgColor,
        elevation: 0,
        title: Row(
          children: [
            CustomImage(
              image,
              width: 40,
              height: 40,
              radius: 15,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: AppColor.darker,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  "在线",
                  style: TextStyle(
                    color: AppColor.secondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
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
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (_messages.isEmpty) {
      return Center(
        child: Text("暂无消息，发送第一条消息开始聊天吧！"),
      );
    }

    // 消息按时间倒序排列
    final sortedMessages = List<Message>.from(_messages)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(15),
      itemCount: sortedMessages.length,
      reverse: true,
      itemBuilder: (context, index) {
        final message = sortedMessages[index];
        final isMe = message.user?.id == _chatService.client.state.currentUser?.id;

        return _buildMessageBubble(
          message: message.text ?? '',
          isMe: isMe,
          time: _formatTime(message.createdAt),
          user: message.user?.name ?? '未知用户',
          userImage: message.user?.image ?? '',
        );
      },
    );
  }

  Widget _buildMessageBubble({
    required String message,
    required bool isMe,
    required String time,
    required String user,
    required String userImage,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isMe) ...[
            CustomImage(
              userImage,
              width: 35,
              height: 35,
              radius: 12,
            ),
            const SizedBox(width: 10),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (!isMe)
                  Text(
                    user,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                const SizedBox(height: 3),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(
                    color: isMe ? AppColor.primary : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.shadowColor.withOpacity(0.05),
                        spreadRadius: 1,
                        blurRadius: 1,
                      ),
                    ],
                  ),
                  child: Text(
                    message,
                    style: TextStyle(
                      color: isMe ? Colors.white : AppColor.darker,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          if (isMe) ...[
            const SizedBox(width: 10),
            CustomImage(
              userImage,
              width: 35,
              height: 35,
              radius: 12,
            ),
          ]
        ],
      ),
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
              onPressed: () {
                // TODO: 实现附件功能
              },
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
                    hintText: "输入消息...",
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.send_rounded, color: AppColor.primary),
              onPressed: _sendMessage,
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage() async {
    if (_messageController.text.isEmpty) return;

    final messageText = _messageController.text;
    _messageController.clear();

    try {
      await _chatService.sendMessage(widget.channel, messageText);
      // 消息发送后会通过订阅接收到，不需要手动添加到列表
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('发送消息失败: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    String timeStr = DateFormat('HH:mm').format(dateTime);

    if (messageDate == today) {
      return timeStr;
    } else if (messageDate == yesterday) {
      return '昨天 $timeStr';
    } else {
      return DateFormat('MM-dd HH:mm').format(dateTime);
    }
  }
}