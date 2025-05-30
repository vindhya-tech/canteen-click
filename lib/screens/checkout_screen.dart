
// // // import 'package:flutter/material.dart';
// // // import 'package:http/http.dart' as http;
// // // import 'package:razorpay_flutter/razorpay_flutter.dart';
// // // import 'dart:convert';

// // // class CheckoutScreen extends StatefulWidget {
// // //   final List<Map<String, dynamic>> cartItems;
// // //   final double totalAmount;

// // //   const CheckoutScreen({
// // //     super.key,
// // //     required this.cartItems,
// // //     required this.totalAmount,
// // //   });

// // //   @override
// // //   State<CheckoutScreen> createState() => _CheckoutScreenState();
// // // }

// // // class _CheckoutScreenState extends State<CheckoutScreen> {
// // //   String? selectedPlace;
// // //   bool isPlacingOrder = false;
// // //   late Razorpay _razorpay;

// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _razorpay = Razorpay();
// // //     _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
// // //     _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
// // //     _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
// // //   }

// // //   @override
// // //   void dispose() {
// // //     _razorpay.clear();
// // //     super.dispose();
// // //   }

// // //   void _startRazorpayPayment() {
// // //     if (selectedPlace == null) {
// // //       ScaffoldMessenger.of(context).showSnackBar(
// // //         const SnackBar(content: Text('Please select a place before placing order')),
// // //       );
// // //       return;
// // //     }

// // //     var options = {
// // //       'key': 'rzp_test_YourTestKeyHere', // Replace with your Razorpay test key
// // //       'amount': (widget.totalAmount * 100).toInt(), // Amount in paise
// // //       'name': 'Canteen App',
// // //       'description': 'Order Payment',
// // //       'prefill': {'contact': '9999999999', 'email': 'test@example.com'},
// // //       'external': {'wallets': ['paytm']},
// // //     };

// // //     try {
// // //       _razorpay.open(options);
// // //     } catch (e) {
// // //       debugPrint('Error: $e');
// // //     }
// // //   }

// // //   void _handlePaymentSuccess(PaymentSuccessResponse response) {
// // //     // Proceed to place order on your backend
// // //     placeOrder();
// // //   }

// // //   void _handlePaymentError(PaymentFailureResponse response) {
// // //     ScaffoldMessenger.of(context).showSnackBar(
// // //       const SnackBar(content: Text('Payment Failed')),
// // //     );
// // //   }

// // //   void _handleExternalWallet(ExternalWalletResponse response) {
// // //     ScaffoldMessenger.of(context).showSnackBar(
// // //       SnackBar(content: Text('Wallet Selected: ${response.walletName}')),
// // //     );
// // //   }

// // //   Future<void> placeOrder() async {
// // //     final url = Uri.parse('http://192.168.97.228:5000/api/orders');
// // //     final timestamp = DateTime.now().toIso8601String();

// // //     final orderData = {
// // //       "items": widget.cartItems.map((item) => {
// // //             "name": item['name'],
// // //             "price": item['price'],
// // //             "quantity": item['quantity'],
// // //           }).toList(),
// // //       "totalAmount": widget.totalAmount,
// // //       "timestamp": timestamp,
// // //       "status": "active",
// // //       "place": selectedPlace,
// // //     };

// // //     setState(() {
// // //       isPlacingOrder = true;
// // //     });

// // //     try {
// // //       final response = await http.post(
// // //         url,
// // //         headers: {'Content-Type': 'application/json'},
// // //         body: json.encode(orderData),
// // //       );

// // //       if (response.statusCode == 201) {
// // //         ScaffoldMessenger.of(context).showSnackBar(
// // //           const SnackBar(content: Text('Order placed successfully')),
// // //         );
// // //         Navigator.pop(context); // Go back to previous screen
// // //       } else {
// // //         ScaffoldMessenger.of(context).showSnackBar(
// // //           const SnackBar(content: Text('Failed to place order')),
// // //         );
// // //       }
// // //     } catch (e) {
// // //       ScaffoldMessenger.of(context).showSnackBar(
// // //         const SnackBar(content: Text('An error occurred while placing order')),
// // //       );
// // //     } finally {
// // //       setState(() {
// // //         isPlacingOrder = false;
// // //       });
// // //     }
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         title: const Text('Checkout'),
// // //         backgroundColor: Colors.red[700],
// // //       ),
// // //       body: Padding(
// // //         padding: const EdgeInsets.all(16.0),
// // //         child: Column(
// // //           children: [
// // //             DropdownButtonFormField<String>(
// // //               decoration: const InputDecoration(
// // //                 labelText: 'Select Place',
// // //                 border: OutlineInputBorder(),
// // //               ),
// // //               items: ['Canteen', 'F-block']
// // //                   .map((place) => DropdownMenuItem(
// // //                         value: place,
// // //                         child: Text(place),
// // //                       ))
// // //                   .toList(),
// // //               value: selectedPlace,
// // //               onChanged: (value) {
// // //                 setState(() {
// // //                   selectedPlace = value;
// // //                 });
// // //               },
// // //             ),
// // //             const SizedBox(height: 16),
// // //             Expanded(
// // //               child: ListView.builder(
// // //                 itemCount: widget.cartItems.length,
// // //                 itemBuilder: (context, index) {
// // //                   final item = widget.cartItems[index];
// // //                   return ListTile(
// // //                     title: Text(item['name']),
// // //                     subtitle: Text("Quantity: ${item['quantity']}"),
// // //                     trailing: Text("Rs. ${item['price']}"),
// // //                   );
// // //                 },
// // //               ),
// // //             ),
// // //             const Divider(),
// // //             Text(
// // //               "Total Amount: Rs. ${widget.totalAmount.toStringAsFixed(2)}",
// // //               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// // //             ),
// // //             const SizedBox(height: 20),
// // //             ElevatedButton(
// // //               onPressed: isPlacingOrder ? null : _startRazorpayPayment,
// // //               style: ElevatedButton.styleFrom(
// // //                 backgroundColor: Colors.red[700],
// // //                 padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 32),
// // //               ),
// // //               child: isPlacingOrder
// // //                   ? const SizedBox(
// // //                       height: 20,
// // //                       width: 20,
// // //                       child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
// // //                     )
// // //                   : const Text(
// // //                       'Place Order',
// // //                       style: TextStyle(fontSize: 16),
// // //                     ),
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }

// // import 'package:flutter/material.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:razorpay_flutter/razorpay_flutter.dart';
// // import 'package:fluttertoast/fluttertoast.dart';
// // import 'package:provider/provider.dart';
// // import 'dart:convert';
// // import './cart_provider.dart';

// // class CheckoutScreen extends StatefulWidget {
// //   final List<Map<String, dynamic>> cartItems;
// //   final double totalAmount;

// //   const CheckoutScreen({
// //     super.key,
// //     required this.cartItems,
// //     required this.totalAmount,
// //   });

// //   @override
// //   State<CheckoutScreen> createState() => _CheckoutScreenState();
// // }

// // class _CheckoutScreenState extends State<CheckoutScreen> {
// //   String? selectedPlace;
// //   bool isPlacingOrder = false;
// //   late Razorpay _razorpay;
  
// //   // Customer details
// //   final TextEditingController _nameController = TextEditingController();
// //   final TextEditingController _phoneController = TextEditingController();
// //   final TextEditingController _emailController = TextEditingController();

// //   @override
// //   void initState() {
// //     super.initState();
// //     _initializeRazorpay();
// //   }

// //   void _initializeRazorpay() {
// //     _razorpay = Razorpay();
// //     _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
// //     _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
// //     _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
// //   }

// //   @override
// //   void dispose() {
// //     _razorpay.clear();
// //     _nameController.dispose();
// //     _phoneController.dispose();
// //     _emailController.dispose();
// //     super.dispose();
// //   }

// //   void _startRazorpayPayment() {
// //     if (selectedPlace == null) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(
// //           content: Text('Please select a delivery place'),
// //           backgroundColor: Colors.orange,
// //         ),
// //       );
// //       return;
// //     }

// //     setState(() {
// //       isPlacingOrder = true;
// //     });

