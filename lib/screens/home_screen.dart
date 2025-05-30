// import 'package:flutter/material.dart';
// import 'cart_screen.dart';
// import 'snacks_screen.dart';

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.red[900],
//       body: SafeArea(
//         child: Column(
//           children: [
//             // Top Section (Title + Cart)
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text(
//                     'Canteen Menu',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 28,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.shopping_cart, color: Colors.white, size: 30),
//                     onPressed: () => Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (_) => const CartScreen()),
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             // Main Content Area
//             Expanded(
//               child: Container(
//                 width: double.infinity,
//                 decoration: const BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(40),
//                     topRight: Radius.circular(40),
//                   ),
//                 ),
//                 padding: const EdgeInsets.all(20),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const SizedBox(height: 20),
//                     const Text(
//                       'Enjoy Your Meal',
//                       style: TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.black87,
//                       ),
//                     ),
//                     const SizedBox(height: 30),

//                     // Menu Button
//                     MenuButton(
//                       title: 'MENU',
//                       image: 'assets/images/snacks.jpg',
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(builder: (_) => const SnacksScreen()),
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class MenuButton extends StatelessWidget {
//   final String title;
//   final String image;
//   final VoidCallback onTap;

//   const MenuButton({
//     Key? key,
//     required this.title,
//     required this.image,
//     required this.onTap,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         height: 140,
//         margin: const EdgeInsets.symmetric(vertical: 10), // Adjusted margin for better spacing
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: const [
//             BoxShadow(
//               color: Colors.black12,
//               blurRadius: 10,
//               offset: Offset(0, 5),
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             // Image Section
//             ClipRRect(
//               borderRadius: const BorderRadius.only(
//                 topLeft: Radius.circular(20),
//                 bottomLeft: Radius.circular(20),
//               ),
//               child: Image.asset(
//                 image,
//                 width: 130,
//                 height: 130,
//                 fit: BoxFit.cover,
//               ),
//             ),
//             const SizedBox(width: 20),

//             // Text
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 10),
//                 child: Text(
//                   title,
//                   style: const TextStyle(
//                     fontSize: 26,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.black87,
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(width: 20),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cart_screen.dart';
import 'snacks_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? rollNo;

  @override
  void initState() {
    super.initState();
    _loadRollNo();
  }

  Future<void> _loadRollNo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      rollNo = prefs.getString('roll_no') ?? 'Unknown';
    });
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // clear all stored user data

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[900],
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Profile icon on left with dropdown
                  PopupMenuButton<int>(
                    icon: const Icon(Icons.account_circle, size: 32, color: Colors.white),
                    onSelected: (item) {
                      if (item == 1) {
                        _logout();
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem<int>(
                        enabled: false,
                        child: Text(
                          'Roll No: ${rollNo ?? ''}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const PopupMenuDivider(),
                      PopupMenuItem<int>(
                        value: 1,
                        child: Row(
                          children: const [
                            Icon(Icons.logout, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Logout', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Title centered
                  const Text(
                    'Canteen Menu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // Cart icon on right
                  IconButton(
                    icon: const Icon(Icons.shopping_cart, color: Colors.white, size: 30),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CartScreen()),
                    ),
                  ),
                ],
              ),
            ),

            // Rest of your UI unchanged
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      'Enjoy Your Meal',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 30),
                    MenuButton(
                      title: 'MENU',
                      image: 'assets/images/snacks.jpg',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const SnacksScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MenuButton extends StatelessWidget {
  final String title;
  final String image;
  final VoidCallback onTap;

  const MenuButton({
    Key? key,
    required this.title,
    required this.image,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 140,
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
              child: Image.asset(
                image,
                width: 130,
                height: 130,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 20),
          ],
        ),
      ),
    );
  }
}
