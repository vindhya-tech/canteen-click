// import 'package:flutter/material.dart';
// import 'package:flutter_app_1/screens/home_screen.dart';
// import 'package:flutter_app_1/screens/staff_dashboard.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final TextEditingController idController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();

//   String _selectedRole = 'Student';

//   void _login() async {
//     final id = idController.text.trim();
//     final password = passwordController.text.trim();

//     if (id.isEmpty || password.isEmpty) {
//       _showMessage("Please enter ID and Password.");
//       return;
//     }

//     try {
//       final response = await http.post(
//         Uri.parse('http://10.0.2.2:5000/api/auth/login'), // Ensure this is your correct backend address
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode({
//           'role': _selectedRole,
//           'id': id,
//           'password': password,
//         }),
//       );

//       final responseData = json.decode(response.body);

//       if (response.statusCode == 200) {
//         final token = responseData['token'];
//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setString('auth_token', token);

//         if (_selectedRole == 'Student') {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => const HomeScreen()),
//           );
//         } else {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => const StaffDashboard()),
//           );
//         }
//       } else {
//         _showMessage(responseData['message'] ?? 'Login failed');
//       }
//     } catch (e) {
//       _showMessage("An error occurred: $e");
//     }
//   }

//   void _showSignupDialog() {
//     final TextEditingController signupRollController = TextEditingController();
//     final TextEditingController signupPassController = TextEditingController();

//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text("Student Signup"),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               controller: signupRollController,
//               decoration: const InputDecoration(labelText: "Roll No."),
//             ),
//             TextField(
//               controller: signupPassController,
//               obscureText: true,
//               decoration: const InputDecoration(labelText: "Password"),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text("Cancel"),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               final roll = signupRollController.text.trim();
//               final pass = signupPassController.text.trim();

//               if (roll.length != 10 || !roll.toLowerCase().contains("bd")) {
//                 _showMessage("Invalid Roll no.");
//               } else {
//                 try {
//                   final response = await http.post(
//                     Uri.parse('http://10.0.2.2:5000/api/auth/signup'),
//                     headers: {'Content-Type': 'application/json'},
//                     body: json.encode({
//                       'rollNo': roll,
//                       'password': pass,
//                     }),
//                   );

//                   final responseData = json.decode(response.body);
//                   if (response.statusCode == 201) {
//                     Navigator.pop(context);
//                     _showMessage("Signup successful! You can now login.");
//                   } else {
//                     _showMessage(responseData['message'] ?? 'Signup failed');
//                   }
//                 } catch (e) {
//                   _showMessage("An error occurred: $e");
//                 }
//               }
//             },
//             child: const Text("Sign Up"),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showMessage(String msg) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           Container(
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Color(0xFFFF416C), Color(0xFFFF4B2B)],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//               borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
//             ),
//             padding: const EdgeInsets.fromLTRB(16, 40, 16, 24),
//             child: Center(
//               child: const Text(
//                 'Login',
//                 style: TextStyle(
//                   fontSize: 34,
//                   fontWeight: FontWeight.bold,
//                   fontFamily: 'Pacifico',
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(height: 20),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               _buildRoleButton("Student"),
//               const SizedBox(width: 20),
//               _buildRoleButton("Staff"),
//             ],
//           ),
//           const SizedBox(height: 30),
//           _buildInputField(
//             _selectedRole == "Student" ? "Roll No." : "ID Number",
//             idController,
//           ),
//           const SizedBox(height: 20),
//           _buildInputField("Password", passwordController, isPassword: true),
//           const SizedBox(height: 30),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 24),
//             child: ElevatedButton(
//               onPressed: _login,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFFFF2E2E),
//                 minimumSize: const Size.fromHeight(50),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(25),
//                 ),
//               ),
//               child: const Text(
//                 'Login',
//                 style: TextStyle(fontSize: 18, color: Colors.white),
//               ),
//             ),
//           ),
//           const SizedBox(height: 15),
//           if (_selectedRole == "Student")
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 24),
//               child: TextButton(
//                 onPressed: _showSignupDialog,
//                 child: const Text("Don't have an account? Sign up here"),
//               ),
//             ),
//           const Spacer(),
//         ],
//       ),
//     );
//   }

//   Widget _buildInputField(String hint, TextEditingController controller, {bool isPassword = false}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 24),
//       child: TextField(
//         controller: controller,
//         obscureText: isPassword,
//         decoration: InputDecoration(
//           hintText: hint,
//           filled: true,
//           fillColor: Colors.grey[100],
//           contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(25),
//             borderSide: BorderSide.none,
//           ),
//         ),
//         style: const TextStyle(fontSize: 16),
//       ),
//     );
//   }

