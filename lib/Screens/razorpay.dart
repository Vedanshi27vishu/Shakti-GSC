import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayPaymentScreen extends StatefulWidget {
  @override
  _RazorpayPaymentScreenState createState() => _RazorpayPaymentScreenState();
}

class _RazorpayPaymentScreenState extends State<RazorpayPaymentScreen> {
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();

    // Register event listeners
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }
  
void openCheckout() {
  var options = {
    'key': 'rzp_test_SG5EgYjD19Bnhf', // Replace with your live Razorpay Key ID
    'amount': 100, // ₹1 = 100 paise
    'currency': 'INR',
    'name': 'Shakti App',
    'description': 'UPI Payment Test',
    'prefill': {
      'contact': '9876543210',
      'email': 'testuser@shakti.in',
    },
    'method': {
      'upi': true,         // ✅ UPI enabled
      'card': true,
      'netbanking': true,
      'wallet': true,
    },
  };

  try {
    _razorpay.open(options);
  } catch (e) {
    debugPrint('Error: $e');
  }
}

 

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Payment Success!"),
        content: Text("Payment ID: ${response.paymentId}"),
      ),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Payment Failed!"),
        content: Text("Reason: ${response.message}"),
      ),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Wallet Selected: ${response.walletName}")),
    );
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Pay with Razorpay")),
      body: Center(
        child: ElevatedButton(
          onPressed: openCheckout,
          child: Text("Pay ₹100"),
        ),
      ),
    );
  }
}
