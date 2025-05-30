// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:provider/provider.dart';
// import 'cart_provider.dart';

// class StudentMenuScreen extends StatefulWidget {
//   const StudentMenuScreen({super.key});

//   @override
//   State<StudentMenuScreen> createState() => _StudentMenuScreenState();
// }

// class _StudentMenuScreenState extends State<StudentMenuScreen> {
//   List<dynamic> _menuItems = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchMenuItems();
//   }

//   Future<void> fetchMenuItems() async {
//     final url = Uri.parse('http://10.0.2.2:5000/menu'); // Replace with your backend URL
//     try {
//       final res = await http.get(url);
//       if (res.statusCode == 200) {
//         setState(() {
//           _menuItems = json.decode(res.body);
//         });
//       } else {
//         print('Failed to fetch menu');
//       }
//     } catch (e) {
//       print('Error fetching menu: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final cartProvider = Provider.of<CartProvider>(context);
//     final totalAmount = cartProvider.getTotalAmount(); // Use getTotalAmount() method

//     return Scaffold(
//       appBar: AppBar(title: const Text('Student Menu')),
//       body: Column(
//         children: [
//           // Display total amount
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text(
//               'Total: ₹${totalAmount.toStringAsFixed(2)}',
//               style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//           ),

//           // Menu list
//           _menuItems.isEmpty
//               ? const Center(child: CircularProgressIndicator())
//               : Expanded(
//                   child: ListView.builder(
//                     itemCount: _menuItems.length,
//                     itemBuilder: (context, index) {
//                       final item = _menuItems[index];
//                       final isAvailable = item['isAvailable'] == true;

//                       return ListTile(
//                         title: Text('${item['name']} - ₹${item['price']}'),
//                         subtitle: !isAvailable
//                             ? const Text('Out of Stock', style: TextStyle(color: Colors.red))
//                             : null,
//                         trailing: isAvailable
//                             ? ElevatedButton(
//                                 onPressed: () {
//                                   cartProvider.addItem(item); // Add item to cart
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     SnackBar(
//                                       content: Text("${item['name']} added to cart"),
//                                       duration: const Duration(seconds: 1),
//                                     ),
//                                   );
//                                 },
//                                 child: const Text('Add'),
//                               )
//                             : ElevatedButton(
//                                 onPressed: null,
//                                 child: const Text('Out of Stock'),
//                               ),
//                       );
//                     },
//                   ),
//                 ),
//         ],
//       ),
//     );
//   }
// }
