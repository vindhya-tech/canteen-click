// import 'package:flutter/material.dart';
// import 'package:flutter_app_1/services/razorpay_service.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class PaymentScreen extends StatefulWidget {
//   final List<Map<String, dynamic>> cartItems;
//   final double totalAmount;
//   final String selectedPlace;

//   const PaymentScreen({
//     super.key,
//     required this.cartItems,
//     required this.totalAmount,
//     required this.selectedPlace,
//   });

//   @override
//   State<PaymentScreen> createState() => _PaymentScreenState();
// }

// class _PaymentScreenState extends State<PaymentScreen> {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   bool _isProcessing = false;
//   late RazorpayService _razorpayService;

//   @override
//   void initState() {
//     super.initState();
//     _razorpayService = RazorpayService(
//       onPaymentSuccess: _handlePaymentSuccess,
//       onPaymentError: _handlePaymentError,
//     );
//   }

//   void _handlePaymentSuccess(String paymentId) async {
//     setState(() => _isProcessing = true);
    
//     try {
//       await _saveOrder(paymentId);
      
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Order placed successfully! 🎉'),
//             backgroundColor: Colors.green,
//           ),
//         );
        
//         // Navigate back to home after successful payment
//         Navigator.popUntil(context, (route) => route.isFirst);
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Error saving order: $e'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     } finally {
//       if (mounted) {
//         setState(() => _isProcessing = false);
//       }
//     }
//   }

//   void _handlePaymentError(String error) {
//     setState(() => _isProcessing = false);
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Payment failed: $error'),
//         backgroundColor: Colors.red,
//       ),
//     );
//   }

//   Future<void> _saveOrder(String paymentId) async {
//     final url = Uri.parse('http://192.168.97.228:5000/api/orders');
//     final timestamp = DateTime.now().toIso8601String();
//     final orderId = "ORDER_${DateTime.now().millisecondsSinceEpoch}";

//     final orderData = {
//       "orderId": orderId,
//       "items": widget.cartItems.map((item) => {
//         "name": item['name'],
//         "price": item['price'],
//         "quantity": item['quantity'],
//         "itemTotal": (item['price'] * item['quantity']).toDouble(),
//       }).toList(),
//       "totalAmount": widget.totalAmount,
//       "timestamp": timestamp,
//       "status": "confirmed",
//       "place": widget.selectedPlace,
//       "paymentId": paymentId,
//       "paymentStatus": "completed",
//       "paymentMethod": "razorpay",
//       "customerName": _nameController.text.isNotEmpty ? _nameController.text : "Guest User",
//       "customerEmail": _emailController.text.isNotEmpty ? _emailController.text : "Not Provided",
//       "customerPhone": _phoneController.text.isNotEmpty ? _phoneController.text : "Not Provided",
//       "orderDate": DateTime.now().toIso8601String().split('T')[0],
//       "orderTime": TimeOfDay.now().format(context),
//     };

//     final response = await http.post(
//       url,
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode(orderData),
//     );

//     if (response.statusCode != 201 && response.statusCode != 200) {
//       throw Exception('Failed to save order');
//     }
//   }

//   void _processPayment() {
//     final name = _nameController.text.trim();
//     final email = _emailController.text.trim();
//     final phone = _phoneController.text.trim();

//     if (name.isEmpty || email.isEmpty || phone.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Please fill all required fields'),
//           backgroundColor: Colors.orange,
//         ),
//       );
//       return;
//     }

//     setState(() => _isProcessing = true);

//     _razorpayService.processPayment(
//       amount: widget.totalAmount,
//       name: name,
//       email: email,
//       contact: phone,
//       description: "Canteen Order - ${widget.cartItems.length} items",
//     );
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _emailController.dispose();
//     _phoneController.dispose();
//     _razorpayService.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Payment'),
//         backgroundColor: Colors.red[700],
//         foregroundColor: Colors.white,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Payment Instructions
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(12),
//               margin: const EdgeInsets.only(bottom: 20),
//               decoration: BoxDecoration(
//                 color: Colors.blue[50],
//                 border: Border.all(color: Colors.blue.shade300),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Icon(Icons.info, color: Colors.blue[700]),
//                       const SizedBox(width: 8),
//                       Text(
//                         'Test Payment Instructions',
//                         style: TextStyle(
//                           color: Colors.blue[700], 
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 8),
//                   const Text('💳 Card: 4111 1111 1111 1111, OTP: 1111'),
//                   const Text('📱 UPI: success@razorpay'),
//                   const Text('🏦 Netbanking: Select any bank → Success'),
//                 ],
//               ),
//             ),

