// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'cart_provider.dart';
// import 'home_screen.dart';
// import 'cart_screen.dart';

// class SnacksScreen extends StatefulWidget {
//   const SnacksScreen({Key? key}) : super(key: key);

//   @override
//   _SnacksScreenState createState() => _SnacksScreenState();
// }

// class _SnacksScreenState extends State<SnacksScreen> {
//   List<dynamic> snackItems = [];
//   String searchQuery = '';

//   @override
//   void initState() {
//     super.initState();
//     fetchSnackItems();
//   }

//   Future<void> fetchSnackItems() async {
//     final url = Uri.parse('http://10.0.2.2:5000/api/menu');
//     try {
//       final response = await http.get(url);
//       if (response.statusCode == 200) {
//         final List<dynamic> data = json.decode(response.body);
//         setState(() => snackItems = data);
//         final cartProvider = Provider.of<CartProvider>(context, listen: false);
//         cartProvider.updateItemAvailability(snackItems);
//       } else {
//         print('Failed to load menu');
//       }
//     } catch (e) {
//       print('Error: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final cartProvider = Provider.of<CartProvider>(context);

//     final filteredItems = snackItems.where((item) {
//       return item['name'].toLowerCase().contains(searchQuery.toLowerCase());
//     }).toList();

//     return Scaffold(
//       backgroundColor: const Color.fromARGB(255, 184, 91, 76),
//       body: SafeArea(
//         child: Column(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(20),
//               decoration: const BoxDecoration(
//                 color: Colors.red,
//                 borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       IconButton(
//                         icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
//                         onPressed: () => Navigator.pushReplacement(
//                           context,
//                           MaterialPageRoute(builder: (_) => const HomeScreen()),
//                         ),
//                       ),
//                       const SizedBox(width: 10),
//                       const Text(
//                         'Menu',
//                         style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 10),
//                   TextField(
//                     onChanged: (value) => setState(() => searchQuery = value),
//                     decoration: InputDecoration(
//                       hintText: 'Search for snacks...',
//                       hintStyle: const TextStyle(color: Colors.black),
//                       prefixIcon: const Icon(Icons.search, color: Colors.black),
//                       filled: true,
//                       fillColor: Colors.white,
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(20),
//                         borderSide: const BorderSide(color: Colors.white),
//                       ),
//                       contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: snackItems.isEmpty
//                   ? const Center(child: CircularProgressIndicator())
//                   : Container(
//                       color: Colors.white,
//                       child: RefreshIndicator(
//                         onRefresh: fetchSnackItems,
//                         child: ListView.builder(
//                           padding: const EdgeInsets.all(20),
//                           itemCount: filteredItems.length,
//                           itemBuilder: (context, index) {
//                             final item = filteredItems[index];
//                             final isAvailable = item['isAvailable'] == true;

//                             return Container(
//                               margin: const EdgeInsets.symmetric(vertical: 10),
//                               padding: const EdgeInsets.all(12),
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(20),
//                                 boxShadow: const [
//                                   BoxShadow(
//                                     color: Colors.black26,
//                                     blurRadius: 6,
//                                     offset: Offset(0, 2),
//                                   ),
//                                 ],
//                               ),
//                               child: Row(
//                                 children: [
//                                   Container(
//                                     width: 80,
//                                     height: 80,
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(15),
//                                       color: Colors.grey[300],
//                                     ),
//                                     child: ClipRRect(
//                                       borderRadius: BorderRadius.circular(10),
//                                       child: Image.asset(
//                                         'assets/images/${item['imageUrl']}',
//                                         fit: BoxFit.cover,
//                                         errorBuilder: (context, error, stackTrace) {
//                                           print("Error loading image: ${item['imageUrl']}");
//                                           return const Icon(Icons.fastfood, size: 40);
//                                         },
//                                       ),
//                                     ),
//                                   ),
//                                   const SizedBox(width: 20),
//                                   Expanded(
//                                     child: Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           item['name'],
//                                           style: const TextStyle(
//                                             fontSize: 20,
//                                             fontWeight: FontWeight.w600,
//                                           ),
//                                         ),
//                                         const SizedBox(height: 5),
//                                         Text(
//                                           "Rs. ${item['price']}",
//                                           style: const TextStyle(fontSize: 16),
//                                         ),
//                                         if (!isAvailable)
//                                           const Text(
//                                             'Out of Stock',
//                                             style: TextStyle(color: Colors.red),
//                                           ),
//                                       ],
//                                     ),
//                                   ),
//                                   ElevatedButton(
//                                     onPressed: isAvailable
//                                         ? () {
//                                             cartProvider.addItem(item);
//                                             ScaffoldMessenger.of(context).showSnackBar(
//                                               SnackBar(
//                                                 content: Text("${item['name']} added to cart"),
//                                                 duration: const Duration(seconds: 1),
//                                               ),
//                                             );
//                                           }
//                                         : null,
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor: Colors.brown[700],
//                                       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                                     ),
//                                     child: Text(
//                                       isAvailable ? 'ADD' : 'Out of Stock',
//                                       style: const TextStyle(
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.bold, // ✅ Make text thick
//                                         color: Colors.white,           // ✅ Make text white
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                     ),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: Container(
//         padding: const EdgeInsets.symmetric(vertical: 10),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
//           boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10)],
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             IconButton(
//               icon: const Icon(Icons.home, size: 30, color: Colors.red),
//               onPressed: () {
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(builder: (_) => const HomeScreen()),
//                 );
//               },
//             ),
//             IconButton(
//               icon: const Icon(Icons.shopping_cart, size: 30, color: Colors.red),
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (_) => const CartScreen()),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }







// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'cart_provider.dart';
// import 'home_screen.dart';
// import 'cart_screen.dart';

// class SnacksScreen extends StatefulWidget {
//   const SnacksScreen({Key? key}) : super(key: key);

//   @override
//   _SnacksScreenState createState() => _SnacksScreenState();
// }

// class _SnacksScreenState extends State<SnacksScreen> {
//   List<dynamic> snackItems = [];
//   String searchQuery = '';

//   @override
//   void initState() {
//     super.initState();
//     fetchSnackItems();
//   }

//   Future<void> fetchSnackItems() async {
//     final url = Uri.parse('http://192.168.29.47:5000/api/menu');
//     try {
//       final response = await http.get(url);
//       if (response.statusCode == 200) {
//         final List<dynamic> data = json.decode(response.body);
//         setState(() => snackItems = data);
//         final cartProvider = Provider.of<CartProvider>(context, listen: false);
//         cartProvider.updateItemAvailability(snackItems);
//       } else {
//         print('Failed to load menu');
//       }
//     } catch (e) {
//       print('Error: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final cartProvider = Provider.of<CartProvider>(context);

//     final filteredItems = snackItems.where((item) {
//       return item['name'].toLowerCase().contains(searchQuery.toLowerCase());
//     }).toList();

//     return Scaffold(
//       backgroundColor: const Color.fromARGB(255, 184, 91, 76),
//       body: SafeArea(
//         child: Column(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(20),
//               decoration: const BoxDecoration(
//                 color: Colors.red,
//                 borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       IconButton(
//                         icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
//                         onPressed: () => Navigator.pushReplacement(
//                           context,
//                           MaterialPageRoute(builder: (_) => const HomeScreen()),
//                         ),
//                       ),
//                       const SizedBox(width: 10),
//                       const Text(
//                         'Menu',
//                         style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 10),
//                   TextField(
//                     onChanged: (value) => setState(() => searchQuery = value),
//                     decoration: InputDecoration(
//                       hintText: 'Search for snacks...',
//                       hintStyle: const TextStyle(color: Colors.black),
//                       prefixIcon: const Icon(Icons.search, color: Colors.black),
//                       filled: true,
//                       fillColor: Colors.white,
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(20),
//                         borderSide: const BorderSide(color: Colors.white),
//                       ),
//                       contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: snackItems.isEmpty
//                   ? const Center(child: CircularProgressIndicator())
//                   : Container(
//                       color: Colors.white,
//                       child: RefreshIndicator(
//                         onRefresh: fetchSnackItems,
//                         child: ListView.builder(
//                           padding: const EdgeInsets.all(20),
//                           itemCount: filteredItems.length,
//                           itemBuilder: (context, index) {
//                             final item = filteredItems[index];
//                             final itemName = item['name'];
//                             final isAvailable = item['isAvailable'] == true;
//                             final isInCart = cartProvider.cartItems.containsKey(itemName);
//                             final quantity = isInCart ? cartProvider.cartItems[itemName]['quantity'] : 0;