//   Widget _buildRoleButton(String role) {
//     final isSelected = _selectedRole == role;
//     return GestureDetector(
//       onTap: () => setState(() => _selectedRole = role),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
//         decoration: BoxDecoration(
//           color: isSelected ? Colors.red : Colors.grey[300],
//           borderRadius: BorderRadius.circular(30),
//           boxShadow: isSelected
//               ? [
//                   const BoxShadow(
//                     color: Colors.redAccent,
//                     offset: Offset(0, 4),
//                     blurRadius: 8,
//                   ),
//                 ]
//               : [],
//         ),
//         child: Text(
//           role,
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//             color: isSelected ? Colors.white : Colors.red,
//           ),
//         ),
//       ),
//     );
//   }
// }
 
import 'package:flutter/material.dart';
import 'package:flutter_app_1/screens/home_screen.dart';
import 'package:flutter_app_1/screens/staff_dashboard.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController idController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String _selectedRole = 'Student';

  void _login() async {
    final id = idController.text.trim();
    final password = passwordController.text.trim();

    if (id.isEmpty || password.isEmpty) {
      _showMessage("Please enter ID and Password.");
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://192.168.252.228:5000/api/auth/login'), // Ensure this is your correct backend address
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'role': _selectedRole,
          'id': id,
          'password': password,
        }),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        final token = responseData['token'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);

        if (_selectedRole == 'Student') {
          // Save the roll number so it can be shown in profile dropdown on home screen
          await prefs.setString('roll_no', id);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const StaffDashboard()),
          );
        }
      } else {
        _showMessage(responseData['message'] ?? 'Login failed');
      }
    } catch (e) {
      _showMessage("An error occurred: $e");
    }
  }

  void _showSignupDialog() {
    final TextEditingController signupRollController = TextEditingController();
    final TextEditingController signupPassController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Student Signup"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: signupRollController,
              decoration: const InputDecoration(labelText: "Roll No."),
            ),
            TextField(
              controller: signupPassController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              final roll = signupRollController.text.trim();
              final pass = signupPassController.text.trim();

              if (roll.length != 10 || !roll.toLowerCase().contains("bd")) {
                _showMessage("Invalid Roll no.");
              } else {
                try {
                  final response = await http.post(
                    Uri.parse('http://192.168.252.228:5000/api/auth/signup'),
                    headers: {'Content-Type': 'application/json'},
                    body: json.encode({
                      'rollNo': roll,
                      'password': pass,
                    }),
                  );

                  final responseData = json.decode(response.body);
                  if (response.statusCode == 201) {
                    Navigator.pop(context);
                    _showMessage("Signup successful! You can now login.");
                  } else {
                    _showMessage(responseData['message'] ?? 'Signup failed');
                  }
                } catch (e) {
                  _showMessage("An error occurred: $e");
                }
              }
            },
            child: const Text("Sign Up"),
          ),
        ],
      ),
    );
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFF416C), Color(0xFFFF4B2B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
            padding: const EdgeInsets.fromLTRB(16, 40, 16, 24),
            child: Center(
              child: const Text(
                'Login',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Pacifico',
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildRoleButton("Student"),
              const SizedBox(width: 20),
              _buildRoleButton("Staff"),
            ],
          ),
          const SizedBox(height: 30),
          _buildInputField(
            _selectedRole == "Student" ? "Roll No." : "ID Number",
            idController,
          ),
          const SizedBox(height: 20),
          _buildInputField("Password", passwordController, isPassword: true),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF2E2E),
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text(
                'Login',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 15),
          if (_selectedRole == "Student")
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: TextButton(
                onPressed: _showSignupDialog,
                child: const Text("Don't have an account? Sign up here"),
              ),
            ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildInputField(String hint, TextEditingController controller, {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.grey[100],
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none,
          ),
        ),
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _buildRoleButton(String role) {
    final isSelected = _selectedRole == role;
    return GestureDetector(
      onTap: () => setState(() => _selectedRole = role),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.red : Colors.grey[300],
          borderRadius: BorderRadius.circular(30),
          boxShadow: isSelected
              ? [
                  const BoxShadow(
                    color: Colors.redAccent,
                    offset: Offset(0, 4),
                    blurRadius: 8,
                  ),
                ]
              : [],
        ),
        child: Text(
          role,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : Colors.red,
          ),
        ),
      ),
    );
  }
}
