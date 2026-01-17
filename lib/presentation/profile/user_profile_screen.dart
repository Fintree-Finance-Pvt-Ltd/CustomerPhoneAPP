import 'package:flutter/material.dart';

class UserProfileScreen extends StatelessWidget {
  final Map<String, dynamic> customerData;

  const UserProfileScreen({
    super.key,
    required this.customerData,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
        backgroundColor: const Color(0xFF0D47A1),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Profile Header
            CircleAvatar(
              radius: 45,
              backgroundColor: Colors.blue.shade100,
              child: const Icon(
                Icons.person,
                size: 50,
                color: Color(0xFF0D47A1),
              ),
            ),

            const SizedBox(height: 16),

            // Name from dashboard data
            Text(
              customerData["name"],
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            // Customer ID
            Text(
              "Customer ID: ${customerData["customerId"]}",
              style: const TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 30),

            _infoTile("Mobile Number", customerData["phone"], Icons.phone),
            _infoTile("Email", customerData["email"], Icons.email),
            _infoTile("Address", customerData["address"], Icons.location_on),
            _infoTile("Account Status", "Active", Icons.check_circle),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(String label, String value, IconData icon) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF0D47A1)),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(value),
      ),
    );
  }
}