//             // Order Summary
//             Card(
//               elevation: 4,
//               margin: const EdgeInsets.only(bottom: 20),
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'Order Summary',
//                       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 10),
//                     ...widget.cartItems.map((item) => Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 4),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text('${item['name']} x${item['quantity']}'),
//                           Text('₹${(item['price'] * item['quantity']).toStringAsFixed(2)}'),
//                         ],
//                       ),
//                     )),
//                     const Divider(height: 20),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         const Text('Total Amount:', style: TextStyle(fontWeight: FontWeight.bold)),
//                         Text('₹${widget.totalAmount.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
//                       ],
//                     ),
//                     const SizedBox(height: 10),
//                     Container(
//                       padding: const EdgeInsets.all(8),
//                       decoration: BoxDecoration(
//                         color: Colors.orange.shade100,
//                         borderRadius: BorderRadius.circular(8),
//                         border: Border.all(color: Colors.orange),
//                       ),
//                       child: Row(
//                         children: [
//                           const Icon(Icons.location_on, color: Colors.orange),
//                           const SizedBox(width: 8),
//                           Text('Delivery to: ${widget.selectedPlace}'),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
            
//             // Customer Information
//             const Text(
//               'Customer Information',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),
            
//             TextField(
//               controller: _nameController,
//               decoration: const InputDecoration(
//                 labelText: 'Full Name *',
//                 border: OutlineInputBorder(),
//                 prefixIcon: Icon(Icons.person),
//               ),
//             ),
//             const SizedBox(height: 12),
            
//             TextField(
//               controller: _emailController,
//               keyboardType: TextInputType.emailAddress,
//               decoration: const InputDecoration(
//                 labelText: 'Email *',
//                 border: OutlineInputBorder(),
//                 prefixIcon: Icon(Icons.email),
//               ),
//             ),
//             const SizedBox(height: 12),
            
//             TextField(
//               controller: _phoneController,
//               keyboardType: TextInputType.phone,
//               decoration: const InputDecoration(
//                 labelText: 'Phone Number *',
//                 border: OutlineInputBorder(),
//                 prefixIcon: Icon(Icons.phone),
//               ),
//             ),
            
//             const SizedBox(height: 24),
            
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.green,
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   textStyle: const TextStyle(fontSize: 18),
//                 ),
//                 onPressed: _isProcessing ? null : _processPayment,
//                 child: _isProcessing
//                     ? const Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           SizedBox(
//                             width: 20,
//                             height: 20,
//                             child: CircularProgressIndicator(color: Colors.white),
//                           ),
//                           SizedBox(width: 12),
//                           Text('Processing...'),
//                         ],
//                       )
//                     : const Text('Pay Now'),
//               ),
//             ),
            
//             const SizedBox(height: 16),
            
