// import 'package:flutter/material.dart';
// import 'package:real_estate/theme/color.dart';
// import 'package:real_estate/utils/chat_data.dart';
// import 'package:real_estate/widgets/chat_item.dart';
// import 'package:real_estate/widgets/custom_textbox.dart';
// import 'package:real_estate/pages/chat_detail.dart';
//
// class ChatListPage extends StatefulWidget {
//   const ChatListPage({Key? key}) : super(key: key);
//
//   @override
//   _ChatListPageState createState() => _ChatListPageState();
// }
//
// class _ChatListPageState extends State<ChatListPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColor.appBgColor,
//       body: CustomScrollView(
//         slivers: <Widget>[
//           SliverAppBar(
//             backgroundColor: AppColor.appBgColor,
//             pinned: true,
//             snap: true,
//             floating: true,
//             title: _buildHeader(),
//           ),
//           SliverToBoxAdapter(
//             child: _buildBody(),
//           )
//         ],
//       ),
//     );
//   }
//
//   Widget _buildHeader() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         const Text(
//           "Chats",
//           style: TextStyle(
//             color: AppColor.darker,
//             fontSize: 24,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         IconButton(
//           icon: const Icon(Icons.search, color: AppColor.darker),
//           onPressed: () {
//             // 实现搜索功能
//           },
//         ),
//       ],
//     );
//   }
//
//   Widget _buildBody() {
//     return SingleChildScrollView(
//       child: Padding(
//         padding: const EdgeInsets.only(top: 5, bottom: 10),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 15),
//               child: CustomTextBox(
//                 hint: "Search",
//                 prefix: Icon(Icons.search, color: Colors.grey),
//               ),
//             ),
//             const SizedBox(height: 20),
//             _buildChatList(),
//             const SizedBox(height: 100),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildChatList() {
//     return Column(
//       children: List.generate(
//         chatData.length,
//             (index) => ChatItem(
//           data: chatData[index],
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => ChatDetailPage(
//                   chatData: chatData[index],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:real_estate/theme/color.dart';
import 'package:real_estate/services/stream_chat_service.dart';
import 'package:real_estate/widgets/custom_image.dart';
import 'package:real_estate/widgets/custom_textbox.dart';
import 'package:real_estate/pages/chat_detail.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:intl/intl.dart';
import 'package:real_estate/pages/stream_chat_detail.dart'; // 更新导入
import 'package:real_estate/constants.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({Key? key}) : super(key: key);

  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  final _chatService = StreamChatService();
  bool _isLoading = true;
  List<Channel> _channels = [];
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadChannels();
  }

  Future<void> _loadChannels() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      // 检查 Stream 连接状态
      if (_chatService.client.wsConnectionStatus !=
          ConnectionStatus.connected) {
        print("检测到 Stream 未连接，尝试重新连接...");
        try {
          // 重新连接用户 (使用全局变量)
          final token = _chatService.devToken(TEST_USER_ID);
          await _chatService.connectUser(
              TEST_USER_ID, TEST_USER_NAME, TEST_USER_IMAGE, token);
          print("重新连接成功!");
        } catch (e) {
          setState(() {
            _errorMessage = '无法连接到 Stream Chat: $e';
            _isLoading = false;
          });
          return;
        }
      }

      final channels = await _chatService.getChannels();

      setState(() {
        _channels = channels;
        _isLoading = false;
      });
    } catch (e) {
      print("加载频道失败: $e");
      setState(() {
        _errorMessage = '无法加载聊天列表: $e';
        _isLoading = false;
      });
    }
  }

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
      // 创建了一个添加新聊天的悬浮按钮
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCreateChatDialog();
        },
        backgroundColor: AppColor.primary,
        child: Icon(Icons.add, color: Colors.white),
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
            // Search function (Not implemented)
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
                hint: "搜索",
                prefix: Icon(Icons.search, color: Colors.grey),
              ),
            ),
            // 添加创建示例频道按钮（暂时注释，等做好了再加上）
            // if (_channels.isEmpty) // 只有当没有频道时显示
            //   Padding(
            //     padding: const EdgeInsets.all(20),
            //     child: Center(
            //       child: ElevatedButton(
            //         onPressed: _createSampleChannels,
            //         child: Text("Create a Sample Channel"),
            //         style: ElevatedButton.styleFrom(
            //           primary: AppColor.primary,
            //           padding:
            //               EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            //         ),
            //       ),
            //     ),
            //   ),
            const SizedBox(height: 20),
            _buildChatList(),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
  // 然后添加这个方法来创建示例聊天频道
  // Future<void> _createSampleChannels() async {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //
  //   try {
  //     final chatService = StreamChatService();
  //
  //     // 创建房产经纪人聊天
  //     final agentChannel = await chatService.createOneOnOneChat(
  //       'agent_001',
  //       'Sarah Williams',
  //       'https://images.unsplash.com/photo-1544005313-94ddf0286df2',
  //     );
  //
  //     // 发送一些测试消息
  //     await agentChannel.sendMessage(Message(text: '您好！我对您最近查看的房产有兴趣。'));
  //     await agentChannel.sendMessage(Message(text: '这套房子近期有开放日参观吗？'));
  //
  //     // 创建房产咨询聊天
  //     final propertyChannel = await chatService.createPropertyChannel(
  //       'property_12345',
  //       '海滨别墅 #123',
  //       'https://images.unsplash.com/photo-1580587771525-78b9dba3b914',
  //     );
  //
  //     // 发送一些测试消息
  //     await propertyChannel.sendMessage(Message(text: '这套房产的位置非常好，步行5分钟到海滩。'));
  //     await propertyChannel.sendMessage(Message(text: '请问您什么时候有空看房？'));
  //
  //     // 重新加载频道列表
  //     await _loadChannels();
  //
  //   }catch (e) {
  //     setState(() {
  //       _errorMessage = '创建示例聊天失败: $e';
  //       _isLoading = false;
  //     });
  //   }
  // }
  // Future<void> _createSampleChannels() async {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //
  //   try {
  //     final chatService = StreamChatService();
  //
  //     // 创建房产经纪人聊天
  //     final agentChannel = await chatService.createOneOnOneChat(
  //       'agent_001',
  //       'Sarah Williams',
  //       'https://images.unsplash.com/photo-1544005313-94ddf0286df2',
  //     );
  //
  //     // 使用不同的方式发送消息
  //     await agentChannel.sendMessage(Message(
  //       text: '您好！我对您最近查看的房产有兴趣。',
  //     ));
  //
  //     // 第二条消息也使用相同方式
  //     await agentChannel.sendMessage(Message(
  //       text: '这套房子近期有开放日参观吗？',
  //     ));
  //
  //     // 创建房产咨询聊天
  //     final propertyChannel = await chatService.createPropertyChannel(
  //       'property_12345',
  //       '海滨别墅 #123',
  //       'https://images.unsplash.com/photo-1580587771525-78b9dba3b914',
  //     );
  //
  //     // 使用不同的方式发送消息
  //     await propertyChannel.sendMessage(Message(
  //       text: '这套房产的位置非常好，步行5分钟到海滩。',
  //     ));
  //
  //     await propertyChannel.sendMessage(Message(
  //       text: '请问您什么时候有空看房？',
  //     ));
  //
  //     // 重新加载频道列表
  //     await _loadChannels();
  //   } catch (e) {
  //     print("创建示例频道出错: $e"); // 添加详细日志
  //     setState(() {
  //       _errorMessage = '创建示例聊天失败: $e';
  //       _isLoading = false;
  //     });
  //   }
  // }
  // 在创建频道前添加此检查
  void _checkConnectionAndCreateChannel() async {
    final chatService = StreamChatService();

    print("连接状态: ${chatService.client.wsConnectionStatus}");
    print("当前用户: ${chatService.client.state.currentUser?.id}");
    // print("API Key: ${chatService.client.apiKey}");
    print("连接状态: ${chatService.client.wsConnectionStatus}");
    print("当前用户: ${chatService.client.state.currentUser?.id}");

    if (chatService.client.wsConnectionStatus != ConnectionStatus.connected) {
      setState(() {
        _errorMessage = '未连接到Stream，请先连接用户';
      });
      return;
    }

    if (chatService.client.state.currentUser == null) {
      setState(() {
        _errorMessage = '当前没有用户登录';
      });
      return;
    }

    // 如果一切正常，创建频道
    await _createSampleChannels();
  }


  Future<void> _createSampleChannels() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      print("开始创建示例频道...");
      final chatService = StreamChatService();

      // 创建房产经纪人聊天
      print("创建经纪人聊天频道...");
      final agentChannel = await chatService.createOneOnOneChat(
        'agent_001',
        'Sarah Williams',
        'https://images.unsplash.com/photo-1544005313-94ddf0286df2',
      );

      print("经纪人频道创建成功，ID: ${agentChannel.id}");

      // 使用安全的消息发送方法
      print("发送第一条消息...");
      await chatService.sendMessageSafely(
          agentChannel,
          '您好！我对您最近查看的房产有兴趣。'
      );

      print("发送第二条消息...");
      await chatService.sendMessageSafely(
          agentChannel,
          '这套房子近期有开放日参观吗？'
      );

      // 创建房产咨询聊天
      print("创建房产咨询频道...");
      final propertyChannel = await chatService.createPropertyChannel(
        'property_12345',
        '海滨别墅 #123',
        'https://images.unsplash.com/photo-1580587771525-78b9dba3b914',
      );

      print("房产频道创建成功，ID: ${propertyChannel.id}");

      // 使用安全的消息发送方法
      print("发送房产消息...");
      await chatService.sendMessageSafely(
          propertyChannel,
          '这套房产的位置非常好，步行5分钟到海滩。'
      );

      await chatService.sendMessageSafely(
          propertyChannel,
          '请问您什么时候有空看房？'
      );

      // 重新加载频道列表
      print("刷新频道列表...");
      await _loadChannels();

      print("示例频道创建完成！");
    } catch (e) {
      print("创建示例频道出错: $e");
      setState(() {
        _errorMessage = '创建示例聊天失败: $e';
        _isLoading = false;
      });
    }
  }

  Widget _buildChatList() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Text(
          _errorMessage,
          style: TextStyle(color: Colors.red),
        ),
      );
    }

    if (_channels.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Text(
                "暂无聊天记录",
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _loadChannels,
                child: Text("刷新"),
                style: ElevatedButton.styleFrom(
                  primary: AppColor.primary,
                ),
              )
            ],
          ),
        ),
      );
    }

    return Column(
      children: _channels.map((channel) {
        // 提取频道信息
        final name = channel.extraData['name'] as String? ?? '未命名对话';
        final image = channel.extraData['image'] as String? ??
            'https://via.placeholder.com/150';
        final lastMessage = channel.state?.messages.isNotEmpty == true
            ? channel.state!.messages.last.text
            : '暂无消息';
        final lastActive = channel.lastMessageAt ?? channel.createdAt;
        final unreadCount = channel.state?.unreadCount ?? 0;

        return _buildChatItem(
          channel: channel,
          name: name,
          image: image,
          lastMessage: lastMessage ?? '',
          timeAgo: _formatTimeAgo(lastActive),
          unread: unreadCount > 0,
          unreadCount: unreadCount,
        );
      }).toList(),
    );
  }

  Widget _buildChatItem({
    required Channel channel,
    required String name,
    required String image,
    required String lastMessage,
    required String timeAgo,
    required bool unread,
    required int unreadCount,
  }) {
    return GestureDetector(
      onTap: () {
        _navigateToChatDetail(channel);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: AppColor.shadowColor.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            // 头像
            CustomImage(
              image,
              width: 55,
              height: 55,
              radius: 18,
            ),
            const SizedBox(width: 15),
            // 内容
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        timeAgo,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    lastMessage,
                    style: TextStyle(
                      fontSize: 14,
                      color: unread ? AppColor.darker : Colors.grey,
                      fontWeight: unread ? FontWeight.w500 : FontWeight.normal,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Spacer(),
                      if (unread)
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: AppColor.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            unreadCount.toString(),
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToChatDetail(Channel channel) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StreamChatDetailPage(channel: channel),
      ),
    ).then((_) => _loadChannels()); // 返回后刷新列表
  }

  String _formatTimeAgo(DateTime? dateTime) {
    if (dateTime == null) return '刚刚';

    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()}年前';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()}月前';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}天前';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}小时前';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}分钟前';
    } else {
      return '刚刚';
    }
  }

// 显示创建新聊天的对话框
  void _showCreateChatDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController userIdController = TextEditingController();
        final TextEditingController nameController = TextEditingController();

        return AlertDialog(
          title: Text('创建新聊天'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: userIdController,
                decoration: InputDecoration(
                  labelText: '用户ID',
                  hintText: '输入想要聊天的用户ID',
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: '用户名称',
                  hintText: '输入用户名称（可选）',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('取消'),
            ),
            ElevatedButton(
              onPressed: () async {
                final userId = userIdController.text.trim();
                final name = nameController.text.trim();

                if (userId.isNotEmpty) {
                  try {
                    final channel = await _chatService.createOneOnOneChat(
                      userId,
                      name.isNotEmpty ? name : userId,
                      'https://getstream.io/random_svg/?id=$userId&name=${name.isNotEmpty ? name : userId}',
                    );

                    Navigator.pop(context); // 关闭对话框
                    _navigateToChatDetail(channel);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('创建聊天失败: $e')),
                    );
                  }
                }
              },
              child: Text('创建'),
            ),
          ],
        );
      },
    );
  }
}
