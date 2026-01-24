import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentation/auth/login_screen.dart';
import 'package:flutter_application_1/presentation/dashboard/documents_screen.dart';
import 'package:flutter_application_1/presentation/loan_details/loan_details_screen.dart';
import 'package:flutter_application_1/presentation/repayments/repayment_screen.dart';
import 'package:flutter_application_1/presentation/dashboard/support_screen.dart';
import 'package:flutter_application_1/presentation/profile/user_profile_screen.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../core/theme/app_colors.dart';
import '../../core/services/api_service.dart';



class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}



class _DashboardScreenState extends State<DashboardScreen> {
  bool isLoading = true;

  String appVersion = ""; //  ADD THIS

  Map<String, dynamic> loanData = {};

@override
void initState() {
  super.initState();
  loadDashboardData();
  loadAppVersion(); 
}
Future<void> loadAppVersion() async {
  final info = await PackageInfo.fromPlatform();
  if (mounted) {
    setState(() {
      appVersion = "v${info.version}.${info.buildNumber}";
    });
  }
}


 
// ================= FETCH DASHBOARD DATA =================
Future<void> loadDashboardData() async {
  debugPrint("========== DASHBOARD LOAD START ==========");

  try {
    final data = await ApiService.getDashboardSummary();

    debugPrint("Dashboard API data: $data");

    if (!mounted) return;

    setState(() {
      loanData = data;
      isLoading = false;
    });
  } catch (e) {
    debugPrint("Dashboard error: $e");

    if (!mounted) return;

    setState(() => isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Failed to load dashboard"),
        backgroundColor: Colors.red,
      ),
    );
  }

  debugPrint("========== DASHBOARD LOAD END ==========");
}


  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // ================= SAFE VALUES =================
    final String customerName =
        loanData['customer_name'] ?? "ZyPay Customer";
    final String lan = loanData['lan'] ?? "-";
    final double emiAmount =
    double.tryParse(loanData['emi_amount'].toString()) ?? 0.0;

    final String tenure =
        loanData['loan_tenure']?.toString() ?? "-";
    final String status = loanData['status'] ?? "-";

    return Scaffold(
     drawer: Drawer(
  child: ListView(
    padding: EdgeInsets.zero,
    children: [
      // ================= HEADER =================
      DrawerHeader(
        decoration: const BoxDecoration(
          color: AppColors.drawerHeader,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 34,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person,
                size: 36,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              customerName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "LAN: $lan",
              style: TextStyle(
                color: Colors.white.withOpacity(0.85),
              ),
            ),
          ],
        ),
      ),

      // ================= HOME =================
      _drawerItem(context, Icons.home, "Home", () {
        Navigator.pop(context);
      }),

      // ================= MY PROFILE =================
      _drawerItem(context, Icons.person, "My Profile", () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const UserProfileScreen(),
          ),
        );
      }),

      // ================= REPAYMENTS =================
      _drawerItem(context, Icons.history, "Repayments", () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const Repayment(),
          ),
        );
      }),

      // ================= LOAN DETAILS =================
      _drawerItem(context, Icons.info, "Loan Details", () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const LoanDetailsScreen(),
          ),
        );
      }),

      // ================= DOCUMENTS =================
      _drawerItem(context, Icons.edit_document, "Documents", () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const DocumentsScreen(),
          ),
        );
      }),

      // ================= SUPPORT =================
      _drawerItem(context, Icons.help, "Support", () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const SupportScreen(),
          ),
        );
      }),

      const Divider(),

      // ================= LOGOUT =================
      _drawerItem(context, Icons.logout, "Logout", () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => const LoginScreen(),
          ),
          (route) => false,
        );
      }),

      // ================= APP VERSION =================
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Center(
          child: Text(
            appVersion.isEmpty ? "" : "FinTree App $appVersion",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    ],
  ),
),


      // ================= APP BAR =================
      appBar: AppBar(
        centerTitle: true,
        title: RichText(
          text: const TextSpan(
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            children: [
              TextSpan(text: "Fin", style: TextStyle(color: Color.fromARGB(255, 76, 119, 175))),
              TextSpan(
                text: "Tree",
                style: TextStyle(color: Color.fromARGB(255, 77, 202, 104)),
              ),
            ],
          ),
        ),
      ),

      // ================= BODY =================
      body: SingleChildScrollView(
        
        padding: const EdgeInsets.all(20),
        child: Column(
          
          children: [
            Image.asset(
              'assets/images/fintree_img.png',
              height: 140,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const Text(
                        "Monthly EMI",
                        style: TextStyle(
                            fontSize: 15,
                            color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "₹$emiAmount",
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: AppColors.success,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "LAN: $lan",
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "Tenure: $tenure | Status: $status",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.warning,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // const SizedBox(height: 20),
            // _largeButton(context, "Pay Next EMI", Icons.payment),
            // const SizedBox(height: 16),
            // _largeButton(context, "Foreclose", Icons.mobile_off),
            // const SizedBox(height: 16),
            // _largeButton(
            //   context,
            //   "Call Support",
            //   Icons.phone_forwarded,
            //   color: AppColors.secondary,
            // ),
          ],
        ),
      ),
    );
  }

  // ================= HELPERS =================

  Widget _largeButton(BuildContext context, String title, IconData icon,
      {Color? color}) {
    return SizedBox(
      width: double.infinity,
      height: 65,
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: Icon(icon, size: 28, color: Colors.white),
        label: Text(
          title,
          style:
              const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? AppColors.primary,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
      ),
    );
  }

  Widget _drawerItem(
      BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title:
          Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      onTap: onTap,
    );
  }
}
