import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'pages/root.dart';
import 'theme/color.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Stripe.publishableKey = 'pk_test_51RLrhcFZjysUQv2OkbHzSeR2JxUNuGfUBbGfUc89B1AyUJAdXWW63FQERVa3NHzlxHSJe79U81nsitoVmSYqNc9j00lThb2JLW';

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
