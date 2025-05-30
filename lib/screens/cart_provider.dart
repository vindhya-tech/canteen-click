// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class CartProvider with ChangeNotifier {
//   Map<String, dynamic> cartItems = {};

//   void addItem(Map<String, dynamic> item) {
//     print("Adding item with image: ${item['image']}");
//     if (cartItems.containsKey(item['name'])) {
//       cartItems[item['name']]['quantity'] += 1;
//     } else {
//       cartItems[item['name']] = {
//         'name': item['name'],
//         'price': item['price'],
//         'quantity': 1,
//         'image': item['image'] ?? 'assets/default_image.png',
//         'isAvailable': item['isAvailable'] ?? true, // ✅ Add availability status
//       };
//     }
//     _saveCart();
//     notifyListeners();
//   }

//   void removeItem(String itemName) {
//     cartItems.remove(itemName);
//     _saveCart();
//     notifyListeners();
//   }

//   void increaseQuantity(String itemName) {
//     if (cartItems.containsKey(itemName)) {
//       cartItems[itemName]['quantity'] += 1;
//       _saveCart();
//       notifyListeners();
//     }
//   }

//   void decreaseQuantity(String itemName) {
//     if (cartItems.containsKey(itemName)) {
//       if (cartItems[itemName]['quantity'] > 1) {
//         cartItems[itemName]['quantity'] -= 1;
//       } else {
//         cartItems.remove(itemName);
//       }
//       _saveCart();
//       notifyListeners();
//     }
//   }

//   // Update availability status based on backend items
// void updateItemAvailability(List<dynamic> availableItems) {
//   cartItems.forEach((key, value) {
//     final match = availableItems.firstWhere(
//       (item) => item['name'] == key,
//       orElse: () => {'isAvailable': false},
//     );
//     cartItems[key]['isAvailable'] = match['isAvailable'] ?? false;
//   });
//   _saveCart();
//   notifyListeners();
// }


//   /// ✅ Exclude out-of-stock items from total
//   double getTotalAmount() {
//     double total = 0;
//     cartItems.forEach((key, value) {
//       if (value['isAvailable'] == true) {
//         total += value['price'] * value['quantity'];
//       }
//     });
//     return total;
//   }

//   Future<void> _saveCart() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setString('cart', json.encode(cartItems));
//   }

//   Future<void> loadCart() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? cartData = prefs.getString('cart');
//     if (cartData != null) {
//       Map<String, dynamic> loadedCart = Map<String, dynamic>.from(json.decode(cartData));
//       cartItems = loadedCart;
//       notifyListeners();
//     }
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartProvider with ChangeNotifier {
  Map<String, dynamic> cartItems = {};

  void addItem(Map<String, dynamic> item) {
    print("Adding item with image: ${item['image']}");
    if (cartItems.containsKey(item['name'])) {
      cartItems[item['name']]['quantity'] += 1;
    } else {
      cartItems[item['name']] = {
        'name': item['name'],
        'price': item['price'],
        'quantity': 1,
        'image': item['image'] ?? 'assets/default_image.png',
        'isAvailable': item['isAvailable'] ?? true, // ✅ Add availability status
      };
    }
    _saveCart();
    notifyListeners();
  }

  void removeItem(String itemName) {
    cartItems.remove(itemName);
    _saveCart();
    notifyListeners();
  }

  void increaseQuantity(String itemName) {
    if (cartItems.containsKey(itemName)) {
      cartItems[itemName]['quantity'] += 1;
      _saveCart();
      notifyListeners();
    }
  }

  void decreaseQuantity(String itemName) {
    if (cartItems.containsKey(itemName)) {
      if (cartItems[itemName]['quantity'] > 1) {
        cartItems[itemName]['quantity'] -= 1;
      } else {
        cartItems.remove(itemName);
      }
      _saveCart();
      notifyListeners();
    }
  }

  void updateItemAvailability(List<dynamic> availableItems) {
    cartItems.forEach((key, value) {
      final match = availableItems.firstWhere(
        (item) => item['name'] == key,
        orElse: () => {'isAvailable': false},
      );
      cartItems[key]['isAvailable'] = match['isAvailable'] ?? false;
    });
    _saveCart();
    notifyListeners();
  }

  double getTotalAmount() {
    double total = 0;
    cartItems.forEach((key, value) {
      if (value['isAvailable'] == true) {
        total += value['price'] * value['quantity'];
      }
    });
    return total;
  }

  Future<void> _saveCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('cart', json.encode(cartItems));
  }

  Future<void> loadCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cartData = prefs.getString('cart');
    if (cartData != null) {
      Map<String, dynamic> loadedCart = Map<String, dynamic>.from(json.decode(cartData));
      cartItems = loadedCart;
      notifyListeners();
    }
  }

  // ✅ FIX: Add this method to remove error
  void clearCart() {
    cartItems.clear();
    _saveCart();
    notifyListeners();
  }
}

