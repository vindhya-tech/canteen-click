// // import 'package:flutter/material.dart';
// // import 'dart:convert';
// // import 'package:http/http.dart' as http;
// // import 'view_orders.dart';
// // import 'view_payments.dart';

// // class MenuItem {
// //   String id;
// //   String name;
// //   double price;
// //   bool isAvailable;
// //   String imageUrl;

// //   MenuItem({
// //     required this.id,
// //     required this.name,
// //     required this.price,
// //     required this.isAvailable,
// //     required this.imageUrl,
// //   });

// //   factory MenuItem.fromJson(Map<String, dynamic> json) {
// //     return MenuItem(
// //       id: json['_id'],
// //       name: json['name'],
// //       price: (json['price'] as num).toDouble(),
// //       isAvailable: json['isAvailable'],
// //       imageUrl: json['imageUrl'] ?? '',
// //     );
// //   }
// // }

// // class ManageMenuItemsPage extends StatefulWidget {
// //   const ManageMenuItemsPage({super.key});

// //   @override
// //   State<ManageMenuItemsPage> createState() => _ManageMenuItemsPageState();
// // }

// // class _ManageMenuItemsPageState extends State<ManageMenuItemsPage> {
// //   final TextEditingController _nameCtrl = TextEditingController();
// //   final TextEditingController _priceCtrl = TextEditingController();
// //   String? _selectedImage;
// //   List<MenuItem> _items = [];
// //   bool _loading = true;
// //   final String baseUrl = 'http://10.0.2.2:5000/api';

// //   final List<String> availableImages = [
// //     'dosa.jpg', 'idli.jpg', 'puri.jpg', 'vada.jpg', 'springroll.jpg',
// //     'pasta.jpg', 'noodles.jpg', 'paneertikka.jpg', 'friedrice.jpg',
// //     'meals.jpg', 'biryani.jpg', 'chapathi.jpg',
// //   ];

// //   @override
// //   void initState() {
// //     super.initState();
// //     _fetchMenu();
// //   }

// //   Future<void> _fetchMenu() async {
// //     setState(() => _loading = true);
// //     try {
// //       final response = await http.get(Uri.parse('$baseUrl/menu'));
// //       if (response.statusCode == 200) {
// //         final List<dynamic> data = json.decode(response.body);
// //         _items = data.map((item) => MenuItem.fromJson(item)).toList();
// //       } else {
// //         throw Exception('Failed to load menu');
// //       }
// //     } catch (e) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text('Error loading menu: $e')),
// //       );
// //     }
// //     setState(() => _loading = false);
// //   }

// //   Future<void> _addNewItem() async {
// //     final name = _nameCtrl.text.trim();
// //     final priceText = _priceCtrl.text.trim();
// //     if (name.isEmpty || priceText.isEmpty || _selectedImage == null) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text('Fill all fields including image')),
// //       );
// //       return;
// //     }
// //     final price = double.tryParse(priceText);
// //     if (price == null) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text('Please enter a valid price')),
// //       );
// //       return;
// //     }

// //     try {
// //       final response = await http.post(
// //         Uri.parse('$baseUrl/menu/add'),
// //         headers: {'Content-Type': 'application/json'},
// //         body: json.encode({
// //           'name': name,
// //           'price': price,
// //           'imageUrl': _selectedImage!.split('/').last,
// //         }),
// //       );

// //       if (response.statusCode == 201) {
// //         _nameCtrl.clear();
// //         _priceCtrl.clear();
// //         setState(() => _selectedImage = null);
// //         _fetchMenu();
// //       } else {
// //         throw Exception('Failed to add item');
// //       }
// //     } catch (e) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text('Error adding item: $e')),
// //       );
// //     }
// //   }

