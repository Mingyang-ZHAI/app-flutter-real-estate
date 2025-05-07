import 'package:flutter/material.dart';
import 'pages/root.dart';
import 'theme/color.dart';
import 'package:real_estate/services/stream_chat_service.dart';
import 'package:real_estate/constants.dart';// Added by kzhu. Used for Stream Chat

// Added by kzhu. Used for Stream Chat
// 测试用户ID，实际应用中应从用户登录系统获取
const String STREAM_API_KEY = 'wupwtqb96k69'; // Stream API Key
const String TEST_USER_ID = 'test_user';
const String TEST_USER_NAME = 'TestUser';
const String TEST_USER_IMAGE = 'https://getstream.io/random_svg/?id=cool-shadow-7&name=Cool+shadow';

// 全局标志，表示Stream是否已连接
bool isStreamConnected = false;

void main() async{ // "async" added by kzhu at May 7 15:09, to support Stream API service
  // Added by kzhu. Used for Stream Chat
  WidgetsFlutterBinding.ensureInitialized();

  // // 初始化Stream Chat
  // final chatService = StreamChatService();
  // await chatService.initClient(STREAM_API_KEY); // 替换为您的Stream API密钥
  //
  // // 连接测试用户 (在生产环境中，您应该从后端获取用户信息和token)
  // final token = chatService.devToken(TEST_USER_ID);
  // await chatService.connectUser(TEST_USER_ID, TEST_USER_NAME, TEST_USER_IMAGE, token);
  try {
    // 初始化Stream Chat
    final chatService = StreamChatService();
    print("开始初始化 Stream Chat...");  // 添加日志
    await chatService.initClient(STREAM_API_KEY);
    print("连接用户...");  // 添加日志

    // 连接测试用户
    print("开始连接用户...");  // 添加日志
    final token = chatService.devToken(TEST_USER_ID);
    await chatService.connectUser(TEST_USER_ID, TEST_USER_NAME, TEST_USER_IMAGE, token);
    // 验证连接状态
    final connectionStatus = chatService.client.wsConnectionStatus;
    print("Stream 连接状态: $connectionStatus");

    // 如果连接成功，设置全局标志
    // if (connectionStatus == ConnectionStatus.connected) {
    //   isStreamConnected = true;
    //   print("Stream Chat 连接成功!");
    // } else {
    //   print("Stream Chat 未连接，状态: $connectionStatus");
    // }
  } catch (e) {
    print('初始化 Stream Chat 失败: $e');  // 这会打印详细的错误信息
  }
  // ---------Original code---------

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Real Estate App',
      theme: ThemeData(
        primaryColor: AppColor.primary,
      ),
      home: const RootApp(),
    );
  }
}
