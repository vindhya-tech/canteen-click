// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'cart_provider.dart';
// import 'checkout_screen.dart';

// class CartScreen extends StatelessWidget {
//   const CartScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final cartProvider = Provider.of<CartProvider>(context);
//     final cart = cartProvider.cartItems.entries.toList();
//     final total = cartProvider.getTotalAmount();

//     final cartList = cart.map((e) {
//       final name = e.key;
//       final item = e.value;
//       return {
//         'name': name,
//         'image': item['image'],
//         'price': item['price'],
//         'quantity': item['quantity'],
//         'isAvailable': item['isAvailable'] ?? true, // Include availability status
//       };
//     }).toList();

//     // Filter out the items that are "Out of Stock"
//     final availableItems = cartList.where((item) => item['isAvailable'] == true).toList();

//     return Scaffold(
//       backgroundColor: Colors.red[900],
//       appBar: AppBar(
//         backgroundColor: Colors.red[900],
//         title: const Text(
//           "Cart",
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//             fontFamily: 'Lobster',
//           ),
//         ),
//         centerTitle: true,
//         elevation: 0,
//       ),
//       body: Container(
//         padding: const EdgeInsets.all(20),
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 20),
//             const Text(
//               "Cravings Delivered!",
//               style: TextStyle(
//                 fontSize: 22,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.black87,
//                 fontFamily: 'Roboto',
//               ),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 20),

//             Expanded(
//               child: cartList.isEmpty
//                   ? const Center(child: Text("Your cart is empty.", style: TextStyle(fontSize: 18)))
//                   : ListView.builder(
//                       itemCount: cartList.length,
//                       itemBuilder: (_, index) {
//                         final item = cartList[index];
//                         final imagePath = item['image'] != null && item['image'].isNotEmpty
//                             ? 'assets/images/${item['image']}'
//                             : 'assets/images/default_image.png';

//                         // Check if item is available
//                         final isAvailable = item['isAvailable'] ?? true;

//                         return Card(
//                           margin: const EdgeInsets.symmetric(vertical: 10),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(15),
//                           ),
//                           elevation: 5,
//                           child: ListTile(
//                             contentPadding: const EdgeInsets.all(12),
//                             leading: ClipRRect(
//                               borderRadius: BorderRadius.circular(10),
//                               child: Image.asset(
//                                 imagePath,
//                                 width: 60,
//                                 height: 60,
//                                 fit: BoxFit.cover,
//                                 errorBuilder: (context, error, stackTrace) =>
//                                     const Icon(Icons.broken_image, size: 60),
//                               ),
//                             ),
//                             title: Text(
//                               item['name'],
//                               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//                             ),
//                             subtitle: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'Rs. ${item['price']}',
//                                   style: const TextStyle(fontSize: 16, color: Colors.grey),
//                                 ),
//                                 if (!isAvailable)
//                                   const Text(
//                                     'Out of Stock',
//                                     style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
//                                   ),
//                               ],
//                             ),
//                             trailing: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 // Disable the buttons if the item is out of stock
//                                 IconButton(
//                                   icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
//                                   onPressed: isAvailable
//                                       ? () => cartProvider.decreaseQuantity(item['name'])
//                                       : null, // Disable button if out of stock
//                                 ),
//                                 Text(
//                                   '${item['quantity']}',
//                                   style: const TextStyle(fontSize: 16),
//                                 ),
//                                 IconButton(
//                                   icon: const Icon(Icons.add_circle_outline, color: Colors.green),
//                                   onPressed: isAvailable
//                                       ? () => cartProvider.increaseQuantity(item['name'])
//                                       : null, // Disable button if out of stock
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//             ),

//             Container(
//               padding: const EdgeInsets.all(20),
//               color: Colors.grey[200],
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text("To Pay:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
//                   const SizedBox(height: 10),
//                   ...cartList.map((item) => Text(
//                     "${item['name']} x${item['quantity']} : Rs. ${int.parse(item['price'].toString()) * item['quantity']}",
//                     style: const TextStyle(fontSize: 16),
//                   )),
//                   const Divider(thickness: 1, color: Colors.black45),
//                   Text(
//                     "Total Amount : Rs. ${total.toStringAsFixed(2)} /-",
//                     style: const TextStyle(
//                         fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87),
//                   ),
//                   const SizedBox(height: 20),
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: () {
//                         if (availableItems.isNotEmpty) { // Only navigate if there are available items
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (_) => CheckoutScreen(
//                                 cartItems: availableItems, // Pass only available items
//                                 totalAmount: total.toDouble(),
//                               ),
//                             ),
//                           );
//                         }
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.red[700],
//                         padding: const EdgeInsets.symmetric(vertical: 15),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         elevation: 5,
//                       ),
//                       child: const Text(
//                         "Proceed to Payment",
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,  // <-- Text color changed to white here
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// cart_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_provider.dart';
import 'checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cart = cartProvider.cartItems.entries.toList();
    final total = cartProvider.getTotalAmount();

    final cartList = cart.map((e) {
      final name = e.key;
      final item = e.value;
      return {
        'name': name,
        'image': item['image'],
        'price': item['price'],
        'quantity': item['quantity'],
        'isAvailable': item['isAvailable'] ?? true,
      };
    }).toList();

    final availableItems = cartList.where((item) => item['isAvailable'] == true).toList();

    return Scaffold(
      backgroundColor: Colors.red[900],
      appBar: AppBar(
        backgroundColor: Colors.red[900],
        title: const Text(
          "Cart",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'Lobster',
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              "Cravings Delivered!",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
                fontFamily: 'Roboto',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: cartList.isEmpty
                  ? const Center(child: Text("Your cart is empty.", style: TextStyle(fontSize: 18)))
                  : ListView.builder(
                      itemCount: cartList.length,
                      itemBuilder: (_, index) {
                        final item = cartList[index];
                        final isAvailable = item['isAvailable'] ?? true;

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 5,
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(12),
                            title: Text(
                              item['name'],
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Rs. ${item['price']}',
                                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                                ),
                                if (!isAvailable)
                                  const Text(
                                    'Out of Stock',
                                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                                  ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                                  onPressed: isAvailable
                                      ? () => cartProvider.decreaseQuantity(item['name'])
                                      : null,
                                ),
                                Text(
                                  '${item['quantity']}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline, color: Colors.green),
                                  onPressed: isAvailable
                                      ? () => cartProvider.increaseQuantity(item['name'])
                                      : null,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.grey[200],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("To Pay:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 10),
                  ...cartList.map((item) => Text(
                        "${item['name']} x${item['quantity']} : Rs. ${int.parse(item['price'].toString()) * item['quantity']}",
                        style: const TextStyle(fontSize: 16),
                      )),
                  const Divider(thickness: 1, color: Colors.black45),
                  Text(
                    "Total Amount : Rs. ${total.toStringAsFixed(2)} /-",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (availableItems.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CheckoutScreen(
                                cartItems: availableItems,
                                totalAmount: total.toDouble(),
                              ),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[700],
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 5,
                      ),
                      child: const Text(
                        "Proceed to Payment",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
