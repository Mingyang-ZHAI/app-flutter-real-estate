import 'package:stream_chat/stream_chat.dart';

class StreamChatService {
  static final StreamChatService _instance = StreamChatService._internal();
  factory StreamChatService() => _instance;

  late StreamChatClient client;

  StreamChatService._internal();

  // 初始化客户端
  Future<void> initClient(String apiKey) async {
    client = StreamChatClient(
      apiKey,
      logLevel: Level.INFO,
    );
  }

  // 连接用户
  Future<void> connectUser(String userId, String username, String userImage, String token) async {
    await client.connectGuestUser(
      User(
        id: userId,
        extraData: {
          'name': username,
          'image': userImage,
        },
      ),
      // token,
    );
  }

  // 获取频道列表
  Future<List<Channel>> getChannels() async {
    final filter = Filter.in_('members', [client.state.currentUser!.id]);
    final sort = [SortOption('last_message_at', direction: SortOption.DESC)];

    return await client.queryChannels(
      filter: filter,
      // sort: sort,
      // pagination: PaginationParams(limit: 20),  // 正确: 使用 pagination 参数
      paginationParams: PaginationParams(
        limit: 20
      ),
    ).first;
  }

  // 获取或创建一对一聊天频道
  // Future<Channel> createOneOnOneChat(String otherUserId, String otherUserName, String otherUserImage) async {
  //   final channelId = _getChannelId(client.state.currentUser!.id, otherUserId);
  //
  //   final channel = client.channel(
  //     'messaging',
  //     id: channelId,
  //     extraData: {
  //       'members': [client.state.currentUser!.id, otherUserId],
  //       'name': otherUserName,
  //       'image': otherUserImage,
  //     },
  //   );
  //
  //   await channel.watch();
  //   return channel;
  // }
  // 获取或创建一对一聊天频道
  Future<Channel> createOneOnOneChat(String otherUserId, String otherUserName, String otherUserImage) async {
    if (client.state.currentUser == null) {
      throw Exception('用户未连接，无法创建频道');
    }

    final currentUserId = client.state.currentUser!.id;

    try {
      print("尝试创建频道，当前用户: $currentUserId, 对方用户: $otherUserId");

      // 创建频道 ID 的方法可能有问题，尝试简化
      // final channelId = _getChannelId(currentUserId, otherUserId);
      // 使用简单的格式而不是自定义函数
      final channelId = 'messaging_${currentUserId}_$otherUserId';

      print("使用频道 ID: $channelId");

      // 首先创建频道但不调用 watch
      final channel = client.channel(
        'messaging',
        id: channelId,
        extraData: {
          'members': [currentUserId, otherUserId],
          'name': otherUserName,
          'image': otherUserImage,
        },
      );

      // 先尝试创建频道
      print("尝试创建频道...");
      await channel.create();

      print("创建成功，尝试添加成员...");
      // 添加成员
      await channel.addMembers([currentUserId, otherUserId]);

      print("尝试查询频道...");
      // 使用查询而不是 watch
      await channel.query(
        messagesPagination: PaginationParams(limit: 30),
      );

      return channel;
    } catch (e) {
      print("创建频道出错: $e");
      rethrow;
    }
  }

  // 创建房产咨询频道
  // Future<Channel> createPropertyChannel(String propertyId, String propertyName, String propertyImage) async {
  //   final channel = client.channel(
  //     'messaging',
  //     id: 'property_$propertyId',
  //     extraData: {
  //       'members': [client.state.currentUser!.id],
  //       'name': propertyName,
  //       'image': propertyImage,
  //       'property_id': propertyId,
  //     },
  //   );
  //
  //   await channel.watch();
  //   return channel;
  // }
  // 创建房产咨询频道
  Future<Channel> createPropertyChannel(String propertyId, String propertyName, String propertyImage) async {
    if (client.state.currentUser == null) {
      throw Exception('用户未连接，无法创建频道');
    }

    final currentUserId = client.state.currentUser!.id;

    try {
      print("尝试创建房产频道 propertyId: $propertyId");

      final channelId = 'property_$propertyId';

      // 创建频道
      final channel = client.channel(
        'messaging',
        id: channelId,
        extraData: {
          'members': [currentUserId],
          'name': propertyName,
          'image': propertyImage,
          'property_id': propertyId,
        },
      );

      // 先创建频道
      print("尝试创建房产频道...");
      await channel.create();

      // 添加当前用户为成员
      print("添加成员...");
      await channel.addMembers([currentUserId]);

      // 查询频道
      print("查询频道...");
      await channel.query(
        messagesPagination: PaginationParams(limit: 30),
      );

      return channel;
    } catch (e) {
      print("创建房产频道出错: $e");
      rethrow;
    }
  }

  // 发送消息
  Future<void> sendMessage(Channel channel, String text) async {
    await channel.sendMessage(Message(text: text));
  }

  // 添加安全的消息发送方法
  Future<SendMessageResponse> sendMessageSafely(Channel channel, String text) async {
    try {
      print("准备发送消息: $text");

      // 构建消息
      final message = Message(
        text: text,
        user: client.state.currentUser,
      );

      // 发送消息
      final response = await channel.sendMessage(message);

      print("消息发送成功: ${response.message.id}");
      return response;
    } catch (e) {
      print("发送消息失败: $e");
      rethrow;
    }
  }

  // 创建一致的频道ID
  String _getChannelId(String userId1, String userId2) {
    List<String> ids = [userId1, userId2];
    ids.sort(); // 排序确保相同的两个用户始终得到同样的频道ID
    return 'messaging_${ids[0]}_${ids[1]}';
  }

  // 生成开发用的临时Token (仅供测试，生产环境应从后端获取)
  String devToken(String userId) {
    return client.devToken(userId).rawValue;
  }

  // 添加这个方法到 StreamChatService 类
  Future<bool> reconnectUser() async {
    try {
      if (client.state.currentUser != null) {
        // 尝试使用现有用户重新连接
        await client.connectUser(
          client.state.currentUser!,
          client.devToken(client.state.currentUser!.id).rawValue,
        );
        return true;
      } else {
        print("无法重连: 当前没有用户信息");
        return false;
      }
    } catch (e) {
      print("重连失败: $e");
      return false;
    }
  }

  // 添加一个检查连接状态的方法
  bool isConnected() {
    return client.wsConnectionStatus == ConnectionStatus.connected;
  }
}