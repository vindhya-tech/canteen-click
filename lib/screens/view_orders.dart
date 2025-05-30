// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'manage_menu_items.dart';
// import 'view_payments.dart';

// class ViewOrdersPage extends StatefulWidget {
//   const ViewOrdersPage({super.key});

//   @override
//   State<ViewOrdersPage> createState() => _ViewOrdersPageState();
// }

// class _ViewOrdersPageState extends State<ViewOrdersPage> {
//   List<dynamic> orders = [];
//   bool isLoading = true;
//   String error = '';
//   int _selectedIndex = 1; // Set Orders tab active

//   @override
//   void initState() {
//     super.initState();
//     fetchOrders();
//   }

//   Future<void> fetchOrders() async {
//     try {
//       final response =
//           await http.get(Uri.parse('http://10.0.2.2:5000/api/orders'));

//       if (response.statusCode == 200) {
//         setState(() {
//           orders = json.decode(response.body);
//           isLoading = false;
//         });
//       } else {
//         throw Exception('Failed to load orders: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Fetch Orders Error: $e');
//       setState(() {
//         isLoading = false;
//         error = 'Failed to load orders.';
//       });
//     }
//   }

//   Future<void> markAsCompleted(String orderId) async {
//     final url = 'http://10.0.2.2:5000/api/orders/$orderId/complete';
//     try {
//       final response = await http.patch(Uri.parse(url));

//       if (response.statusCode == 200) {
//         fetchOrders(); // Refresh
//       } else {
//         throw Exception('Failed to update order status');
//       }
//     } catch (e) {
//       print('Error marking completed: $e');
//     }
//   }

//   void _onItemTapped(int index) {
//     if (index == _selectedIndex) return; // Stay if same tab