// //     var options = {
// //       'key': 'rzp_test_e7phgS2ytppCL0', // Your Razorpay test key
// //       'amount': (widget.totalAmount * 100).toInt(), // Amount in paise
// //       'name': 'College Canteen',
// //       'description': 'Food Order Payment - ${widget.cartItems.length} items',
// //       'currency': 'INR',
// //       'prefill': {
// //         'contact': _phoneController.text.isNotEmpty ? _phoneController.text : '9876543210',
// //         'email': _emailController.text.isNotEmpty ? _emailController.text : 'student@college.edu',
// //         'name': _nameController.text.isNotEmpty ? _nameController.text : 'Student',
// //       },
// //       'theme': {
// //         'color': '#E53935', // Red theme matching your app
// //       },
// //       'modal': {
// //         'confirm_close': true,
// //         'ondismiss': () {
// //           setState(() {
// //             isPlacingOrder = false;
// //           });
// //         }
// //       },
// //       'external': {
// //         'wallets': ['paytm', 'gpay', 'phonepe', 'mobikwik']
// //       },
// //       'method': {
// //         'upi': true,
// //         'card': true,
// //         'netbanking': true,
// //         'wallet': true,
// //       },
// //       'retry': {
// //         'enabled': true,
// //         'max_count': 3,
// //       },
// //       'timeout': 300, // 5 minutes
// //     };