//                             return Container(
//                               margin: const EdgeInsets.symmetric(vertical: 10),
//                               padding: const EdgeInsets.all(12),
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(20),
//                                 boxShadow: const [
//                                   BoxShadow(
//                                     color: Colors.black26,
//                                     blurRadius: 6,
//                                     offset: Offset(0, 2),
//                                   ),
//                                 ],
//                               ),
//                               child: Row(
//                                 children: [
//                                   Container(
//                                     width: 80,
//                                     height: 80,
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(15),
//                                       color: Colors.grey[300],
//                                     ),
//                                     child: ClipRRect(
//                                       borderRadius: BorderRadius.circular(10),
//                                       child: Image.asset(
//                                         'assets/images/${item['imageUrl']}',
//                                         fit: BoxFit.cover,
//                                         errorBuilder: (context, error, stackTrace) {
//                                           print("Error loading image: ${item['imageUrl']}");
//                                           return const Icon(Icons.fastfood, size: 40);
//                                         },
//                                       ),
//                                     ),
//                                   ),
//                                   const SizedBox(width: 20),
//                                   Expanded(
//                                     child: Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           item['name'],
//                                           style: const TextStyle(
//                                             fontSize: 20,
//                                             fontWeight: FontWeight.w600,
//                                           ),
//                                         ),
//                                         const SizedBox(height: 5),
//                                         Text(
//                                           "Rs. ${item['price']}",
//                                           style: const TextStyle(fontSize: 16),
//                                         ),
//                                         if (!isAvailable)
//                                           const Text(
//                                             'Out of Stock',
//                                             style: TextStyle(color: Colors.red),
//                                           ),
//                                       ],
//                                     ),
//                                   ),
//                                   if (!isAvailable)
//                                     const SizedBox()
//                                   else if (!isInCart)
//                                     ElevatedButton(
//                                       onPressed: () {
//                                         cartProvider.addItem(item);
//                                         ScaffoldMessenger.of(context).showSnackBar(
//                                           SnackBar(
//                                             content: Text("${item['name']} added to cart"),
//                                             duration: const Duration(seconds: 1),
//                                           ),
//                                         );
//                                       },
//                                       style: ElevatedButton.styleFrom(
//                                         backgroundColor: Colors.brown[700],
//                                         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                                       ),
//                                       child: const Text(
//                                         'ADD',
//                                         style: TextStyle(
//                                           fontSize: 16,
//                                           fontWeight: FontWeight.bold,
//                                           color: Colors.white,
//                                         ),
//                                       ),
//                                     )
//                                   else
//                                     Row(
//                                       children: [
//                                         IconButton(
//                                           icon: const Icon(Icons.remove, color: Colors.red),
//                                           onPressed: () {
//                                             cartProvider.decreaseQuantity(itemName);
//                                           },
//                                         ),
//                                         Text(
//                                           '$quantity',
//                                           style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                                         ),
//                                         IconButton(
//                                           icon: const Icon(Icons.add, color: Colors.green),
//                                           onPressed: () {
//                                             cartProvider.increaseQuantity(itemName);
//                                           },
//                                         ),
//                                       ],
//                                     ),
//                                 ],
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                     ),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: Container(
//         padding: const EdgeInsets.symmetric(vertical: 10),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
//           boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10)],
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             IconButton(
//               icon: const Icon(Icons.home, size: 30, color: Colors.red),
//               onPressed: () {
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(builder: (_) => const HomeScreen()),
//                 );
//               },
//             ),
//             IconButton(
//               icon: const Icon(Icons.shopping_cart, size: 30, color: Colors.red),
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (_) => const CartScreen()),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'cart_provider.dart';
import 'home_screen.dart';
import 'cart_screen.dart';
import 'my_orders.dart'; // ✅ Added import

class SnacksScreen extends StatefulWidget {
  const SnacksScreen({Key? key}) : super(key: key);

  @override
  _SnacksScreenState createState() => _SnacksScreenState();
}

class _SnacksScreenState extends State<SnacksScreen> {
  List<dynamic> snackItems = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    fetchSnackItems();
  }

  Future<void> fetchSnackItems() async {
    final url = Uri.parse('http://192.168.252.228:5000/api/menu');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() => snackItems = data);
        final cartProvider = Provider.of<CartProvider>(context, listen: false);
        cartProvider.updateItemAvailability(snackItems);
      } else {
        print('Failed to load menu');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    final filteredItems = snackItems.where((item) {
      return item['name'].toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 184, 91, 76),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                        onPressed: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const HomeScreen()),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Menu',
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    onChanged: (value) => setState(() => searchQuery = value),
                    decoration: InputDecoration(
                      hintText: 'Search for snacks...',
                      hintStyle: const TextStyle(color: Colors.black),
                      prefixIcon: const Icon(Icons.search, color: Colors.black),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: snackItems.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : Container(
                      color: Colors.white,
                      child: RefreshIndicator(
                        onRefresh: fetchSnackItems,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(20),
                          itemCount: filteredItems.length,
                          itemBuilder: (context, index) {
                            final item = filteredItems[index];
                            final itemName = item['name'];
                            final isAvailable = item['isAvailable'] == true;
                            final isInCart = cartProvider.cartItems.containsKey(itemName);
                            final quantity = isInCart ? cartProvider.cartItems[itemName]['quantity'] : 0;

                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 6,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.grey[300],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.asset(
                                        'assets/images/${item['imageUrl']}',
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          print("Error loading image: ${item['imageUrl']}");
                                          return const Icon(Icons.fastfood, size: 40);
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item['name'],
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          "Rs. ${item['price']}",
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        if (!isAvailable)
                                          const Text(
                                            'Out of Stock',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                      ],
                                    ),
                                  ),
                                  if (!isAvailable)
                                    const SizedBox()
                                  else if (!isInCart)
                                    ElevatedButton(
                                      onPressed: () {
                                        cartProvider.addItem(item);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text("${item['name']} added to cart"),
                                            duration: const Duration(seconds: 1),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.brown[700],
                                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                      ),
                                      child: const Text(
                                        'ADD',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  else
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.remove, color: Colors.red),
                                          onPressed: () {
                                            cartProvider.decreaseQuantity(itemName);
                                          },
                                        ),
                                        Text(
                                          '$quantity',
                                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.add, color: Colors.green),
                                          onPressed: () {
                                            cartProvider.increaseQuantity(itemName);
                                          },
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10)],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home, size: 30, color: Colors.red),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.shopping_cart, size: 30, color: Colors.red),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CartScreen()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.receipt_long, size: 30, color: Colors.red),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MyOrdersPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