//     if (index == 0) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => ManageMenuItemsPage()),
//       );
//     } else if (index == 2) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => const ViewPaymentsPage()),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final activeOrders =
//         orders.where((order) => order['status'] == 'active').toList();
//     final completedOrders =
//         orders.where((order) => order['status'] == 'completed').toList();

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'View Orders',
//           style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
//         ),
//         backgroundColor: Colors.red,
//         elevation: 0,
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : error.isNotEmpty
//               ? Center(child: Text(error))
//               : SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       if (activeOrders.isNotEmpty) ...[
//                         const Padding(
//                           padding: EdgeInsets.all(10),
//                           child: Text(
//                             "Active Orders",
//                             style: TextStyle(
//                                 fontWeight: FontWeight.bold, fontSize: 18),
//                           ),
//                         ),
//                         ...activeOrders
//                             .map((order) =>
//                                 _buildOrderCard(order, isCompleted: false))
//                             .toList(),
//                       ],
//                       if (completedOrders.isNotEmpty) ...[
//                         const Padding(
//                           padding: EdgeInsets.all(10),
//                           child: Text(
//                             "Completed Orders",
//                             style: TextStyle(
//                                 fontWeight: FontWeight.bold, fontSize: 18),
//                           ),
//                         ),
//                         ...completedOrders
//                             .map((order) =>
//                                 _buildOrderCard(order, isCompleted: true))
//                             .toList(),
//                       ]
//                     ],
//                   ),
//                 ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _selectedIndex,
//         onTap: _onItemTapped,
//         selectedItemColor: Colors.black,
//         unselectedItemColor: Colors.grey[600],
//         showUnselectedLabels: true,
//         selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
//         unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.restaurant_menu),
//             label: 'Manage',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.receipt_long),
//             label: 'Orders',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.payments),
//             label: 'Payments',
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildOrderCard(dynamic order, {bool isCompleted = false}) {
//     return Card(
//       margin: const EdgeInsets.all(10),
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("Order ID: ${order['orderID']}",
//                 style: const TextStyle(
//                     fontWeight: FontWeight.bold, fontSize: 16)),
//             const SizedBox(height: 5),
//             ...List<Widget>.from(order['items'].map<Widget>((item) => Text(
//                 "${item['name']} x${item['quantity']} - Rs.${item['price']}",
//                 style: const TextStyle(fontSize: 14)))),
//             const SizedBox(height: 5),
//             Text("Total: Rs. ${order['totalAmount']}",
//                 style: const TextStyle(fontSize: 16)),
//             const SizedBox(height: 5),
//             Text("Status: ${order['status']}",
//                 style: const TextStyle(fontSize: 14)),
//             if (order['place'] != null)
//               Container(
//                 margin: const EdgeInsets.only(top: 6),
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//                 decoration: BoxDecoration(
//                   color: Colors.orange.shade100,
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(color: Colors.orange),
//                 ),
//                 child: Text(
//                   "Place: ${order['place']}",
//                   style: const TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.orange),
//                 ),
//               ),
//             Text("Time: ${order['timestamp'].toString()}",
//                 style: const TextStyle(fontSize: 14)),
//             const SizedBox(height: 5),
//             if (!isCompleted)
//               Align(
//                 alignment: Alignment.centerRight,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.green,
//                       foregroundColor: Colors.white),
//                   onPressed: () => markAsCompleted(order['_id']),
//                   child: const Text('Mark as Completed'),
//                 ),
//               )
//           ],
//         ),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'manage_menu_items.dart';
// import 'view_payments.dart';

// class ViewOrdersPage extends StatefulWidget {
//   const ViewOrdersPage({super.key});

//   @override
//   State<ViewOrdersPage> createState() => _ViewOrdersPageState();
// }

// class _ViewOrdersPageState extends State<ViewOrdersPage> {
//   List<dynamic> orders = [];
//   bool isLoading = true;
//   String error = '';
//   int _selectedIndex = 1; // Set Orders tab active
//   bool showActive = true; // Toggle for showing active/completed orders

//   @override
//   void initState() {
//     super.initState();
//     fetchOrders();
//   }

//   Future<void> fetchOrders() async {
//     try {
//       final response =
//           await http.get(Uri.parse('http://10.0.2.2:5000/api/orders'));

//       if (response.statusCode == 200) {
//         setState(() {
//           orders = json.decode(response.body);
//           isLoading = false;
//         });
//       } else {
//         throw Exception('Failed to load orders: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Fetch Orders Error: $e');
//       setState(() {
//         isLoading = false;
//         error = 'Failed to load orders.';
//       });
//     }
//   }

//   Future<void> markAsCompleted(String orderId) async {
//     final url = 'http://10.0.2.2:5000/api/orders/$orderId/complete';
//     try {
//       final response = await http.patch(Uri.parse(url));

//       if (response.statusCode == 200) {
//         fetchOrders(); // Refresh orders
//       } else {
//         throw Exception('Failed to update order status');
//       }
//     } catch (e) {
//       print('Error marking completed: $e');
//     }
//   }

//   void _onItemTapped(int index) {
//     if (index == _selectedIndex) return;

//     if (index == 0) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => ManageMenuItemsPage()),
//       );
//     } else if (index == 2) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => const ViewPaymentsPage()),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final activeOrders =
//         orders.where((order) => order['status'] == 'active').toList();
//     final completedOrders =
//         orders.where((order) => order['status'] == 'completed').toList();

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'View Orders',
//           style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
//         ),
//         backgroundColor: Colors.red,
//         elevation: 0,
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : error.isNotEmpty
//               ? Center(child: Text(error))
//               : Column(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(10),
//                       child: Row(
//                         children: [
//                           Expanded(
//                             child: ElevatedButton(
//                               onPressed: () {
//                                 setState(() {
//                                   showActive = true;
//                                 });
//                               },
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: showActive
//                                     ? Colors.red
//                                     : Colors.grey[300],
//                                 foregroundColor: showActive
//                                     ? Colors.white
//                                     : Colors.black,
//                               ),
//                               child: const Text('Active'),
//                             ),
//                           ),
//                           const SizedBox(width: 10),
//                           Expanded(
//                             child: ElevatedButton(
//                               onPressed: () {
//                                 setState(() {
//                                   showActive = false;
//                                 });
//                               },
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: !showActive
//                                     ? Colors.red
//                                     : Colors.grey[300],
//                                 foregroundColor: !showActive
//                                     ? Colors.white
//                                     : Colors.black,
//                               ),
//                               child: const Text('Completed'),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Expanded(
//                       child: SingleChildScrollView(
//                         child: Column(
//                           children: showActive
//                               ? activeOrders
//                                   .map((order) => _buildOrderCard(order,
//                                       isCompleted: false))
//                                   .toList()
//                               : completedOrders
//                                   .map((order) =>
//                                       _buildOrderCard(order, isCompleted: true))
//                                   .toList(),
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _selectedIndex,
//         onTap: _onItemTapped,
//         selectedItemColor: Colors.black,
//         unselectedItemColor: Colors.grey[600],
//         showUnselectedLabels: true,
//         selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
//         unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.restaurant_menu),
//             label: 'Manage',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.receipt_long),
//             label: 'Orders',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.payments),
//             label: 'Payments',
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildOrderCard(dynamic order, {bool isCompleted = false}) {
//     return Card(
//       margin: const EdgeInsets.all(10),
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("Order ID: ${order['orderID']}",
//                 style: const TextStyle(
//                     fontWeight: FontWeight.bold, fontSize: 16)),
//             const SizedBox(height: 5),
//             ...List<Widget>.from(order['items'].map<Widget>((item) => Text(
//                 "${item['name']} x${item['quantity']} - Rs.${item['price']}",
//                 style: const TextStyle(fontSize: 14)))),
//             const SizedBox(height: 5),
//             Text("Total: Rs. ${order['totalAmount']}",
//                 style: const TextStyle(fontSize: 16)),
//             const SizedBox(height: 5),
//             Text("Status: ${order['status']}",
//                 style: const TextStyle(fontSize: 14)),
//             if (order['place'] != null)
//               Container(
//                 margin: const EdgeInsets.only(top: 6),
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//                 decoration: BoxDecoration(
//                   color: Colors.orange.shade100,
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(color: Colors.orange),
//                 ),
//                 child: Text(
//                   "Place: ${order['place']}",
//                   style: const TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.orange),
//                 ),
//               ),
//             Text("Time: ${order['timestamp'].toString()}",
//                 style: const TextStyle(fontSize: 14)),
//             const SizedBox(height: 5),
//             if (!isCompleted)
//               Align(
//                 alignment: Alignment.centerRight,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.green,
//                       foregroundColor: Colors.white),
//                   onPressed: () => markAsCompleted(order['_id']),
//                   child: const Text('Mark as Completed'),
//                 ),
//               )
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'manage_menu_items.dart';
import 'view_payments.dart';

class ViewOrdersPage extends StatefulWidget {
  const ViewOrdersPage({super.key});

  @override
  State<ViewOrdersPage> createState() => _ViewOrdersPageState();
}

class _ViewOrdersPageState extends State<ViewOrdersPage> {
  List<dynamic> orders = [];
  bool isLoading = true;
  String error = '';
  int _selectedIndex = 1;
  bool showActive = true;

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    try {
      //final response = await http.get(Uri.parse('http://192.168.65.228:5000/api/orders'));
      final response = await http.get(Uri.parse('http://192.168.252.228:5000/api/orders'));

      if (response.statusCode == 200) {
        setState(() {
          orders = json.decode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load orders: ${response.statusCode}');
      }
    } catch (e) {
      print('Fetch Orders Error: $e');
      setState(() {
        isLoading = false;
        error = 'Failed to load orders.';
      });
    }
  }

  Future<void> markAsCompleted(String orderId) async {
    final url = 'http://192.168.252.228:5000/api/orders/$orderId/complete';
    try {
      final response = await http.patch(Uri.parse(url));

      if (response.statusCode == 200) {
        fetchOrders();
      } else {
        throw Exception('Failed to update order status');
      }
    } catch (e) {
      print('Error marking completed: $e');
    }
  }

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => ManageMenuItemsPage()),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ViewPaymentsPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeOrders = orders.where((order) => order['status'] == 'active').toList();

    // Sort completed orders by timestamp descending (most recent first)
    final completedOrders = orders
        .where((order) => order['status'] == 'completed')
        .toList()
      ..sort((a, b) {
        final aTime = DateTime.tryParse(a['timestamp'] ?? '') ?? DateTime(1970);
        final bTime = DateTime.tryParse(b['timestamp'] ?? '') ?? DateTime(1970);
        return bTime.compareTo(aTime);
      });

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'View Orders',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.red,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error.isNotEmpty
              ? Center(child: Text(error))
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  showActive = true;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: showActive ? Colors.red : Colors.grey[300],
                                foregroundColor: showActive ? Colors.white : Colors.black,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Active',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  showActive = false;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: !showActive ? Colors.red : Colors.grey[300],
                                foregroundColor: !showActive ? Colors.white : Colors.black,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Completed',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: (showActive ? activeOrders : completedOrders).isEmpty
                          ? Center(
                              child: Text(
                                showActive ? 'No active orders.' : 'No completed orders.',
                                style: const TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              itemCount: (showActive ? activeOrders : completedOrders).length,
                              itemBuilder: (context, index) {
                                final order = (showActive ? activeOrders : completedOrders)[index];
                                return _buildOrderCard(order, isCompleted: !showActive);
                              },
                            ),
                    ),
                  ],
                ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey[600],
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: 'Manage',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payments),
            label: 'Payments',
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(dynamic order, {bool isCompleted = false}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Order ID: ${order['orderID']}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),
            ...List<Widget>.from(order['items'].map<Widget>((item) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        "${item['name']} x${item['quantity']}",
                        style: const TextStyle(fontSize: 15),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      "Rs. ${item['price']}",
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              );
            })),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total: Rs. ${order['totalAmount']}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Status: ${order['status']}",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: order['status'] == 'active' ? Colors.green : Colors.grey[700],
                  ),
                ),
              ],
            ),
            if (order['place'] != null)
              Container(
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange),
                ),
                child: Text(
                  "Place: ${order['place']}",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ),
            const SizedBox(height: 10),
            Text(
              "Time: ${order['timestamp'].toString()}",
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
            if (!isCompleted)
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding:
                          const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () => markAsCompleted(order['_id']),
                    child: const Text(
                      'Mark as Completed',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
