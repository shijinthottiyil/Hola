import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hola/core/constants/constants.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:routemaster/routemaster.dart';

import '../../../models/razorpay_response_model.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  TextEditingController amount = TextEditingController();
  Razorpay? _razorpay;

  @override
  void initState() {
    _razorpay = Razorpay();
    _razorpay?.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay?.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay?.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

  @override
  void dispose() {
    amount.dispose();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    Fluttertoast.showToast(msg: " Payment Successfully");
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(msg: "Payment failed");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(msg: "Payment Successfully");
  }

  Future<dynamic> createOrder() async {
    var mapHeader = <String, String>{};
    mapHeader['Authorization'] =
        "Basic cnpwX3Rlc3RfU2F2SnY4RDdsWWxQZlg6N0NGaHlCSXpRaHUycTljelIzSFF4Yzln";
    mapHeader['Accept'] = "application/json";
    mapHeader['Content-Type'] = "application/x-www-form-urlencoded";
    var map = <String, String>{};
    setState(() {
      map['amount'] = "${(num.parse(amount.text) * 100)}";
    });
    map['currency'] = "INR";
    map['receipt'] = "receipt1";
    log("map $map");
    var response = await http.post(Uri.https("api.razorpay.com", "/v1/orders"),
        headers: mapHeader, body: map);
    log("....${response.body}");
    if (response.statusCode == 200) {
      // log(response.statusCode.toString() +
      //     'This is the status code successsssssssss');
      // log(response.body.toString() + 'Body');
      RazorpayOrderResponse data =
          RazorpayOrderResponse.fromJson(json.decode(response.body));
      openCheckout(data);
    } else {
      Fluttertoast.showToast(msg: "Something went wrong!");
    }
  }

  void openCheckout(RazorpayOrderResponse data) async {
    var options = {
      'key': Constants.razorpayApiKey,
      'amount': "${(num.parse(amount.text) * 100)}",
      'name': 'Razorpay Test',
      'description': '',
      'order_id': '${data.id}',
    };

    try {
      _razorpay?.open(options);
      Routemaster.of(context).pop();
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Donate Us"),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: amount,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                filled: true,
                hintText: 'Amount',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(18),
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () => createOrder(),
            icon: const Icon(Icons.arrow_forward_sharp),
            label: const Text("PAY"),
          )
        ],
      ),
    );
  }
}
