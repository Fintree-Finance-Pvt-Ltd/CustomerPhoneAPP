import 'package:flutter/material.dart';
import '../../core/services/api_service.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  bool isLoading = true;
  Map<String, dynamic> profile = {};

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  // ================= LOAD PROFILE (JWT ONLY) =================
  Future<void> loadProfile() async {
    try {
      debugPrint("Profile → loading via JWT");

      // ✅ SINGLE JWT-BASED API
      profile = await ApiService.getProfile();
    } catch (e) {
      debugPrint("Profile API error: $e");
      profile = {};
    }

    if (mounted) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final String fullName =
        "${profile['first_name'] ?? ''} ${profile['last_name'] ?? ''}".trim();

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
        backgroundColor: const Color(0xFF0D47A1),
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : profile.isEmpty
              ? const Center(child: Text("Profile data not found"))
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
                        fullName.isNotEmpty
                            ? fullName
                            : profile['customer_name']?.toString() ?? "-",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        "LAN: ${profile['lan'] ?? '-'}",
                        style: const TextStyle(color: Colors.grey),
                      ),

                      const SizedBox(height: 30),

                      _infoTile(
                        "Mobile Number",
                        profile['mobile_number']?.toString() ?? "-",
                        Icons.phone,
                      ),

                      _infoTile(
                        "Email",
                        profile['email_id']?.toString() ?? "-",
                        Icons.email,
                      ),

                      _infoTile(
                        "Gender",
                        profile['gender']?.toString() ?? "-",
                        Icons.person_outline,
                      ),

                      _infoTile(
                        "Date of Birth",
                        profile['dob']?.toString().split('T').first ?? "-",
                        Icons.cake,
                      ),

                      _infoTile(
                        "Account Status",
                        profile['status']?.toString() ?? "Active",
                        Icons.check_circle,
                      ),
                    ],
                  ),
                ),
    );
  }

  // ================= INFO TILE =================
  Widget _infoTile(String label, String value, IconData icon) {
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