//             Center(
//               child: Text(
//                 'Secured by Razorpay',
//                 style: TextStyle(color: Colors.grey[600], fontSize: 12),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:flutter_app_1/services/razorpay_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class PaymentScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final double totalAmount;
  final String selectedPlace;

  const PaymentScreen({
    super.key,
    required this.cartItems,
    required this.totalAmount,
    required this.selectedPlace,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool _isProcessing = false;
  late RazorpayService _razorpayService;

  @override
  void initState() {
    super.initState();
    _initializeRazorpayService();
  }

  void _initializeRazorpayService() {
    _razorpayService = RazorpayService(
      onPaymentSuccess: _handlePaymentSuccess,
      onPaymentError: _handlePaymentError,
      onPaymentDismiss: _handlePaymentDismiss,
    );
  }

  void _handlePaymentSuccess(String paymentId) async {
    print("🎉 Payment successful, placing order...");
    
    if (!mounted) return;
    
    setState(() => _isProcessing = true);
    
    try {
      await _saveOrder(paymentId);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Order placed successfully! 🎉'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Navigate back to home after successful payment
        Navigator.popUntil(context, (route) => route.isFirst);
      }
    } catch (e) {
      print("❌ Error saving order: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving order: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  void _handlePaymentError(String error) {
    print("❌ Payment error: $error");
    if (mounted) {
      setState(() => _isProcessing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Payment failed: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _handlePaymentDismiss() {
    print("🔄 Payment dismissed by user");
    if (mounted) {
      setState(() => _isProcessing = false);
    }
  }

  Future<void> _saveOrder(String paymentId) async {
    final url = Uri.parse('http://192.168.252.228:5000/api/orders');
    final timestamp = DateTime.now().toIso8601String();
    final orderId = "ORDER_${DateTime.now().millisecondsSinceEpoch}";

    final orderData = {
      "orderId": orderId,
      "items": widget.cartItems.map((item) => {
        "name": item['name'],
        "price": item['price'],
        "quantity": item['quantity'],
        "itemTotal": (item['price'] * item['quantity']).toDouble(),
      }).toList(),
      "totalAmount": widget.totalAmount,
      "timestamp": timestamp,
      "status": "confirmed",
      "place": widget.selectedPlace,
      "paymentId": paymentId,
      "paymentStatus": "completed",
      "paymentMethod": "razorpay",
      "customerName": _nameController.text.isNotEmpty ? _nameController.text : "Guest User",
      "customerEmail": _emailController.text.isNotEmpty ? _emailController.text : "Not Provided",
      "customerPhone": _phoneController.text.isNotEmpty ? _phoneController.text : "Not Provided",
      "orderDate": DateTime.now().toIso8601String().split('T')[0],
      "orderTime": TimeOfDay.now().format(context),
    };

    print("📤 Sending order data: ${json.encode(orderData)}");

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode(orderData),
    ).timeout(
      const Duration(seconds: 15),
      onTimeout: () {
        throw TimeoutException('Server request timed out', const Duration(seconds: 15));
      },
    );

    print("📥 Order response: ${response.statusCode} - ${response.body}");

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Failed to save order: ${response.statusCode} - ${response.body}');
    }
  }

  void _processPayment() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();

    if (name.isEmpty || email.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required fields'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_isProcessing) {
      print("⚠️ Payment already in progress");
      return;
    }

    print("🚀 Starting payment process...");
    setState(() => _isProcessing = true);

    // Add timeout safety
    Timer(const Duration(seconds: 30), () {
      if (mounted && _isProcessing) {
        setState(() => _isProcessing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment timeout. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });

    _razorpayService.processPayment(
      amount: widget.totalAmount,
      name: name,
      email: email,
      contact: phone,
      description: "Canteen Order - ${widget.cartItems.length} items",
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _razorpayService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        backgroundColor: Colors.red[700],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Processing Indicator
            if (_isProcessing)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  border: Border.all(color: Colors.orange.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Processing payment...',
                      style: TextStyle(
                        color: Colors.orange[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

            // Payment Instructions
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                border: Border.all(color: Colors.blue.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info, color: Colors.blue[700]),
                      const SizedBox(width: 8),
                      Text(
                        'Test Payment Instructions',
                        style: TextStyle(
                          color: Colors.blue[700], 
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text('💳 Card: 4111 1111 1111 1111, CVV: 123, OTP: 123456'),
                  const Text('📱 UPI: success@razorpay'),
                  const Text('🏦 Netbanking: Select any bank → Success'),
                  const Text('✅ Using your actual Razorpay test key'),
                ],
              ),
            ),

            // Order Summary
            Card(
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 20),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Order Summary',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    ...widget.cartItems.map((item) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${item['name']} x${item['quantity']}'),
                          Text('₹${(item['price'] * item['quantity']).toStringAsFixed(2)}'),
                        ],
                      ),
                    )),
                    const Divider(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Amount:', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('₹${widget.totalAmount.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.orange),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.orange),
                          const SizedBox(width: 8),
                          Text('Delivery to: ${widget.selectedPlace}'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Customer Information
            const Text(
              'Customer Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 12),
            
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 12),
            
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone Number *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
            ),
            
            const SizedBox(height: 24),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isProcessing ? Colors.grey : Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                onPressed: _isProcessing ? null : _processPayment,
                child: _isProcessing
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(color: Colors.white),
                          ),
                          SizedBox(width: 12),
                          Text('Processing...'),
                        ],
                      )
                    : const Text('Pay Now'),
              ),
            ),
            
            const SizedBox(height: 16),
            
            Center(
              child: Text(
                'Secured by Razorpay • Using Test Key: rzp_test_e7phgS2ytppCL0',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}