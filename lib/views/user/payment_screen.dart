import 'dart:convert';
import 'package:blood/views/user/keys.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart'; // Import the SVG package

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  Map<String, dynamic>? intentPaymentData;
  double amount = 1.067;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> _createPaymentIntent(String amount, String currency) async {
    try {
      final body = {
        'amount': (int.parse(amount) * 100).toString(),
        'currency': currency,
        'payment_method_types[]': 'card',
      };

      final response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $SecretKey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body,
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to create Payment Intent: ${response.body}');
      }

      return jsonDecode(response.body);
    } catch (e) {
      if (kDebugMode) {
        print('Error creating Payment Intent: $e');
      }
      rethrow;
    }
  }

  Future<bool> _checkPaymentStatus(String paymentIntentId) async {
    try {
      final response = await http.get(
        Uri.parse('https://api.stripe.com/v1/payment_intents/$paymentIntentId'),
        headers: {
          'Authorization': 'Bearer $SecretKey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );

      if (response.statusCode != 200) {
        if (kDebugMode)
          print("Failed to retrieve payment intent: ${response.body}");
        return false;
      }

      final data = jsonDecode(response.body);
      final status = data['status'];
      if (kDebugMode)
        print("Payment Status: $status");
      return status == 'succeeded';
    } catch (e) {
      if (kDebugMode)
        print("Error checking payment status: $e");
      return false;
    }
  }

  Future<void> _presentPaymentSheet() async {
    try {
      await stripe.Stripe.instance.presentPaymentSheet();
    } on stripe.StripeException catch (e) {
      if (kDebugMode) {
        print("Stripe Exception: ${e.error.message}");
      }
      _showErrorDialog("Error: ${e.error.message}");
      rethrow;
    } catch (e) {
      if (kDebugMode) {
        print("Error: ${e.toString()}");
      }
      _showErrorDialog("An unexpected error occurred.");
      rethrow;
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _handlePayment() async {
    try {
      intentPaymentData = await _createPaymentIntent(amount.round().toString(), 'USD');

      await stripe.Stripe.instance.initPaymentSheet(
        paymentSheetParameters: stripe.SetupPaymentSheetParameters(
          allowsDelayedPaymentMethods: true,
          paymentIntentClientSecret: intentPaymentData!['client_secret'],
          style: ThemeMode.dark,
          merchantDisplayName: "My Store",
        ),
      );

      await _presentPaymentSheet();

      final paymentStatus = await _checkPaymentStatus(intentPaymentData!['id']);
      if (paymentStatus) {
        await _firestore.collection("users").doc(FirebaseAuth.instance.currentUser?.uid).update({'paid': true,'paidAt': FieldValue.serverTimestamp(),});
        _showSuccessSnackBar();
      } else {
        _showFailureSnackBar();
      }
      intentPaymentData = null;
    } catch (e) {
      if (kDebugMode)
        print("Payment processing error: $e");
    }
  }

  void _showSuccessSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Payment successful!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showFailureSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Payment failed.'),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFB71C1C), // Darker red
              Color(0xFFE57373), // Lighter red
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Use an SVG for the blood drop
              SvgPicture.asset(
                'assets/blood-drop.svg', // Ensure the path is correct
                height: 100,
                width: 100,
                color: Colors.white, // Make the blood drop white
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _handlePayment,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.red[900], // Darker red text
                  shadowColor: Colors.red.withOpacity(0.5),
                  elevation: 8,
                ),
                child: Text(
                  "Pay USD ${amount.toStringAsFixed(2)}", // Changed text
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600, // Semi-bold
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
