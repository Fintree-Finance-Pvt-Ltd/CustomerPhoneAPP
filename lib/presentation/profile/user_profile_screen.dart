import 'package:flutter/material.dart';
import '../../core/services/api_service.dart';

class UserProfileScreen extends StatefulWidget {
  final int customerId;

  const UserProfileScreen({
    super.key,
    required this.customerId,
  });

  @override
  State<UserProfileScreen> createState() =>
      _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  bool isLoading = true;
  Map<String, dynamic> profile = {};

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      profile = await ApiService.getProfile(widget.customerId);
    } catch (e) {
      debugPrint("Profile API error: $e");
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
        backgroundColor: const Color(0xFF0D47A1),
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
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

                  Text(
                    profile["name"] ?? "-",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    "Customer ID: ${profile["id"]}",
                    style: const TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 30),

                  _infoTile(
                    "Mobile Number",
                    profile["phone"] ?? "-",
                    Icons.phone,
                  ),
                  _infoTile(
                    "Email",
                    profile["email"] ?? "-",
                    Icons.email,
                  ),
                  _infoTile(
                    "Address",
                    profile["address"] ?? "-",
                    Icons.location_on,
                  ),
                  _infoTile(
                    "Account Status",
                    "Active",
                    Icons.check_circle,
                  ),
                ],
              ),
            ),
    );
  }

  Widget _infoTile(
      String label, String value, IconData icon) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF0D47A1)),
        title: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(value),
      ),
    );
  }
}