// //   Future<void> _toggleAvailability(MenuItem item, bool value) async {
// //     try {
// //       final response = await http.put(
// //         Uri.parse('$baseUrl/menu/${item.id}/availability'),
// //         headers: {'Content-Type': 'application/json'},
// //         body: json.encode({'isAvailable': value}),
// //       );
// //       if (response.statusCode == 200) {
// //         setState(() => item.isAvailable = value);
// //       } else {
// //         throw Exception('Failed to update availability');
// //       }
// //     } catch (e) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text('Error updating availability: $e')),
// //       );
// //     }
// //   }

// //   Future<void> _deleteItem(String itemId) async {
// //     try {
// //       final response = await http.delete(Uri.parse('$baseUrl/menu/$itemId'));
// //       if (response.statusCode == 200) {
// //         setState(() => _items.removeWhere((item) => item.id == itemId));
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           const SnackBar(content: Text('Item deleted successfully')),
// //         );
// //       } else {
// //         throw Exception('Failed to delete item');
// //       }
// //     } catch (e) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text('Error deleting item: $e')),
// //       );
// //     }
// //   }

// //   void _confirmDelete(String itemId) {
// //     showDialog(
// //       context: context,
// //       builder: (context) => AlertDialog(
// //         title: const Text('Confirm Deletion'),
// //         content: const Text('Are you sure you want to delete this item?'),
// //         actions: [
// //           TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
// //           ElevatedButton(
// //             onPressed: () {
// //               Navigator.pop(context);
// //               _deleteItem(itemId);
// //             },
// //             style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
// //             child: const Text('Delete'),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   @override
// //   void dispose() {
// //     _nameCtrl.dispose();
// //     _priceCtrl.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: const Color(0xFFF2F2F2),
// //       appBar: AppBar(
// //         backgroundColor: Colors.grey[300], // Light grey AppBar
// //         title: const Text('Manage Menu Items'),
// //         centerTitle: true,
// //         titleTextStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold), // Bold black text in AppBar
// //       ),
// //       body: Padding(
// //         padding: const EdgeInsets.all(16),
// //         child: Column(
// //           children: [
// //             Card(
// //               color: Colors.grey[300],
// //               elevation: 4,
// //               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
// //               child: Padding(
// //                 padding: const EdgeInsets.all(12),
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     const Text(
// //                       'Add New Item',
// //                       style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
// //                     ),
// //                     const SizedBox(height: 8),
// //                     TextField(
// //                       controller: _nameCtrl,
// //                       decoration: const InputDecoration(
// //                         labelText: 'Item Name',
// //                         labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
// //                       ),
// //                     ),
// //                     const SizedBox(height: 8),
// //                     TextField(
// //                       controller: _priceCtrl,
// //                       keyboardType: TextInputType.number,
// //                       decoration: const InputDecoration(
// //                         labelText: 'Price (₹)',
// //                         labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
// //                       ),
// //                     ),
// //                     const SizedBox(height: 8),
// //                     DropdownButtonFormField<String>(
// //                       value: _selectedImage,
// //                       hint: const Text(
// //                         'Select Image',
// //                         style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
// //                       ),
// //                       items: availableImages
// //                           .map((img) => DropdownMenuItem(value: img, child: Text(img)))
// //                           .toList(),
// //                       onChanged: (val) => setState(() => _selectedImage = val),
// //                     ),
// //                     if (_selectedImage != null)
// //                       Padding(
// //                         padding: const EdgeInsets.only(top: 8.0),
// //                         child: ClipRRect(
// //                           borderRadius: BorderRadius.circular(12),
// //                           child: Image.asset(
// //                             'assets/images/$_selectedImage',
// //                             height: 100,
// //                             fit: BoxFit.cover,
// //                           ),
// //                         ),
// //                       ),
// //                     const SizedBox(height: 8),
// //                     Align(
// //                       alignment: Alignment.centerRight,
// //                       child: FilledButton.icon(
// //                         icon: const Icon(Icons.add),
// //                         label: const Text('Add Item'),
// //                         onPressed: _addNewItem,
// //                         style: FilledButton.styleFrom(backgroundColor: Colors.grey[800]),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //             const SizedBox(height: 16),
// //             Expanded(
// //               child: _loading
// //                   ? const Center(child: CircularProgressIndicator())
// //                   : ListView.builder(
// //                       itemCount: _items.length,
// //                       itemBuilder: (context, index) {
// //                         final item = _items[index];
// //                         return Card(
// //                           margin: const EdgeInsets.symmetric(vertical: 8),
// //                           elevation: 2,
// //                           child: ListTile(
// //                             leading: item.imageUrl.isNotEmpty
// //                                 ? ClipRRect(
// //                                     borderRadius: BorderRadius.circular(8),
// //                                     child: Image.asset('assets/images/${item.imageUrl}', width: 50, fit: BoxFit.cover),
// //                                   )
// //                                 : null,
// //                             title: Text('${item.name} - ₹${item.price.toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
// //                             subtitle: item.isAvailable
// //                                 ? null
// //                                 : const Text('Out of Stock', style: TextStyle(color: Colors.red)),
// //                             trailing: Row(
// //                               mainAxisSize: MainAxisSize.min,
// //                               children: [
// //                                 Switch(
// //                                   value: item.isAvailable,
// //                                   onChanged: (v) => _toggleAvailability(item, v),
// //                                 ),
// //                                 IconButton(
// //                                   icon: const Icon(Icons.delete, color: Colors.black),
// //                                   onPressed: () => _confirmDelete(item.id),
// //                                 ),
// //                               ],
// //                             ),
// //                           ),
// //                         );
// //                       },
// //                     ),
// //             ),
// //           ],
// //         ),
// //       ),
// //       bottomNavigationBar: BottomNavigationBar(
// //         currentIndex: 0,
// //         selectedItemColor: Colors.black, // Black text for bottom bar
// //         unselectedItemColor: Colors.grey[600],
// //         onTap: (index) {
// //           if (index == 1) {
// //             Navigator.push(context, MaterialPageRoute(builder: (_) => ViewOrdersPage()));
// //           } else if (index == 2) {
// //             Navigator.push(context, MaterialPageRoute(builder: (_) => const ViewPaymentsPage()));
// //           }
// //         },
// //         items: const [
// //           BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu), label: 'Manage',),
// //           BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Orders',),
// //           BottomNavigationBarItem(icon: Icon(Icons.payments), label: 'Payments',),
// //         ],
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'view_orders.dart';
// import 'view_payments.dart';

// // Model class
// class MenuItem {
//   String id;
//   String name;
//   double price;
//   bool isAvailable;
//   String imageUrl;

//   MenuItem({
//     required this.id,
//     required this.name,
//     required this.price,
//     required this.isAvailable,
//     required this.imageUrl,
//   });

//   factory MenuItem.fromJson(Map<String, dynamic> json) {
//     return MenuItem(
//       id: json['_id'],
//       name: json['name'],
//       price: (json['price'] as num).toDouble(),
//       isAvailable: json['isAvailable'],
//       imageUrl: json['imageUrl'] ?? '',
//     );
//   }
// }

// class ManageMenuItemsPage extends StatefulWidget {
//   const ManageMenuItemsPage({super.key});

//   @override
//   State<ManageMenuItemsPage> createState() => _ManageMenuItemsPageState();
// }

// class _ManageMenuItemsPageState extends State<ManageMenuItemsPage> {
//   final TextEditingController _nameCtrl = TextEditingController();
//   final TextEditingController _priceCtrl = TextEditingController();
//   String? _selectedImage;
//   List<MenuItem> _items = [];
//   bool _loading = true;
//   final String baseUrl = 'http://10.0.2.2:5000/api';

//   final List<String> availableImages = [
//     'dosa.jpg', 'idli.jpg', 'puri.jpg', 'vada.jpg', 'springroll.jpg',
//     'pasta.jpg', 'noodles.jpg', 'paneertikka.jpg', 'friedrice.jpg',
//     'meals.jpg', 'biryani.jpg', 'chapathi.jpg',
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _fetchMenu();
//   }

//   Future<void> _fetchMenu() async {
//     setState(() => _loading = true);
//     try {
//       final response = await http.get(Uri.parse('$baseUrl/menu'));
//       if (response.statusCode == 200) {
//         final List<dynamic> data = json.decode(response.body);
//         _items = data.map((item) => MenuItem.fromJson(item)).toList();
//       } else {
//         throw Exception('Failed to load menu');
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error loading menu: $e')),
//       );
//     }
//     setState(() => _loading = false);
//   }

//   Future<void> _addNewItem() async {
//     final name = _nameCtrl.text.trim();
//     final priceText = _priceCtrl.text.trim();
//     if (name.isEmpty || priceText.isEmpty || _selectedImage == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Fill all fields including image')),
//       );
//       return;
//     }
//     final price = double.tryParse(priceText);
//     if (price == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please enter a valid price')),
//       );
//       return;
//     }

//     try {
//       final response = await http.post(
//         Uri.parse('$baseUrl/menu/add'),
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode({
//           'name': name,
//           'price': price,
//           'imageUrl': _selectedImage!.split('/').last,
//         }),
//       );

//       if (response.statusCode == 201) {
//         _nameCtrl.clear();
//         _priceCtrl.clear();
//         setState(() => _selectedImage = null);
//         _fetchMenu();
//       } else {
//         throw Exception('Failed to add item');
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error adding item: $e')),
//       );
//     }
//   }

//   Future<void> _toggleAvailability(MenuItem item, bool value) async {
//     try {
//       final response = await http.put(
//         Uri.parse('$baseUrl/menu/${item.id}/availability'),
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode({'isAvailable': value}),
//       );
//       if (response.statusCode == 200) {
//         setState(() => item.isAvailable = value);
//       } else {
//         throw Exception('Failed to update availability');
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error updating availability: $e')),
//       );
//     }
//   }

//   Future<void> _deleteItem(String itemId) async {
//     try {
//       final response = await http.delete(Uri.parse('$baseUrl/menu/$itemId'));
//       if (response.statusCode == 200) {
//         setState(() => _items.removeWhere((item) => item.id == itemId));
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Item deleted successfully')),
//         );
//       } else {
//         throw Exception('Failed to delete item');
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error deleting item: $e')),
//       );
//     }
//   }

//   void _confirmDelete(String itemId) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Confirm Deletion'),
//         content: const Text('Are you sure you want to delete this item?'),
//         actions: [
//           TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context);
//               _deleteItem(itemId);
//             },
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//             child: const Text('Delete'),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _nameCtrl.dispose();
//     _priceCtrl.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFFFF8F8),
//       appBar: AppBar(
//         backgroundColor: Colors.red,
//         title: const Text('Manage Menu Items'),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             Card(
//               color: Colors.red.shade50,
//               elevation: 4,
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//               child: Padding(
//                 padding: const EdgeInsets.all(12),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text('Add New Item', style: TextStyle(fontWeight: FontWeight.bold)),
//                     const SizedBox(height: 8),
//                     TextField(controller: _nameCtrl, decoration: const InputDecoration(labelText: 'Item Name')),
//                     const SizedBox(height: 8),
//                     TextField(
//                       controller: _priceCtrl,
//                       keyboardType: TextInputType.number,
//                       decoration: const InputDecoration(labelText: 'Price (₹)'),
//                     ),
//                     const SizedBox(height: 8),
//                     DropdownButtonFormField<String>(
//                       value: _selectedImage,
//                       hint: const Text('Select Image'),
//                       items: availableImages.map((img) => DropdownMenuItem(value: img, child: Text(img))).toList(),
//                       onChanged: (val) => setState(() => _selectedImage = val),
//                     ),
//                     if (_selectedImage != null)
//                       Padding(
//                         padding: const EdgeInsets.only(top: 8.0),
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(12),
//                           child: Image.asset(
//                             'assets/images/$_selectedImage',
//                             height: 100,
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                       ),
//                     const SizedBox(height: 8),
//                     Align(
//                       alignment: Alignment.centerRight,
//                       child: FilledButton.icon(
//                         icon: const Icon(Icons.add),
//                         label: const Text('Add Item'),
//                         onPressed: _addNewItem,
//                         style: FilledButton.styleFrom(backgroundColor: Colors.red),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//             Expanded(
//               child: _loading
//                   ? const Center(child: CircularProgressIndicator())
//                   : ListView.builder(
//                       itemCount: _items.length,
//                       itemBuilder: (context, index) {
//                         final item = _items[index];
//                         return Card(
//                           margin: const EdgeInsets.symmetric(vertical: 8),
//                           elevation: 2,
//                           child: ListTile(
//                             leading: item.imageUrl.isNotEmpty
//                                 ? ClipRRect(
//                                     borderRadius: BorderRadius.circular(8),
//                                     child: Image.asset('assets/images/${item.imageUrl}', width: 50, fit: BoxFit.cover),
//                                   )
//                                 : null,
//                             title: Text('${item.name} - ₹${item.price.toStringAsFixed(2)}'),
//                             subtitle: item.isAvailable
//                                 ? null
//                                 : const Text('Out of Stock', style: TextStyle(color: Colors.red)),
//                             trailing: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Switch(
//                                   value: item.isAvailable,
//                                   onChanged: (v) => _toggleAvailability(item, v),
//                                 ),
//                                 IconButton(
//                                   icon: const Icon(Icons.delete, color: Colors.red),
//                                   onPressed: () => _confirmDelete(item.id),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: 0,
//         selectedItemColor: Colors.red,
//         onTap: (index) {
//           if (index == 1) {
//             Navigator.push(context, MaterialPageRoute(builder: (_) => const ViewOrdersPage()));
//           } else if (index == 2) {
//             Navigator.push(context, MaterialPageRoute(builder: (_) => const ViewPaymentsPage()));
//           }
//         },
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu), label: 'Manage'),
//           BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Orders'),
//           BottomNavigationBarItem(icon: Icon(Icons.payments), label: 'Payments'),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'view_orders.dart';
import 'view_payments.dart';

