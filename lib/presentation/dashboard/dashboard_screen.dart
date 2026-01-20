import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentation/auth/login_screen.dart';
import 'package:flutter_application_1/presentation/dashboard/documents_screen.dart';
import 'package:flutter_application_1/presentation/loan_details/loan_details_screen.dart';
import 'package:flutter_application_1/presentation/repayments/repayment_screen.dart';
import 'package:flutter_application_1/presentation/dashboard/support_screen.dart';

import '../../core/theme/app_colors.dart';
import '../../core/services/api_service.dart';



class DashboardScreen extends StatefulWidget {
  final int customerId;

  const DashboardScreen({
    super.key,
    required this.customerId,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}


class _DashboardScreenState extends State<DashboardScreen> {
  bool isLoading = true;

  // 🔹 DATA FROM loan_booking_zypay_customer
  Map<String, dynamic> loanData = {};

  @override
  void initState() {
    super.initState();
    loadDashboardData();
  }

  // ================= FETCH DASHBOARD DATA =================
Future<void> loadDashboardData() async {
  try {
    debugPrint("Dashboard → customerId: ${widget.customerId}");

    // ✅ USE customerId from login
    loanData = await ApiService.getLoanInfo(widget.customerId);

    if (loanData.isEmpty) {
      debugPrint("No loan found for customerId ${widget.customerId}");
    } else {
      debugPrint("Dashboard LAN fetched: ${loanData['lan']}");
    }
  } catch (e) {
    debugPrint("Dashboard API error: $e");
  }

  if (mounted) {
    setState(() => isLoading = false);
  }
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
      // ================= DRAWER =================
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration:
                  const BoxDecoration(color: AppColors.drawerHeader),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 34,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person,
                        size: 36, color: AppColors.primary),
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

            _drawerItem(context, Icons.home, "Home", () {
              Navigator.pop(context);
            }),

            _drawerItem(context, Icons.history, "Repayments", () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => Repayment(customerId: widget.customerId),
    ),
  );
}),


           _drawerItem(context, Icons.info, "Loan Details", () {
  Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => LoanDetailsScreen(
      customerId: widget.customerId,
    ),
  ),
);
}),


            _drawerItem(context, Icons.help, "Support", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SupportScreen()),
              );
            }),

            _drawerItem(context, Icons.edit_document, "Documents", () {
              Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => DocumentsScreen(
      customerId: widget.customerId,
    ),
  ),
);
            }),

            const Divider(),

            _drawerItem(context, Icons.logout, "Logout", () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            }),
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
              TextSpan(text: "Zy", style: TextStyle(color: Colors.green)),
              TextSpan(
                text: "Pay",
                style: TextStyle(color: Color(0xFF4D92CA)),
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
              'assets/images/Zypay_logo.png',
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

            const SizedBox(height: 20),
            _largeButton(context, "Pay Next EMI", Icons.payment),
            const SizedBox(height: 16),
            _largeButton(context, "Foreclose", Icons.mobile_off),
            const SizedBox(height: 16),
            _largeButton(
              context,
              "Call Support",
              Icons.phone_forwarded,
              color: AppColors.secondary,
            ),
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
