// import 'package:flutter/material.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';
// import 'package:fluttertoast/fluttertoast.dart';

// class RazorpayService {
//   late Razorpay _razorpay;
//   final Function(String) onPaymentSuccess;
//   final Function(String) onPaymentError;

//   RazorpayService({
//     required this.onPaymentSuccess,
//     required this.onPaymentError,
//   }) {
//     _initializeRazorpay();
//   }

//   void _initializeRazorpay() {
//     _razorpay = Razorpay();
//     _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
//     _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
//     _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
//   }

//   void _handlePaymentSuccess(PaymentSuccessResponse response) {
//     Fluttertoast.showToast(
//       msg: "Payment Successful: ${response.paymentId}",
//       toastLength: Toast.LENGTH_LONG,
//       backgroundColor: Colors.green,
//       textColor: Colors.white,
//     );
//     onPaymentSuccess(response.paymentId ?? "");
//   }

//   void _handlePaymentError(PaymentFailureResponse response) {
//     Fluttertoast.showToast(
//       msg: "Payment Failed: ${response.message}",
//       toastLength: Toast.LENGTH_LONG,
//       backgroundColor: Colors.red,
//       textColor: Colors.white,
//     );
//     onPaymentError(response.message ?? "Payment failed");
//   }

//   void _handleExternalWallet(ExternalWalletResponse response) {
//     Fluttertoast.showToast(
//       msg: "External Wallet Selected: ${response.walletName}",
//       toastLength: Toast.LENGTH_LONG,
//     );
//   }

//   void processPayment({
//     required double amount,
//     required String name,
//     required String email,
//     required String contact,
//     String description = "Canteen Order",
//   }) {
//     var options = {
//       'key': 'rzp_test_e7phgS2ytppCL0', // Your Razorpay test key
//       'amount': (amount * 100).toInt(), // Amount in smallest currency unit (paise)
//       'name': 'College Canteen',
//       'description': description,
//       'currency': 'INR',
//       'prefill': {
//         'contact': contact,
//         'email': email,
//         'name': name,
//       },
//       'theme': {
//         'color': '#E53935', // Red theme
//       },
//       'method': {
//         'upi': true,
//         'card': true,
//         'netbanking': true,
//         'wallet': true,
//         'emi': false,
//         'paylater': true,
//       },
//       'modal': {
//         'confirm_close': true,
//         'ondismiss': () {
//           onPaymentError("Payment cancelled by user");
//         }
//       },
//       'external': {
//         'wallets': ['paytm', 'gpay', 'phonepe', 'mobikwik']
//       },
//       'retry': {
//         'enabled': true,
//         'max_count': 3,
//       },
//       'timeout': 300, // 5 minutes
//     };

//     try {
//       print("Opening Razorpay with options: ${options.toString()}");
//       _razorpay.open(options);
//     } catch (e) {
//       print("Razorpay Error: $e");
//       onPaymentError("Error: $e");
//     }
//   }

//   void dispose() {
//     _razorpay.clear();
//   }
// }



import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RazorpayService {
  late Razorpay _razorpay;
  final Function(String) onPaymentSuccess;
  final Function(String) onPaymentError;
  final Function() onPaymentDismiss;

  RazorpayService({
    required this.onPaymentSuccess,
    required this.onPaymentError,
    required this.onPaymentDismiss,
  }) {
    _initializeRazorpay();
  }

  void _initializeRazorpay() {
    try {
      _razorpay = Razorpay();
      _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
      _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
      _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
      print("✅ Razorpay Service initialized successfully");
    } catch (e) {
      print("❌ Error initializing Razorpay: $e");
      onPaymentError("Failed to initialize payment system: $e");
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print("✅ Payment Success: ${response.paymentId}");
    Fluttertoast.showToast(
      msg: "Payment Successful: ${response.paymentId}",
      toastLength: Toast.LENGTH_LONG,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
    onPaymentSuccess(response.paymentId ?? "");
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("❌ Payment Error: ${response.code} - ${response.message}");
    Fluttertoast.showToast(
      msg: "Payment Failed: ${response.message}",
      toastLength: Toast.LENGTH_LONG,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
    onPaymentError(response.message ?? "Payment failed");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("🔄 External Wallet: ${response.walletName}");
    Fluttertoast.showToast(
      msg: "External Wallet Selected: ${response.walletName}",
      toastLength: Toast.LENGTH_LONG,
    );
  }

  void processPayment({
    required double amount,
    required String name,
    required String email,
    required String contact,
    String description = "Canteen Order",
  }) {
    var options = {
      'key': 'rzp_test_e7phgS2ytppCL0', // ✅ Using your actual test key
      'amount': (amount * 100).toInt(), // Amount in smallest currency unit (paise)
      'name': 'College Canteen',
      'description': description,
      'currency': 'INR',
      'prefill': {
        'contact': contact,
        'email': email,
        'name': name,
      },
      'theme': {
        'color': '#E53935', // Red theme
      },
      'method': {
        'upi': true,
        'card': true,
        'netbanking': true,
        'wallet': true,
        'emi': false,
        'paylater': true,
      },
      'modal': {
        'confirm_close': true,
        'ondismiss': () {
          print("🔄 Payment modal dismissed by user");
          onPaymentDismiss();
        }
      },
      'external': {
        'wallets': ['paytm', 'gpay', 'phonepe', 'mobikwik']
      },
      'retry': {
        'enabled': true,
        'max_count': 3,
      },
      'timeout': 300, // 5 minutes
      'remember_customer': false,
    };

    try {
      print("🚀 Opening Razorpay with amount: ₹${amount} (${options['amount']} paise)");
      print("📱 Contact: $contact, Email: $email, Name: $name");
      _razorpay.open(options);
    } catch (e) {
      print("❌ Razorpay Error: $e");
      onPaymentError("Error: $e");
    }
  }

  void dispose() {
    try {
      _razorpay.clear();
      print("🧹 Razorpay Service disposed");
    } catch (e) {
      print("❌ Error disposing Razorpay: $e");
    }
  }
}