// Model class
class MenuItem {
  String id;
  String name;
  double price;
  bool isAvailable;
  String imageUrl;

  MenuItem({
    required this.id,
    required this.name,
    required this.price,
    required this.isAvailable,
    required this.imageUrl,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['_id'],
      name: json['name'],
      price: (json['price'] as num).toDouble(),
      isAvailable: json['isAvailable'],
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}

class ManageMenuItemsPage extends StatefulWidget {
  const ManageMenuItemsPage({super.key});

  @override
  State<ManageMenuItemsPage> createState() => _ManageMenuItemsPageState();
}

class _ManageMenuItemsPageState extends State<ManageMenuItemsPage> {
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _priceCtrl = TextEditingController();
  String? _selectedImage;
  List<MenuItem> _items = [];
  bool _loading = true;
  final String baseUrl = 'http://192.168.252.228:5000/api';

  // Language: 'en' = English, 'hi' = Hindi, 'te' = Telugu
  String _selectedLanguage = 'en';

  final List<String> availableImages = [
    'dosa.jpg', 'idli.jpg', 'puri.jpg', 'vada.jpg', 'springroll.jpg',
    'pasta.jpg', 'noodles.jpg', 'paneertikka.jpg', 'friedrice.jpg',
    'meals.jpg', 'biryani.jpg', 'chapathi.jpg',
  ];

  // Translation map for UI strings
  final Map<String, Map<String, String>> translations = {
    'en': {
      'title': 'Manage Menu Items',
      'add_new_item': 'Add New Item',
      'item_name': 'Item Name',
      'price': 'Price (₹)',
      'select_image': 'Select Image',
      'add_item': 'Add Item',
      'fill_all_fields': 'Fill all fields including image',
      'valid_price': 'Please enter a valid price',
      'confirm_deletion': 'Confirm Deletion',
      'delete_confirm_text': 'Are you sure you want to delete this item?',
      'cancel': 'Cancel',
      'delete': 'Delete',
      'out_of_stock': 'Out of Stock',
      'error_loading_menu': 'Error loading menu',
      'error_adding_item': 'Error adding item',
      'error_updating_availability': 'Error updating availability',
      'item_deleted': 'Item deleted successfully',
      'error_deleting_item': 'Error deleting item',
      'manage': 'Manage',
      'orders': 'Orders',
      'payments': 'Payments',
    },
    'hi': {
      'title': 'मेनू आइटम प्रबंधित करें',
      'add_new_item': 'नया आइटम जोड़ें',
      'item_name': 'आइटम का नाम',
      'price': 'कीमत (₹)',
      'select_image': 'छवि चुनें',
      'add_item': 'आइटम जोड़ें',
      'fill_all_fields': 'सभी फ़ील्ड भरें, छवि सहित',
      'valid_price': 'कृपया मान्य कीमत दर्ज करें',
      'confirm_deletion': 'मिटाने की पुष्टि करें',
      'delete_confirm_text': 'क्या आप वाकई इस आइटम को हटाना चाहते हैं?',
      'cancel': 'रद्द करें',
      'delete': 'मिटाएं',
      'out_of_stock': 'स्टॉक में नहीं',
      'error_loading_menu': 'मेनू लोड करने में त्रुटि',
      'error_adding_item': 'आइटम जोड़ने में त्रुटि',
      'error_updating_availability': 'उपलब्धता अपडेट करने में त्रुटि',
      'item_deleted': 'आइटम सफलतापूर्वक हटा दिया गया',
      'error_deleting_item': 'आइटम हटाने में त्रुटि',
      'manage': 'प्रबंधित करें',
      'orders': 'ऑर्डर',
      'payments': 'भुगतान',
    },
    'te': {
      'title': 'మెనూ అంశాలను నిర్వహించండి',
      'add_new_item': 'కొత్త అంశాన్ని జోడించండి',
      'item_name': 'అంశం పేరు',
      'price': 'ధర (₹)',
      'select_image': 'చిత్రం ఎంచుకోండి',
      'add_item': 'అంశం జోడించండి',
      'fill_all_fields': 'చిత్రం సహా అన్ని ఫీల్డ్‌లను పూరించండి',
      'valid_price': 'దయచేసి సరైన ధరను నమోదు చేయండి',
      'confirm_deletion': 'తొలగింపును నిర్ధారించండి',
      'delete_confirm_text': 'ఈ అంశాన్ని మీరు నిజంగా తొలగించాలనుకుంటున్నారా?',
      'cancel': 'రద్దు చేయండి',
      'delete': 'తొలగించు',
      'out_of_stock': 'స్టాక్ లేదు',
      'error_loading_menu': 'మెనూ లోడ్ చేయడంలో లోపం',
      'error_adding_item': 'అంశం జోడించడంలో లోపం',
      'error_updating_availability': 'అందుబాటును అప్‌డేట్ చేయడంలో లోపం',
      'item_deleted': 'అంశం విజయవంతంగా తొలగించబడింది',
      'error_deleting_item': 'అంశం తొలగించడంలో లోపం',
      'manage': 'నిర్వహించండి',
      'orders': 'ఆర్డర్లు',
      'payments': 'చెల్లింపులు',
    },
  };

  String t(String key) => translations[_selectedLanguage]![key] ?? '';

  @override
  void initState() {
    super.initState();
    _fetchMenu();
  }

  Future<void> _fetchMenu() async {
    setState(() => _loading = true);
    try {
      final response = await http.get(Uri.parse('$baseUrl/menu'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _items = data.map((item) => MenuItem.fromJson(item)).toList();
      } else {
        throw Exception(t('error_loading_menu'));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${t('error_loading_menu')}: $e')),
      );
    }
    setState(() => _loading = false);
  }

  Future<void> _addNewItem() async {
    final name = _nameCtrl.text.trim();
    final priceText = _priceCtrl.text.trim();
    if (name.isEmpty || priceText.isEmpty || _selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t('fill_all_fields'))),
      );
      return;
    }
    final price = double.tryParse(priceText);
    if (price == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t('valid_price'))),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/menu/add'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': name,
          'price': price,
          'imageUrl': _selectedImage!.split('/').last,
        }),
      );

      if (response.statusCode == 201) {
        _nameCtrl.clear();
        _priceCtrl.clear();
        setState(() => _selectedImage = null);
        _fetchMenu();
      } else {
        throw Exception(t('error_adding_item'));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${t('error_adding_item')}: $e')),
      );
    }
  }

  Future<void> _toggleAvailability(MenuItem item, bool value) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/menu/${item.id}/availability'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'isAvailable': value}),
      );
      if (response.statusCode == 200) {
        setState(() => item.isAvailable = value);
      } else {
        throw Exception(t('error_updating_availability'));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${t('error_updating_availability')}: $e')),
      );
    }
  }

  Future<void> _deleteItem(String itemId) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/menu/$itemId'));
      if (response.statusCode == 200) {
        setState(() => _items.removeWhere((item) => item.id == itemId));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(t('item_deleted'))),
        );
      } else {
        throw Exception(t('error_deleting_item'));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${t('error_deleting_item')}: $e')),
      );
    }
  }

  void _confirmDelete(String itemId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t('confirm_deletion')),
        content: Text(t('delete_confirm_text')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(t('cancel')),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteItem(itemId);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(t('delete')),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F8),
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(t('title')),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: DropdownButton<String>(
              value: _selectedLanguage,
              underline: const SizedBox(),
              icon: const Icon(Icons.language, color: Colors.white),
              dropdownColor: Colors.red,
              items: const [
                DropdownMenuItem(value: 'en', child: Text('English', style: TextStyle(color: Colors.white))),
                DropdownMenuItem(value: 'hi', child: Text('हिन्दी', style: TextStyle(color: Colors.white))),
                DropdownMenuItem(value: 'te', child: Text('తెలుగు', style: TextStyle(color: Colors.white))),
              ],
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    _selectedLanguage = val;
                  });
                }
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              color: Colors.red.shade50,
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(t('add_new_item'), style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    TextField(controller: _nameCtrl, decoration: InputDecoration(labelText: t('item_name'))),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _priceCtrl,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: t('price')),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _selectedImage,
                      hint: Text(t('select_image')),
                      items: availableImages.map((img) => DropdownMenuItem(value: img, child: Text(img))).toList(),
                      onChanged: (val) => setState(() => _selectedImage = val),
                    ),
                    if (_selectedImage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Image.asset('assets/images/$_selectedImage', height: 100),
                      ),
                    const SizedBox(height: 12),
                    Center(
                      child: ElevatedButton(
                        onPressed: _addNewItem,
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        child: Text(t('add_item')),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _items.isEmpty
                      ? Center(child: Text(t('error_loading_menu')))
                      : ListView.builder(
                          itemCount: _items.length,
                          itemBuilder: (context, index) {
                            final item = _items[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              child: ListTile(
                                leading: item.imageUrl.isNotEmpty
                                    ? Image.asset(
                                        'assets/images/${item.imageUrl}',
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                                title: Text(item.name),
                                subtitle: Text('₹${item.price.toStringAsFixed(2)}'),
                                trailing: Wrap(
                                  spacing: 12,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(item.isAvailable ? '' : t('out_of_stock'),
                                            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                                        Switch(
                                          value: item.isAvailable,
                                          activeColor: Colors.green,
                                          onChanged: (val) => _toggleAvailability(item, val),
                                        ),
                                      ],
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: () => _confirmDelete(item.id),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 0) {
            // Already here, do nothing
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const ViewOrdersPage()),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const ViewPaymentsPage()),
            );
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book, color: Colors.red),
            label: t('manage'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.list_alt),
            label: t('orders'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.payment),
            label: t('payments'),
          ),
        ],
      ),
    );
  }
}
