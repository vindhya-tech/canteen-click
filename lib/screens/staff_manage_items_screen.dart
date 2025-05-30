import 'dart:io'; // For File
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class StaffManageItemsScreen extends StatefulWidget {
  const StaffManageItemsScreen({super.key});

  @override
  State<StaffManageItemsScreen> createState() => _StaffManageItemsScreenState();
}

class _StaffManageItemsScreenState extends State<StaffManageItemsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ImagePicker _picker = ImagePicker();

  // Item lists
  final List<Map<String, dynamic>> breakfastItems = [
    {'name': 'Idli', 'price': 30, 'available': true, 'image': null},
    {'name': 'Dosa', 'price': 40, 'available': false, 'image': null},
  ];
  final List<Map<String, dynamic>> lunchItems = [];
  final List<Map<String, dynamic>> snacksItems = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  Future<void> _pickImage(List<Map<String, dynamic>> list, int index) async {
    // Picking image
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        list[index]['image'] = pickedFile.path; // Store local path or URL if uploaded to cloud
      });
    }
  }

  void _addItem(List<Map<String, dynamic>> list, String category) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController priceController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Add $category Item'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Item Name"),
            ),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Price"),
            ),
            // Image Picker Button
            ElevatedButton.icon(
              onPressed: () async {
                await _pickImage(list, list.length); // Get image for the new item
              },
              icon: Icon(Icons.image),
              label: Text("Pick Image"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              final name = nameController.text.trim();
              final price = double.tryParse(priceController.text.trim());
              if (name.isNotEmpty && price != null) {
                setState(() {
                  list.add({'name': name, 'price': price, 'available': true, 'image': null});
                });
                Navigator.pop(context);
              }
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  Widget _buildItemTile(List<Map<String, dynamic>> list, int index) {
    final item = list[index];
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: ListTile(
        leading: item['image'] != null
            ? Image.file(File(item['image']), width: 50, height: 50, fit: BoxFit.cover) // Display image
            : Icon(Icons.image, size: 50), // Placeholder if no image
        title: Text(item['name']),
        subtitle: Text("Rs. ${item['price']}"),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Switch(
              value: item['available'],
              onChanged: (val) {
                setState(() {
                  item['available'] = val;
                });
              },
              activeColor: Colors.green,
              inactiveThumbColor: Colors.red,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.grey),
              onPressed: () {
                setState(() {
                  list.removeAt(index);
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent(String category, List<Map<String, dynamic>> list) {
    return Column(
      children: [
        Expanded(
          child: list.isEmpty
              ? const Center(child: Text("No items yet"))
              : ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) =>
                      _buildItemTile(list, index),
                ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton.icon(
            onPressed: () => _addItem(list, category),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8B2E2E),
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            icon: const Icon(Icons.add),
            label: Text("Add $category Item"),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8B2E2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF8B2E2E),
        title: const Text("Manage Menu"),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Breakfast"),
            Tab(text: "Lunch"),
            Tab(text: "Snacks"),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildTabContent("Breakfast", breakfastItems),
            _buildTabContent("Lunch", lunchItems),
            _buildTabContent("Snacks", snacksItems),
          ],
        ),
      ),
    );
  }
}
