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
                      // ================= AVATAR =================
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

                      // ================= NAME =================
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

                      // ================= LAN =================
                      Text(
                        "LAN: ${profile['lan'] ?? '-'}",
                        style: const TextStyle(color: Colors.grey),
                      ),

                      const SizedBox(height: 30),

                      // ================= INFO TILES =================
                      _infoTileIfPresent(
                        "Mobile Number",
                        profile['mobile_number'],
                        Icons.phone,
                      ),

                      _infoTileIfPresent(
                        "Email",
                        profile['email_id'],
                        Icons.email,
                      ),

                      _infoTileIfPresent(
                        "Gender",
                        profile['gender'],
                        Icons.person_outline,
                      ),

                      _infoTileIfPresent(
                        "Date of Birth",
                        profile['dob']?.toString()
                                .split('T')
                                .first,
                        Icons.cake,
                      ),

                      _infoTileIfPresent(
                        "Account Status",
                        profile['status'],
                        Icons.check_circle,
                      ),
                    ],
                  ),
                ),
    );
  }

  // ================= CONDITIONAL INFO TILE =================
  Widget _infoTileIfPresent(
    String label,
    dynamic rawValue,
    IconData icon,
  ) {
    // ❌ hide if null
    if (rawValue == null) return const SizedBox.shrink();

    final value = rawValue.toString().trim();

    // ❌ hide if empty or "null"
    if (value.isEmpty || value.toLowerCase() == "null") {
      return const SizedBox.shrink();
    }

    // ✅ show tile
    return _infoTile(label, value, icon);
  }

  // ================= ACTUAL INFO TILE =================
  Widget _infoTile(
    String label,
    String value,
    IconData icon,
  ) {
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
