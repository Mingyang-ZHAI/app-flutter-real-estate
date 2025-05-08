import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class StripeTestPage extends StatefulWidget {
  @override
  _StripeTestPageState createState() => _StripeTestPageState();
}

class _StripeTestPageState extends State<StripeTestPage> {
  bool _loading = false;

  Future<void> handlePayPress() async {
    setState(() => _loading = true);

    try {
      final response = await http.post(
        Uri.parse('https://ceba-50-100-205-180.ngrok-free.app/create-payment-intent'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'amount': 100, // 1000 cents = $10
          'currency': 'usd',
        }),
      );


      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      final json = jsonDecode(response.body);
      final clientSecret = json['client_secret'];

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'Real Estate Demo',
          style: ThemeMode.light,
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment completed!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment failed: $e')),
      );
    }

    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Stripe Payment Test')),
      body: Center(
        child: _loading
            ? CircularProgressIndicator()
            : ElevatedButton(
          onPressed: handlePayPress,
          child: Text('Pay \$10'),
        ),
      ),
    );
  }
}