// //     try {
// //       _razorpay.open(options);
// //     } catch (e) {
// //       setState(() {
// //         isPlacingOrder = false;
// //       });
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(
// //           content: Text('Payment Error: $e'),
// //           backgroundColor: Colors.red,
// //         ),
// //       );
// //     }
// //   }

// //   void _handlePaymentSuccess(PaymentSuccessResponse response) {
// //     Fluttertoast.showToast(
// //       msg: "Payment Successful! 🎉",
// //       toastLength: Toast.LENGTH_LONG,
// //       backgroundColor: Colors.green,
// //       textColor: Colors.white,
// //     );
    
// //     // Place order with payment ID
// //     placeOrder(response.paymentId ?? "razorpay_${DateTime.now().millisecondsSinceEpoch}");
// //   }

// //   void _handlePaymentError(PaymentFailureResponse response) {
// //     setState(() {
// //       isPlacingOrder = false;
// //     });
    
// //     Fluttertoast.showToast(
// //       msg: "Payment Failed: ${response.message}",
// //       toastLength: Toast.LENGTH_LONG,
// //       backgroundColor: Colors.red,
// //       textColor: Colors.white,
// //     );
    
// //     ScaffoldMessenger.of(context).showSnackBar(
// //       SnackBar(
// //         content: Text('Payment Failed: ${response.message}'),
// //         backgroundColor: Colors.red,
// //         action: SnackBarAction(
// //           label: 'Retry',
// //           textColor: Colors.white,
// //           onPressed: _startRazorpayPayment,
// //         ),
// //       ),
// //     );
// //   }

// //   void _handleExternalWallet(ExternalWalletResponse response) {
// //     Fluttertoast.showToast(
// //       msg: "Redirecting to ${response.walletName}...",
// //       toastLength: Toast.LENGTH_SHORT,
// //     );
// //   }

// //   // Cash on Delivery option
// //   void _placeCashOnDeliveryOrder() {
// //     if (selectedPlace == null) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(
// //           content: Text('Please select a delivery place'),
// //           backgroundColor: Colors.orange,
// //         ),
// //       );
// //       return;
// //     }
    
// //     placeOrder("COD_${DateTime.now().millisecondsSinceEpoch}");
// //   }

// //   Future<void> placeOrder(String paymentId) async {
// //     final url = Uri.parse('http://192.168.97.228:5000/api/orders');
// //     final timestamp = DateTime.now().toIso8601String();
// //     final orderId = "ORDER_${DateTime.now().millisecondsSinceEpoch}";

// //     final orderData = {
// //       "orderId": orderId,
// //       "items": widget.cartItems.map((item) => {
// //         "name": item['name'],
// //         "price": item['price'],
// //         "quantity": item['quantity'],
// //         "itemTotal": (item['price'] * item['quantity']).toDouble(),
// //       }).toList(),
// //       "totalAmount": widget.totalAmount,
// //       "timestamp": timestamp,
// //       "status": "confirmed",
// //       "place": selectedPlace,
// //       "paymentId": paymentId,
// //       "paymentStatus": paymentId.startsWith("COD_") ? "pending" : "completed",
// //       "paymentMethod": paymentId.startsWith("COD_") ? "cash_on_delivery" : "online",
// //       "customerName": _nameController.text.isNotEmpty ? _nameController.text : "Guest User",
// //       "customerPhone": _phoneController.text.isNotEmpty ? _phoneController.text : "Not Provided",
// //       "customerEmail": _emailController.text.isNotEmpty ? _emailController.text : "Not Provided",
// //       "orderDate": DateTime.now().toIso8601String().split('T')[0],
// //       "orderTime": TimeOfDay.now().format(context),
// //       "estimatedDeliveryTime": DateTime.now().add(const Duration(minutes: 20)).toIso8601String(),
// //     };

// //     setState(() {
// //       isPlacingOrder = true;
// //     });

// //     try {
// //       final response = await http.post(
// //         url,
// //         headers: {
// //           'Content-Type': 'application/json',
// //           'Accept': 'application/json',
// //         },
// //         body: json.encode(orderData),
// //       ).timeout(
// //         const Duration(seconds: 15),
// //         onTimeout: () {
// //           throw Exception('Server request timed out');
// //         },
// //       );

// //       if (response.statusCode == 201 || response.statusCode == 200) {
// //         // Clear cart after successful order
// //         Provider.of<CartProvider>(context, listen: false).clearCart();
        
// //         _showOrderSuccessDialog(orderId, paymentId);
// //       } else {
// //         throw Exception('Server returned status code: ${response.statusCode}');
// //       }
// //     } catch (e) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(
// //           content: Text('Order Error: $e'),
// //           backgroundColor: Colors.red,
// //           action: SnackBarAction(
// //             label: 'Retry',
// //             textColor: Colors.white,
// //             onPressed: () => placeOrder(paymentId),
// //           ),
// //         ),
// //       );
// //     } finally {
// //       setState(() {
// //         isPlacingOrder = false;
// //       });
// //     }
// //   }

// //   void _showOrderSuccessDialog(String orderId, String paymentId) {
// //     showDialog(
// //       context: context,
// //       barrierDismissible: false,
// //       builder: (BuildContext context) {
// //         return AlertDialog(
// //           icon: const Icon(Icons.check_circle, color: Colors.green, size: 60),
// //           title: const Text('Order Placed Successfully! 🎉'),
// //           content: Column(
// //             mainAxisSize: MainAxisSize.min,
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               Text('Order ID: $orderId'),
// //               Text('Payment ID: $paymentId'),
// //               const SizedBox(height: 10),
// //               Text('Delivery Location: $selectedPlace'),
// //               Text('Total Amount: Rs. ${widget.totalAmount.toStringAsFixed(2)}'),
// //               const SizedBox(height: 10),
// //               Container(
// //                 padding: const EdgeInsets.all(8),
// //                 decoration: BoxDecoration(
// //                   color: Colors.green[50],
// //                   borderRadius: BorderRadius.circular(8),
// //                   border: Border.all(color: Colors.green.shade200),
// //                 ),
// //                 child: const Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     Text('✅ Order confirmed and being prepared'),
// //                     Text('📱 You will receive updates'),
// //                     Text('⏰ Estimated delivery: 20 minutes'),
// //                   ],
// //                 ),
// //               ),
// //             ],
// //           ),
// //           actions: [
// //             ElevatedButton(
// //               onPressed: () {
// //                 Navigator.of(context).pop(); // Close dialog
// //                 Navigator.popUntil(context, (route) => route.isFirst); // Go to home
// //               },
// //               style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
// //               child: const Text('Continue Shopping'),
// //             ),
// //           ],
// //         );
// //       },
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('Checkout'),
// //         backgroundColor: Colors.red[700],
// //         foregroundColor: Colors.white,
// //       ),
// //       body: Padding(
// //         padding: const EdgeInsets.all(16.0),
// //         child: SingleChildScrollView(
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               // Payment Instructions
// //               Container(
// //                 width: double.infinity,
// //                 padding: const EdgeInsets.all(12),
// //                 margin: const EdgeInsets.only(bottom: 16),
// //                 decoration: BoxDecoration(
// //                   color: Colors.blue[50],
// //                   border: Border.all(color: Colors.blue.shade300),
// //                   borderRadius: BorderRadius.circular(8),
// //                 ),
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     Row(
// //                       children: [
// //                         Icon(Icons.info, color: Colors.blue[700]),
// //                         const SizedBox(width: 8),
// //                         Text(
// //                           'Test Payment Instructions',
// //                           style: TextStyle(
// //                             color: Colors.blue[700], 
// //                             fontWeight: FontWeight.bold,
// //                             fontSize: 16,
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                     const SizedBox(height: 8),
// //                     const Text('💳 Card: 4111 1111 1111 1111, OTP: 1111'),
// //                     const Text('📱 UPI: success@razorpay'),
// //                     const Text('🏦 Netbanking: Select any bank → Success'),
// //                     const Text('💰 Or use Cash on Delivery below'),
// //                   ],
// //                 ),
// //               ),

// //               // Delivery Location
// //               Card(
// //                 elevation: 4,
// //                 child: Padding(
// //                   padding: const EdgeInsets.all(16.0),
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       const Text(
// //                         'Delivery Location',
// //                         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// //                       ),
// //                       const SizedBox(height: 10),
// //                       DropdownButtonFormField<String>(
// //                         decoration: const InputDecoration(
// //                           labelText: 'Select Place',
// //                           border: OutlineInputBorder(),
// //                           prefixIcon: Icon(Icons.location_on),
// //                         ),
// //                         items: ['Canteen', 'F-block', 'Library', 'Main Gate']
// //                             .map((place) => DropdownMenuItem(
// //                                   value: place,
// //                                   child: Text(place),
// //                                 ))
// //                             .toList(),
// //                         value: selectedPlace,
// //                         onChanged: (value) {
// //                           setState(() {
// //                             selectedPlace = value;
// //                           });
// //                         },
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //               const SizedBox(height: 16),

// //               // Customer Information
// //               Card(
// //                 elevation: 4,
// //                 child: Padding(
// //                   padding: const EdgeInsets.all(16.0),
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       const Text(
// //                         'Customer Information (Optional)',
// //                         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// //                       ),
// //                       const SizedBox(height: 10),
// //                       TextField(
// //                         controller: _nameController,
// //                         decoration: const InputDecoration(
// //                           labelText: 'Name',
// //                           border: OutlineInputBorder(),
// //                           prefixIcon: Icon(Icons.person),
// //                         ),
// //                       ),
// //                       const SizedBox(height: 10),
// //                       TextField(
// //                         controller: _phoneController,
// //                         decoration: const InputDecoration(
// //                           labelText: 'Phone',
// //                           border: OutlineInputBorder(),
// //                           prefixIcon: Icon(Icons.phone),
// //                         ),
// //                         keyboardType: TextInputType.phone,
// //                       ),
// //                       const SizedBox(height: 10),
// //                       TextField(
// //                         controller: _emailController,
// //                         decoration: const InputDecoration(
// //                           labelText: 'Email',
// //                           border: OutlineInputBorder(),
// //                           prefixIcon: Icon(Icons.email),
// //                         ),
// //                         keyboardType: TextInputType.emailAddress,
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //               const SizedBox(height: 16),

// //               // Order Summary
// //               Card(
// //                 elevation: 4,
// //                 child: Padding(
// //                   padding: const EdgeInsets.all(16.0),
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       const Text(
// //                         'Order Summary',
// //                         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// //                       ),
// //                       const SizedBox(height: 10),
// //                       ListView.builder(
// //                         shrinkWrap: true,
// //                         physics: const NeverScrollableScrollPhysics(),
// //                         itemCount: widget.cartItems.length,
// //                         itemBuilder: (context, index) {
// //                           final item = widget.cartItems[index];
// //                           return ListTile(
// //                             leading: Container(
// //                               width: 40,
// //                               height: 40,
// //                               decoration: BoxDecoration(
// //                                 color: Colors.orange[100],
// //                                 borderRadius: BorderRadius.circular(8),
// //                               ),
// //                               child: const Icon(Icons.fastfood, color: Colors.orange),
// //                             ),
// //                             title: Text(item['name']),
// //                             subtitle: Text("Quantity: ${item['quantity']}"),
// //                             trailing: Text(
// //                               "Rs. ${(item['price'] * item['quantity']).toStringAsFixed(2)}",
// //                               style: const TextStyle(fontWeight: FontWeight.bold),
// //                             ),
// //                           );
// //                         },
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //               const SizedBox(height: 16),

// //               // Total Amount
// //               Card(
// //                 elevation: 4,
// //                 color: Colors.green[50],
// //                 child: Padding(
// //                   padding: const EdgeInsets.all(16.0),
// //                   child: Row(
// //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                     children: [
// //                       const Text(
// //                         "Total Amount:",
// //                         style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
// //                       ),
// //                       Text(
// //                         "Rs. ${widget.totalAmount.toStringAsFixed(2)}",
// //                         style: const TextStyle(
// //                           fontSize: 20,
// //                           fontWeight: FontWeight.bold,
// //                           color: Colors.green,
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //               const SizedBox(height: 20),

// //               // Payment Buttons
// //               SizedBox(
// //                 width: double.infinity,
// //                 child: ElevatedButton(
// //                   onPressed: isPlacingOrder ? null : _startRazorpayPayment,
// //                   style: ElevatedButton.styleFrom(
// //                     backgroundColor: Colors.red[700],
// //                     padding: const EdgeInsets.symmetric(vertical: 16),
// //                     shape: RoundedRectangleBorder(
// //                       borderRadius: BorderRadius.circular(12),
// //                     ),
// //                   ),
// //                   child: isPlacingOrder
// //                       ? const Row(
// //                           mainAxisAlignment: MainAxisAlignment.center,
// //                           children: [
// //                             SizedBox(
// //                               width: 20,
// //                               height: 20,
// //                               child: CircularProgressIndicator(color: Colors.white),
// //                             ),
// //                             SizedBox(width: 12),
// //                             Text("Processing...", style: TextStyle(fontSize: 18)),
// //                           ],
// //                         )
// //                       : const Row(
// //                           mainAxisAlignment: MainAxisAlignment.center,
// //                           children: [
// //                             Icon(Icons.payment, color: Colors.white),
// //                             SizedBox(width: 8),
// //                             Text(
// //                               'Pay Online',
// //                               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// //                             ),
// //                           ],
// //                         ),
// //                 ),
// //               ),
// //               const SizedBox(height: 12),

// //               // Cash on Delivery Button
// //               SizedBox(
// //                 width: double.infinity,
// //                 child: OutlinedButton(
// //                   onPressed: isPlacingOrder ? null : _placeCashOnDeliveryOrder,
// //                   style: OutlinedButton.styleFrom(
// //                     padding: const EdgeInsets.symmetric(vertical: 16),
// //                     shape: RoundedRectangleBorder(
// //                       borderRadius: BorderRadius.circular(12),
// //                     ),
// //                     side: const BorderSide(color: Colors.orange, width: 2),
// //                   ),
// //                   child: const Row(
// //                     mainAxisAlignment: MainAxisAlignment.center,
// //                     children: [
// //                       Icon(Icons.money, color: Colors.orange),
// //                       SizedBox(width: 8),
// //                       Text(
// //                         'Cash on Delivery',
// //                         style: TextStyle(
// //                           fontSize: 18,
// //                           fontWeight: FontWeight.bold,
// //                           color: Colors.orange,
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //               const SizedBox(height: 16),

// //               Center(
// //                 child: Text(
// //                   "Secured by Razorpay • Fast & Safe Payments",
// //                   style: TextStyle(color: Colors.grey[600], fontSize: 12),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }




// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:razorpay_flutter/razorpay_flutter.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:provider/provider.dart';
// import 'dart:convert';
// import 'dart:async';
// import './cart_provider.dart';

// class CheckoutScreen extends StatefulWidget {
//   final List<Map<String, dynamic>> cartItems;
//   final double totalAmount;

//   const CheckoutScreen({
//     super.key,
//     required this.cartItems,
//     required this.totalAmount,
//   });

//   @override
//   State<CheckoutScreen> createState() => _CheckoutScreenState();
// }

// class _CheckoutScreenState extends State<CheckoutScreen> {
//   String? selectedPlace;
//   bool isPlacingOrder = false;
//   late Razorpay _razorpay;
  
//   // Customer details
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _initializeRazorpay();
//   }

//   void _initializeRazorpay() {
//     try {
//       _razorpay = Razorpay();
//       _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
//       _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
//       _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
//       print("Razorpay initialized successfully");
//     } catch (e) {
//       print("Error initializing Razorpay: $e");
//       _showErrorDialog("Failed to initialize payment system");
//     }
//   }

//   @override
//   void dispose() {
//     try {
//       _razorpay.clear();
//     } catch (e) {
//       print("Error disposing Razorpay: $e");
//     }
//     _nameController.dispose();
//     _phoneController.dispose();
//     _emailController.dispose();
//     super.dispose();
//   }

//   void _startRazorpayPayment() {
//     if (selectedPlace == null) {
//       _showSnackBar('Please select a delivery place', Colors.orange);
//       return;
//     }

//     if (isPlacingOrder) {
//       print("Payment already in progress");
//       return;
//     }

//     setState(() {
//       isPlacingOrder = true;
//     });

//     // Add timeout to reset loading state
//     Timer(const Duration(seconds: 30), () {
//       if (mounted && isPlacingOrder) {
//         setState(() {
//           isPlacingOrder = false;
//         });
//         _showErrorDialog("Payment timeout. Please try again.");
//       }
//     });

//     var options = {
//       'key': 'rzp_test_1DP5mmOlF5G5ag', // Updated test key - replace with your actual key
//       'amount': (widget.totalAmount * 100).toInt(),
//       'name': 'College Canteen',
//       'description': 'Food Order Payment - ${widget.cartItems.length} items',
//       'currency': 'INR',
//       'prefill': {
//         'contact': _phoneController.text.isNotEmpty ? _phoneController.text : '9876543210',
//         'email': _emailController.text.isNotEmpty ? _emailController.text : 'student@college.edu',
//         'name': _nameController.text.isNotEmpty ? _nameController.text : 'Student',
//       },
//       'theme': {
//         'color': '#E53935',
//       },
//       'modal': {
//         'confirm_close': true,
//         'ondismiss': () {
//           print("Payment modal dismissed");
//           if (mounted) {
//             setState(() {
//               isPlacingOrder = false;
//             });
//           }
//         }
//       },
//       'external': {
//         'wallets': ['paytm', 'gpay', 'phonepe', 'mobikwik']
//       },
//       'method': {
//         'upi': true,
//         'card': true,
//         'netbanking': true,
//         'wallet': true,
//       },
//       'retry': {
//         'enabled': true,
//         'max_count': 3,
//       },
//       'timeout': 300,
//       'remember_customer': false,
//     };

//     try {
//       print("Opening Razorpay with options: ${options['amount']}");
//       _razorpay.open(options);
//     } catch (e) {
//       print("Error opening Razorpay: $e");
//       setState(() {
//         isPlacingOrder = false;
//       });
//       _showErrorDialog('Payment Error: $e');
//     }
//   }

//   void _handlePaymentSuccess(PaymentSuccessResponse response) {
//     print("Payment Success: ${response.paymentId}");
//     Fluttertoast.showToast(
//       msg: "Payment Successful! 🎉",
//       toastLength: Toast.LENGTH_LONG,
//       backgroundColor: Colors.green,
//       textColor: Colors.white,
//     );
    
//     placeOrder(response.paymentId ?? "razorpay_${DateTime.now().millisecondsSinceEpoch}");
//   }

//   void _handlePaymentError(PaymentFailureResponse response) {
//     print("Payment Error: ${response.code} - ${response.message}");
    
//     if (mounted) {
//       setState(() {
//         isPlacingOrder = false;
//       });
//     }
    
//     String errorMessage = "Payment Failed";
//     if (response.message != null) {
//       errorMessage = response.message!;
//     }
    
//     Fluttertoast.showToast(
//       msg: errorMessage,
//       toastLength: Toast.LENGTH_LONG,
//       backgroundColor: Colors.red,
//       textColor: Colors.white,
//     );
    
//     _showSnackBarWithAction(
//       'Payment Failed: $errorMessage',
//       Colors.red,
//       'Retry',
//       _startRazorpayPayment,
//     );
//   }

//   void _handleExternalWallet(ExternalWalletResponse response) {
//     print("External Wallet: ${response.walletName}");
//     Fluttertoast.showToast(
//       msg: "Redirecting to ${response.walletName}...",
//       toastLength: Toast.LENGTH_SHORT,
//     );
//   }

//   void _placeCashOnDeliveryOrder() {
//     if (selectedPlace == null) {
//       _showSnackBar('Please select a delivery place', Colors.orange);
//       return;
//     }
    
//     if (isPlacingOrder) {
//       return;
//     }
    
//     placeOrder("COD_${DateTime.now().millisecondsSinceEpoch}");
//   }

//   Future<void> placeOrder(String paymentId) async {
//     if (!mounted) return;
    
//     setState(() {
//       isPlacingOrder = true;
//     });

//     try {
//       // Test backend connectivity first
//       await _testBackendConnection();
      
//       final url = Uri.parse('http://192.168.97.228:5000/api/orders');
//       final timestamp = DateTime.now().toIso8601String();
//       final orderId = "ORDER_${DateTime.now().millisecondsSinceEpoch}";

//       final orderData = {
//         "orderId": orderId,
//         "items": widget.cartItems.map((item) => {
//           "name": item['name'],
//           "price": item['price'],
//           "quantity": item['quantity'],
//           "itemTotal": (item['price'] * item['quantity']).toDouble(),
//         }).toList(),
//         "totalAmount": widget.totalAmount,
//         "timestamp": timestamp,
//         "status": "confirmed",
//         "place": selectedPlace,
//         "paymentId": paymentId,
//         "paymentStatus": paymentId.startsWith("COD_") ? "pending" : "completed",
//         "paymentMethod": paymentId.startsWith("COD_") ? "cash_on_delivery" : "online",
//         "customerName": _nameController.text.isNotEmpty ? _nameController.text : "Guest User",
//         "customerPhone": _phoneController.text.isNotEmpty ? _phoneController.text : "Not Provided",
//         "customerEmail": _emailController.text.isNotEmpty ? _emailController.text : "Not Provided",
//         "orderDate": DateTime.now().toIso8601String().split('T')[0],
//         "orderTime": TimeOfDay.now().format(context),
//         "estimatedDeliveryTime": DateTime.now().add(const Duration(minutes: 20)).toIso8601String(),
//       };

//       print("Placing order with data: ${json.encode(orderData)}");

//       final response = await http.post(
//         url,
//         headers: {
//           'Content-Type': 'application/json',
//           'Accept': 'application/json',
//         },
//         body: json.encode(orderData),
//       ).timeout(
//         const Duration(seconds: 15),
//         onTimeout: () {
//           throw TimeoutException('Server request timed out', const Duration(seconds: 15));
//         },
//       );

//       print("Order response: ${response.statusCode} - ${response.body}");

//       if (response.statusCode == 201 || response.statusCode == 200) {
//         // Clear cart after successful order
//         if (mounted) {
//           Provider.of<CartProvider>(context, listen: false).clearCart();
//           _showOrderSuccessDialog(orderId, paymentId);
//         }
//       } else {
//         throw Exception('Server returned status code: ${response.statusCode}\nResponse: ${response.body}');
//       }
//     } catch (e) {
//       print("Order placement error: $e");
//       if (mounted) {
//         _showSnackBarWithAction(
//           'Order Error: ${e.toString()}',
//           Colors.red,
//           'Retry',
//           () => placeOrder(paymentId),
//         );
//       }
//     } finally {
//       if (mounted) {
//         setState(() {
//           isPlacingOrder = false;
//         });
//       }
//     }
//   }

//   Future<void> _testBackendConnection() async {
//     try {
//       final response = await http.get(
//         Uri.parse('http://192.168.97.228:5000/api/test'),
//         headers: {'Content-Type': 'application/json'},
//       ).timeout(const Duration(seconds: 5));
      
//       print("Backend test response: ${response.statusCode}");
//     } catch (e) {
//       print("Backend connection test failed: $e");
//       throw Exception("Cannot connect to server. Please check your internet connection.");
//     }
//   }

//   void _showOrderSuccessDialog(String orderId, String paymentId) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           icon: const Icon(Icons.check_circle, color: Colors.green, size: 60),
//           title: const Text('Order Placed Successfully! 🎉'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text('Order ID: $orderId'),
//               Text('Payment ID: $paymentId'),
//               const SizedBox(height: 10),
//               Text('Delivery Location: $selectedPlace'),
//               Text('Total Amount: Rs. ${widget.totalAmount.toStringAsFixed(2)}'),
//               const SizedBox(height: 10),
//               Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: Colors.green[50],
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(color: Colors.green.shade200),
//                 ),
//                 child: const Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text('✅ Order confirmed and being prepared'),
//                     Text('📱 You will receive updates'),
//                     Text('⏰ Estimated delivery: 20 minutes'),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           actions: [
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 Navigator.popUntil(context, (route) => route.isFirst);
//               },
//               style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
//               child: const Text('Continue Shopping'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _showSnackBar(String message, Color color) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: color,
//       ),
//     );
//   }

//   void _showSnackBarWithAction(String message, Color color, String actionLabel, VoidCallback action) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: color,
//         action: SnackBarAction(
//           label: actionLabel,
//           textColor: Colors.white,
//           onPressed: action,
//         ),
//       ),
//     );
//   }

//   void _showErrorDialog(String message) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Error'),
//           content: Text(message),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: const Text('OK'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Checkout'),
//         backgroundColor: Colors.red[700],
//         foregroundColor: Colors.white,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Debug Information Card
//               if (isPlacingOrder)
//                 Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.all(12),
//                   margin: const EdgeInsets.only(bottom: 16),
//                   decoration: BoxDecoration(
//                     color: Colors.orange[50],
//                     border: Border.all(color: Colors.orange.shade300),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Row(
//                     children: [
//                       const SizedBox(
//                         width: 20,
//                         height: 20,
//                         child: CircularProgressIndicator(strokeWidth: 2),
//                       ),
//                       const SizedBox(width: 12),
//                       Text(
//                         'Processing your order...',
//                         style: TextStyle(
//                           color: Colors.orange[700],
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//               // Payment Instructions
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(12),
//                 margin: const EdgeInsets.only(bottom: 16),
//                 decoration: BoxDecoration(
//                   color: Colors.blue[50],
//                   border: Border.all(color: Colors.blue.shade300),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         Icon(Icons.info, color: Colors.blue[700]),
//                         const SizedBox(width: 8),
//                         Text(
//                           'Test Payment Instructions',
//                           style: TextStyle(
//                             color: Colors.blue[700], 
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 8),
//                     const Text('💳 Card: 4111 1111 1111 1111, CVV: 123, OTP: 123456'),
//                     const Text('📱 UPI: success@razorpay'),
//                     const Text('🏦 Netbanking: Select any bank → Success'),
//                     const Text('💰 Or use Cash on Delivery below'),
//                   ],
//                 ),
//               ),

//               // Rest of your existing UI code...
//               // Delivery Location
//               Card(
//                 elevation: 4,
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'Delivery Location',
//                         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                       ),
//                       const SizedBox(height: 10),
//                       DropdownButtonFormField<String>(
//                         decoration: const InputDecoration(
//                           labelText: 'Select Place',
//                           border: OutlineInputBorder(),
//                           prefixIcon: Icon(Icons.location_on),
//                         ),
//                         items: ['Canteen', 'F-block', 'Library', 'Main Gate']
//                             .map((place) => DropdownMenuItem(
//                                   value: place,
//                                   child: Text(place),
//                                 ))
//                             .toList(),
//                         value: selectedPlace,
//                         onChanged: (value) {
//                           setState(() {
//                             selectedPlace = value;
//                           });
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),

//               // Customer Information
//               Card(
//                 elevation: 4,
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'Customer Information (Optional)',
//                         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                       ),
//                       const SizedBox(height: 10),
//                       TextField(
//                         controller: _nameController,
//                         decoration: const InputDecoration(
//                           labelText: 'Name',
//                           border: OutlineInputBorder(),
//                           prefixIcon: Icon(Icons.person),
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       TextField(
//                         controller: _phoneController,
//                         decoration: const InputDecoration(
//                           labelText: 'Phone',
//                           border: OutlineInputBorder(),
//                           prefixIcon: Icon(Icons.phone),
//                         ),
//                         keyboardType: TextInputType.phone,
//                       ),
//                       const SizedBox(height: 10),
//                       TextField(
//                         controller: _emailController,
//                         decoration: const InputDecoration(
//                           labelText: 'Email',
//                           border: OutlineInputBorder(),
//                           prefixIcon: Icon(Icons.email),
//                         ),
//                         keyboardType: TextInputType.emailAddress,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),

//               // Order Summary
//               Card(
//                 elevation: 4,
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'Order Summary',
//                         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                       ),
//                       const SizedBox(height: 10),
//                       ListView.builder(
//                         shrinkWrap: true,
//                         physics: const NeverScrollableScrollPhysics(),
//                         itemCount: widget.cartItems.length,
//                         itemBuilder: (context, index) {
//                           final item = widget.cartItems[index];
//                           return ListTile(
//                             leading: Container(
//                               width: 40,
//                               height: 40,
//                               decoration: BoxDecoration(
//                                 color: Colors.orange[100],
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               child: const Icon(Icons.fastfood, color: Colors.orange),
//                             ),
//                             title: Text(item['name']),
//                             subtitle: Text("Quantity: ${item['quantity']}"),
//                             trailing: Text(
//                               "Rs. ${(item['price'] * item['quantity']).toStringAsFixed(2)}",
//                               style: const TextStyle(fontWeight: FontWeight.bold),
//                             ),
//                           );
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),

//               // Total Amount
//               Card(
//                 elevation: 4,
//                 color: Colors.green[50],
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const Text(
//                         "Total Amount:",
//                         style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                       ),
//                       Text(
//                         "Rs. ${widget.totalAmount.toStringAsFixed(2)}",
//                         style: const TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.green,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),

//               // Payment Buttons
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: isPlacingOrder ? null : _startRazorpayPayment,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: isPlacingOrder ? Colors.grey : Colors.red[700],
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   child: isPlacingOrder
//                       ? const Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             SizedBox(
//                               width: 20,
//                               height: 20,
//                               child: CircularProgressIndicator(color: Colors.white),
//                             ),
//                             SizedBox(width: 12),
//                             Text("Processing...", style: TextStyle(fontSize: 18)),
//                           ],
//                         )
//                       : const Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(Icons.payment, color: Colors.white),
//                             SizedBox(width: 8),
//                             Text(
//                               'Pay Online',
//                               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                             ),
//                           ],
//                         ),
//                 ),
//               ),
//               const SizedBox(height: 12),

//               // Cash on Delivery Button
//               SizedBox(
//                 width: double.infinity,
//                 child: OutlinedButton(
//                   onPressed: isPlacingOrder ? null : _placeCashOnDeliveryOrder,
//                   style: OutlinedButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     side: BorderSide(
//                       color: isPlacingOrder ? Colors.grey : Colors.orange, 
//                       width: 2
//                     ),
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(
//                         Icons.money, 
//                         color: isPlacingOrder ? Colors.grey : Colors.orange
//                       ),
//                       const SizedBox(width: 8),
//                       Text(
//                         'Cash on Delivery',
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: isPlacingOrder ? Colors.grey : Colors.orange,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),

//               Center(
//                 child: Text(
//                   "Secured by Razorpay • Fast & Safe Payments",
//                   style: TextStyle(color: Colors.grey[600], fontSize: 12),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }





///////////////////////////////////////////
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:razorpay_flutter/razorpay_flutter.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:provider/provider.dart';
// import 'dart:convert';
// import 'dart:async';
// import './cart_provider.dart';

// class CheckoutScreen extends StatefulWidget {
//   final List<Map<String, dynamic>> cartItems;
//   final double totalAmount;

//   const CheckoutScreen({
//     super.key,
//     required this.cartItems,
//     required this.totalAmount,
//   });

//   @override
//   State<CheckoutScreen> createState() => _CheckoutScreenState();
// }

// class _CheckoutScreenState extends State<CheckoutScreen> {
//   String? selectedPlace;
//   bool isPlacingOrder = false;
//   late Razorpay _razorpay;
  
//   // Customer details
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _initializeRazorpay();
//   }

//   void _initializeRazorpay() {
//     try {
//       _razorpay = Razorpay();
//       _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
//       _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
//       _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
//       print("✅ Razorpay initialized successfully");
//     } catch (e) {
//       print("❌ Error initializing Razorpay: $e");
//       _showErrorDialog("Failed to initialize payment system");
//     }
//   }

//   @override
//   void dispose() {
//     try {
//       _razorpay.clear();
//     } catch (e) {
//       print("❌ Error disposing Razorpay: $e");
//     }
//     _nameController.dispose();
//     _phoneController.dispose();
//     _emailController.dispose();
//     super.dispose();
//   }

//   void _startRazorpayPayment() {
//     if (selectedPlace == null) {
//       _showSnackBar('Please select a delivery place', Colors.orange);
//       return;
//     }

//     if (isPlacingOrder) {
//       print("⚠ Payment already in progress");
//       return;
//     }

//     setState(() {
//       isPlacingOrder = true;
//     });

//     // Add timeout to reset loading state
//     Timer(const Duration(seconds: 30), () {
//       if (mounted && isPlacingOrder) {
//         setState(() {
//           isPlacingOrder = false;
//         });
//         _showErrorDialog("Payment timeout. Please try again.");
//       }
//     });

//     var options = {
//       'key': 'rzp_test_e7phgS2ytppCL0', // ✅ Using your actual test key
//       'amount': (widget.totalAmount * 100).toInt(),
//       'name': 'College Canteen',
//       'description': 'Food Order Payment - ${widget.cartItems.length} items',
//       'currency': 'INR',
//       'prefill': {
//         'contact': _phoneController.text.isNotEmpty ? _phoneController.text : '9876543210',
//         'email': _emailController.text.isNotEmpty ? _emailController.text : 'student@college.edu',
//         'name': _nameController.text.isNotEmpty ? _nameController.text : 'Student',
//       },
//       'theme': {
//         'color': '#E53935',
//       },
//       'modal': {
//         'confirm_close': true,
//         'ondismiss': () {
//           print("🔄 Payment modal dismissed");
//           if (mounted) {
//             setState(() {
//               isPlacingOrder = false;
//             });
//           }
//         }
//       },
//       'external': {
//         'wallets': ['paytm', 'gpay', 'phonepe', 'mobikwik']
//       },
//       'method': {
//         'upi': true,
//         'card': true,
//         'netbanking': true,
//         'wallet': true,
//       },
//       'retry': {
//         'enabled': true,
//         'max_count': 3,
//       },
//       'timeout': 300,
//       'remember_customer': false,
//     };

//     try {
//       print("🚀 Opening Razorpay with amount: ₹${widget.totalAmount} (${options['amount']} paise)");
//       _razorpay.open(options);
//     } catch (e) {
//       print("❌ Error opening Razorpay: $e");
//       setState(() {
//         isPlacingOrder = false;
//       });
//       _showErrorDialog('Payment Error: $e');
//     }
//   }

//   void _handlePaymentSuccess(PaymentSuccessResponse response) {
//     print("✅ Payment Success: ${response.paymentId}");
//     Fluttertoast.showToast(
//       msg: "Payment Successful! 🎉",
//       toastLength: Toast.LENGTH_LONG,
//       backgroundColor: Colors.green,
//       textColor: Colors.white,
//     );
    
//     placeOrder(response.paymentId ?? "razorpay_${DateTime.now().millisecondsSinceEpoch}");
//   }

//   void _handlePaymentError(PaymentFailureResponse response) {
//     print("❌ Payment Error: ${response.code} - ${response.message}");
    
//     if (mounted) {
//       setState(() {
//         isPlacingOrder = false;
//       });
//     }
    
//     String errorMessage = "Payment Failed";
//     if (response.message != null) {
//       errorMessage = response.message!;
//     }
    
//     Fluttertoast.showToast(
//       msg: errorMessage,
//       toastLength: Toast.LENGTH_LONG,
//       backgroundColor: Colors.red,
//       textColor: Colors.white,
//     );
    
//     _showSnackBarWithAction(
//       'Payment Failed: $errorMessage',
//       Colors.red,
//       'Retry',
//       _startRazorpayPayment,
//     );
//   }

//   void _handleExternalWallet(ExternalWalletResponse response) {
//     print("🔄 External Wallet: ${response.walletName}");
//     Fluttertoast.showToast(
//       msg: "Redirecting to ${response.walletName}...",
//       toastLength: Toast.LENGTH_SHORT,
//     );
//   }

//   void _placeCashOnDeliveryOrder() {
//     if (selectedPlace == null) {
//       _showSnackBar('Please select a delivery place', Colors.orange);
//       return;
//     }
    
//     if (isPlacingOrder) {
//       return;
//     }
    
//     placeOrder("COD_${DateTime.now().millisecondsSinceEpoch}");
//   }

//   Future<void> placeOrder(String paymentId) async {
//     if (!mounted) return;
    
//     setState(() {
//       isPlacingOrder = true;
//     });

//     try {
//       // Test backend connectivity first
//       await _testBackendConnection();
      
//       final url = Uri.parse('http://192.168.97.228:5000/api/orders');
//       final timestamp = DateTime.now().toIso8601String();
//       final orderId = "ORDER_${DateTime.now().millisecondsSinceEpoch}";

//       final orderData = {
//         "orderId": orderId,
//         "items": widget.cartItems.map((item) => {
//           "name": item['name'],
//           "price": item['price'],
//           "quantity": item['quantity'],
//           "itemTotal": (item['price'] * item['quantity']).toDouble(),
//         }).toList(),
//         "totalAmount": widget.totalAmount,
//         "timestamp": timestamp,
//         "status": "confirmed",
//         "place": selectedPlace,
//         "paymentId": paymentId,
//         "paymentStatus": paymentId.startsWith("COD_") ? "pending" : "completed",
//         "paymentMethod": paymentId.startsWith("COD_") ? "cash_on_delivery" : "online",
//         "customerName": _nameController.text.isNotEmpty ? _nameController.text : "Guest User",
//         "customerPhone": _phoneController.text.isNotEmpty ? _phoneController.text : "Not Provided",
//         "customerEmail": _emailController.text.isNotEmpty ? _emailController.text : "Not Provided",
//         "orderDate": DateTime.now().toIso8601String().split('T')[0],
//         "orderTime": TimeOfDay.now().format(context),
//         "estimatedDeliveryTime": DateTime.now().add(const Duration(minutes: 20)).toIso8601String(),
//       };

//       print("📤 Placing order with data: ${json.encode(orderData)}");

//       final response = await http.post(
//         url,
//         headers: {
//           'Content-Type': 'application/json',
//           'Accept': 'application/json',
//         },
//         body: json.encode(orderData),
//       ).timeout(
//         const Duration(seconds: 15),
//         onTimeout: () {
//           throw TimeoutException('Server request timed out', const Duration(seconds: 15));
//         },
//       );

//       print("📥 Order response: ${response.statusCode} - ${response.body}");

//       if (response.statusCode == 201 || response.statusCode == 200) {
//         // Clear cart after successful order
//         if (mounted) {
//           Provider.of<CartProvider>(context, listen: false).clearCart();
//           _showOrderSuccessDialog(orderId, paymentId);
//         }
//       } else {
//         throw Exception('Server returned status code: ${response.statusCode}\nResponse: ${response.body}');
//       }
//     } catch (e) {
//       print("❌ Order placement error: $e");
//       if (mounted) {
//         _showSnackBarWithAction(
//           'Order Error: ${e.toString()}',
//           Colors.red,
//           'Retry',
//           () => placeOrder(paymentId),
//         );
//       }
//     } finally {
//       if (mounted) {
//         setState(() {
//           isPlacingOrder = false;
//         });
//       }
//     }
//   }

//   Future<void> _testBackendConnection() async {
//     try {
//       final response = await http.get(
//         Uri.parse('http://192.168.97.228:5000/api/test'),
//         headers: {'Content-Type': 'application/json'},
//       ).timeout(const Duration(seconds: 5));
      
//       print("✅ Backend test response: ${response.statusCode}");
//     } catch (e) {
//       print("❌ Backend connection test failed: $e");
//       throw Exception("Cannot connect to server. Please check your internet connection.");
//     }
//   }

//   void _showOrderSuccessDialog(String orderId, String paymentId) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           icon: const Icon(Icons.check_circle, color: Colors.green, size: 60),
//           title: const Text('Order Placed Successfully! 🎉'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text('Order ID: $orderId'),
//               Text('Payment ID: $paymentId'),
//               const SizedBox(height: 10),
//               Text('Delivery Location: $selectedPlace'),
//               Text('Total Amount: Rs. ${widget.totalAmount.toStringAsFixed(2)}'),
//               const SizedBox(height: 10),
//               Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: Colors.green[50],
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(color: Colors.green.shade200),
//                 ),
//                 child: const Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text('✅ Order confirmed and being prepared'),
//                     Text('📱 You will receive updates'),
//                     Text('⏰ Estimated delivery: 20 minutes'),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           actions: [
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 Navigator.popUntil(context, (route) => route.isFirst);
//               },
//               style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
//               child: const Text('Continue Shopping'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _showSnackBar(String message, Color color) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: color,
//       ),
//     );
//   }

//   void _showSnackBarWithAction(String message, Color color, String actionLabel, VoidCallback action) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: color,
//         action: SnackBarAction(
//           label: actionLabel,
//           textColor: Colors.white,
//           onPressed: action,
//         ),
//       ),
//     );
//   }

//   void _showErrorDialog(String message) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Error'),
//           content: Text(message),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: const Text('OK'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Checkout'),
//         backgroundColor: Colors.red[700],
//         foregroundColor: Colors.white,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Debug Information Card
//               if (isPlacingOrder)
//                 Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.all(12),
//                   margin: const EdgeInsets.only(bottom: 16),
//                   decoration: BoxDecoration(
//                     color: Colors.orange[50],
//                     border: Border.all(color: Colors.orange.shade300),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Row(
//                     children: [
//                       const SizedBox(
//                         width: 20,
//                         height: 20,
//                         child: CircularProgressIndicator(strokeWidth: 2),
//                       ),
//                       const SizedBox(width: 12),
//                       Text(
//                         'Processing your order...',
//                         style: TextStyle(
//                           color: Colors.orange[700],
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//               // Payment Instructions with correct key
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(12),
//                 margin: const EdgeInsets.only(bottom: 16),
//                 decoration: BoxDecoration(
//                   color: Colors.blue[50],
//                   border: Border.all(color: Colors.blue.shade300),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         Icon(Icons.info, color: Colors.blue[700]),
//                         const SizedBox(width: 8),
//                         Text(
//                           'Test Payment Instructions',
//                           style: TextStyle(
//                             color: Colors.blue[700], 
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 8),
//                     const Text('💳 Card: 4111 1111 1111 1111, CVV: 123, OTP: 123456'),
//                     const Text('📱 UPI: success@razorpay'),
//                     const Text('🏦 Netbanking: Select any bank → Success'),
//                     const Text('✅ Using your actual key: rzp_test_e7phgS2ytppCL0'),
//                     const Text('💰 Or use Cash on Delivery below'),
//                   ],
//                 ),
//               ),

//               // Rest of your UI remains the same...
//               // Delivery Location
//               Card(
//                 elevation: 4,
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'Delivery Location',
//                         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                       ),
//                       const SizedBox(height: 10),
//                       DropdownButtonFormField<String>(
//                         decoration: const InputDecoration(
//                           labelText: 'Select Place',
//                           border: OutlineInputBorder(),
//                           prefixIcon: Icon(Icons.location_on),
//                         ),
//                         items: ['Canteen', 'F-block', 'Library', 'Main Gate']
//                             .map((place) => DropdownMenuItem(
//                                   value: place,
//                                   child: Text(place),
//                                 ))
//                             .toList(),
//                         value: selectedPlace,
//                         onChanged: (value) {
//                           setState(() {
//                             selectedPlace = value;
//                           });
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),

//               // Customer Information
//               Card(
//                 elevation: 4,
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'Customer Information (Optional)',
//                         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                       ),
//                       const SizedBox(height: 10),
//                       TextField(
//                         controller: _nameController,
//                         decoration: const InputDecoration(
//                           labelText: 'Name',
//                           border: OutlineInputBorder(),
//                           prefixIcon: Icon(Icons.person),
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       TextField(
//                         controller: _phoneController,
//                         decoration: const InputDecoration(
//                           labelText: 'Phone',
//                           border: OutlineInputBorder(),
//                           prefixIcon: Icon(Icons.phone),
//                         ),
//                         keyboardType: TextInputType.phone,
//                       ),
//                       const SizedBox(height: 10),
//                       TextField(
//                         controller: _emailController,
//                         decoration: const InputDecoration(
//                           labelText: 'Email',
//                           border: OutlineInputBorder(),
//                           prefixIcon: Icon(Icons.email),
//                         ),
//                         keyboardType: TextInputType.emailAddress,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),

//               // Order Summary
//               Card(
//                 elevation: 4,
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'Order Summary',
//                         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                       ),
//                       const SizedBox(height: 10),
//                       ListView.builder(
//                         shrinkWrap: true,
//                         physics: const NeverScrollableScrollPhysics(),
//                         itemCount: widget.cartItems.length,
//                         itemBuilder: (context, index) {
//                           final item = widget.cartItems[index];
//                           return ListTile(
//                             leading: Container(
//                               width: 40,
//                               height: 40,
//                               decoration: BoxDecoration(
//                                 color: Colors.orange[100],
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               child: const Icon(Icons.fastfood, color: Colors.orange),
//                             ),
//                             title: Text(item['name']),
//                             subtitle: Text("Quantity: ${item['quantity']}"),
//                             trailing: Text(
//                               "Rs. ${(item['price'] * item['quantity']).toStringAsFixed(2)}",
//                               style: const TextStyle(fontWeight: FontWeight.bold),
//                             ),
//                           );
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),

//               // Total Amount
//               Card(
//                 elevation: 4,
//                 color: Colors.green[50],
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const Text(
//                         "Total Amount:",
//                         style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                       ),
//                       Text(
//                         "Rs. ${widget.totalAmount.toStringAsFixed(2)}",
//                         style: const TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.green,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),

//               // Payment Buttons
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: isPlacingOrder ? null : _startRazorpayPayment,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: isPlacingOrder ? Colors.grey : Colors.red[700],
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   child: isPlacingOrder
//                       ? const Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             SizedBox(
//                               width: 20,
//                               height: 20,
//                               child: CircularProgressIndicator(color: Colors.white),
//                             ),
//                             SizedBox(width: 12),
//                             Text("Processing...", style: TextStyle(fontSize: 18)),
//                           ],
//                         )
//                       : const Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(Icons.payment, color: Colors.white),
//                             SizedBox(width: 8),
//                             Text(
//                               'Pay Online',
//                               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                             ),
//                           ],
//                         ),
//                 ),
//               ),
//               const SizedBox(height: 12),

//               // Cash on Delivery Button
//               SizedBox(
//                 width: double.infinity,
//                 child: OutlinedButton(
//                   onPressed: isPlacingOrder ? null : _placeCashOnDeliveryOrder,
//                   style: OutlinedButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     side: BorderSide(
//                       color: isPlacingOrder ? Colors.grey : Colors.orange, 
//                       width: 2
//                     ),
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(
//                         Icons.money, 
//                         color: isPlacingOrder ? Colors.grey : Colors.orange
//                       ),
//                       const SizedBox(width: 8),
//                       Text(
//                         'Cash on Delivery',
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: isPlacingOrder ? Colors.grey : Colors.orange,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),

//               Center(
//                 child: Text(
//                   "Secured by Razorpay • Using Test Key: rzp_test_e7phgS2ytppCL0",
//                   style: TextStyle(color: Colors.grey[600], fontSize: 12),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'dart:convert';
//import 'package:shared_preferences/shared_preferences.dart';

import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import './cart_provider.dart';

class CheckoutScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final double totalAmount;
  

  const CheckoutScreen({
    Key? key,
   
    required this.cartItems,
    required this.totalAmount,
  }) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool isPlacingOrder = false;
  String? selectedPlace;
  late Razorpay _razorpay;
  String? customerName;
  String? customerPhone;
  String? customerEmail;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      _initializeRazorpay();
    }
  }

  void _initializeRazorpay() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print("Payment Success: ${response.paymentId}");
    if (!kIsWeb) {
      Fluttertoast.showToast(
        msg: "Payment Successful!",
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    }
    _placeOrder(response.paymentId ?? "test_payment${DateTime.now().millisecondsSinceEpoch}");
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    setState(() => isPlacingOrder = false);
    print("Payment Error: ${response.message}");
    if (!kIsWeb) {
      Fluttertoast.showToast(
        msg: "Payment Failed: ${response.message}",
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Payment Failed: ${response.message}"),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("External Wallet: ${response.walletName}");
    if (!kIsWeb) {
      Fluttertoast.showToast(
        msg: "External Wallet Selected: ${response.walletName}",
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }

  // Web fallback payment simulation
  void _simulateWebPayment() {
    setState(() => isPlacingOrder = true);
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Test Payment'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('This is a test payment simulation for web.'),
              SizedBox(height: 10),
              Text('Order will be stored in your backend database.'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() => isPlacingOrder = false);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _placeOrder("test_web_payment${DateTime.now().millisecondsSinceEpoch}");
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text('Simulate Success'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _placeOrder(String paymentId) async {
    print("Starting order placement...");
    setState(() => isPlacingOrder = true);
    
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
      "status": "active",
      
      "place": selectedPlace,
      "paymentId": paymentId,
      "paymentStatus": "completed",
      "paymentMethod": kIsWeb ? "web_simulation" : "razorpay",
      "platform": kIsWeb ? "web" : "mobile",
      "customerName": customerName ?? "Guest User",
      "customerPhone": customerPhone ?? "Not Provided",
      "customerEmail": customerEmail ?? "Not Provided",
      "orderDate": DateTime.now().toIso8601String().split('T')[0],
      "orderTime": TimeOfDay.now().format(context),
    };

    print("Order Data: ${json.encode(orderData)}");

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(orderData),
      );

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 201 || response.statusCode == 200) {
        // Order successfully stored in database
        print("Order successfully stored in database!");
        
        // Clear the cart after successful order
        Provider.of<CartProvider>(context, listen: false).clearCart();
        
        // Show success message with order details
        _showOrderSuccessDialog(orderId, paymentId);
        
      } else {
        throw Exception('Server returned status code: ${response.statusCode}');
      }
    } catch (e) {
      print("Error placing order: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error placing order: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    } finally {
      setState(() => isPlacingOrder = false);
    }
  }

  void _showOrderSuccessDialog(String orderId, String paymentId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: const Icon(Icons.check_circle, color: Colors.green, size: 60),
          title: const Text('Order Placed Successfully!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Order ID: $orderId'),
              Text('Payment ID: $paymentId'),
              const SizedBox(height: 10),
              Text('Delivery Location: $selectedPlace'),
              Text('Total Amount: Rs. ${widget.totalAmount.toStringAsFixed(2)}'),
              const SizedBox(height: 10),
              const Text(
                'Your order has been stored in the database and is being prepared!',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.popUntil(context, (route) => route.isFirst); // Go to home
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text('Continue Shopping'),
            ),
          ],
        );
      },
    );
  }

  void _startPayment() {
    if (selectedPlace == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a delivery place'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (kIsWeb) {
      // Use web simulation for testing
      _simulateWebPayment();
      return;
    }

    setState(() => isPlacingOrder = true);

    var options = {
      'key': 'rzp_test_e7phgS2ytppCL0',
      'amount': (widget.totalAmount * 100).toInt(),
      'name': 'College Canteen',
      'description': 'Food Order Payment',
      'order_id': '', // You can generate order_id from your backend if needed
      'prefill': {
        'contact': customerPhone ?? '7569666589',
        'email': customerEmail ?? 'vindhya05.27@gmail.com',
        'name': customerName ?? 'Student',
      },
      'external': {
        'wallets': ['paytm']
      },
      'theme': {
        'color': '#E53935',
      },
      // Enable all payment methods including UPI
      'method': {
        'upi': true,
        'card': true,
        'netbanking': true,
        'wallet': true,
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      setState(() => isPlacingOrder = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    if (!kIsWeb) {
      _razorpay.clear();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: Colors.red[700],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Platform indicator for web
              if (kIsWeb)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.info, color: Colors.blue),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Web Testing Mode: Order will be stored in database after payment simulation.',
                          style: TextStyle(color: Colors.blue, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Delivery Location',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Select Place',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.location_on),
                        ),
                        items: ['Canteen', 'F-block']
                            .map((place) => DropdownMenuItem(
                                  value: place,
                                  child: Text(place),
                                ))
                            .toList(),
                        value: selectedPlace,
                        onChanged: (value) {
                          setState(() {
                            selectedPlace = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Customer Information',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        decoration: const InputDecoration(
                          labelText: 'Name (Optional)',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person),
                        ),
                        onChanged: (value) => customerName = value,
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        decoration: const InputDecoration(
                          labelText: 'Phone (Optional)',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.phone),
                        ),
                        keyboardType: TextInputType.phone,
                        onChanged: (value) => customerPhone = value,
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        decoration: const InputDecoration(
                          labelText: 'Email (Optional)',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.email),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) => customerEmail = value,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              Card(
                elevation: 4,
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
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: widget.cartItems.length,
                        itemBuilder: (context, index) {
                          final item = widget.cartItems[index];
                          return ListTile(
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.orange[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.fastfood, color: Colors.orange),
                            ),
                            title: Text(item['name']),
                            subtitle: Text("Quantity: ${item['quantity']}"),
                            trailing: Text(
                              "Rs. ${(item['price'] * item['quantity']).toStringAsFixed(2)}",
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              Card(
                elevation: 4,
                color: Colors.green[50],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total Amount:",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Rs. ${widget.totalAmount.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: isPlacingOrder ? null : _startPayment,
                  child: isPlacingOrder
                      ? const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(color: Colors.white),
                            ),
                            SizedBox(width: 12),
                            Text("Processing...", style: TextStyle(fontSize: 18)),
                          ],
                        )
                      : Text(
                          kIsWeb ? "Simulate Payment" : "Proceed to Payment",
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
              
              const SizedBox(height: 10),
              
              Center(
                child: Text(
                  kIsWeb ? "Web Testing Mode" : "Secured by Razorpay",
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
              
              if (!kIsWeb)
                Container(
                  margin: const EdgeInsets.only(top: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "UPI Test Payment Instructions:",
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "• For UPI testing, select any UPI option (Google Pay, PhonePe, etc.)",
                        style: TextStyle(fontSize: 12),
                      ),
                      const Text(
                        "• Use UPI ID: success@razorpay for successful payment",
                        style: TextStyle(fontSize: 12),
                      ),
                      const Text(
                        "• Use UPI ID: failure@razorpay to simulate failed payment",
                        style: TextStyle(fontSize: 12),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "Note: Orders will be stored in database after successful payment",
                        style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}