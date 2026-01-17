

import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentation/auth/login_screen.dart';
import 'package:flutter_application_1/presentation/dashboard/documents_screen.dart';
import 'package:flutter_application_1/presentation/loan_details/loan_details_screen.dart';
import 'package:flutter_application_1/presentation/repayments/repayment_screen.dart';
import 'package:flutter_application_1/presentation/dashboard/support_screen.dart';
import '../profile/user_profile_screen.dart';


class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
 // Mock customer data
    final customer = {
      "name": "Zypay Customer Name",
      "phone": "+91 98765 43210",
      "customerId": "CUST-2024-1234",
      "email": "rajesh.kumar@example.com",
      "address": "123, MG Road, Mumbai, Maharashtra",
    };

    // Mock loan data
    final loans = [
      {
        "lan": "FTL000125",
        "deviceName": "Samsung Galaxy M14",

        
        "nextEmiDate": "05 Jan 2026",
        "emiAmount": 1200,
        "overdueAmount": 0,
        "principalAmount": 40000,
        "totalAmount": 55000,
        "paidAmount": 20800,
        "tenure": 12,
        "interestRate": 10.5,
      },
      {
        "lan": "FTL000456",
         "deviceName": "Samsung Galaxy S24",
        "nextEmiDate": "01 Jan 2026",
        "emiAmount": 3800,
        "overdueAmount": 760,
        "principalAmount": 40000,
        "totalAmount": 44000,
        "paidAmount": 15200,
        "tenure": 12,
        "interestRate": 10.0,
      },
      
    ];
final Map<String, dynamic> nextLoan = loans.first;

final int emiAmount = nextLoan["emiAmount"] as int;
final int overdueAmount = nextLoan["overdueAmount"] as int;
final int dueAmount = emiAmount + overdueAmount;
final String dueDate = nextLoan["nextEmiDate"] as String;
final String lan = nextLoan["lan"] as String;


    return Scaffold(
      // --- THE SIDEBAR (DRAWER) ---
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Color(0xFF0D47A1)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserProfileScreen(
          customerData: customer, // correct variable
        ),
      ),
    );
  },
  child: Column(
    children: [
  const CircleAvatar(
    backgroundColor: Colors.white,
    radius: 30,
    child: Icon(
      Icons.person,
      size: 40,
      color: Color(0xFF0D47A1),
    ),
  ),

  const SizedBox(height: 10),

  const Text(
    "ZyPay Customer",
    style: TextStyle(
      color: Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
  ),

  //  DYNAMIC LAN
  Text(
    "LAN: $lan",
    style: TextStyle(
      color: Colors.white.withOpacity(0.8),
    ),
  ),
],

  ),
)


                ],
              ),
            ),
            _buildDrawerItem(Icons.home, "Home ", () => Navigator.pop(context)),
        // Inside the Drawer list in dashboard_screen.dart
_buildDrawerItem(Icons.history, "Repayments", () {
  Navigator.push(context, MaterialPageRoute(builder: (context) => const Repayment()));
}),
_buildDrawerItem(Icons.info, "Loan Details ", () {
  Navigator.push(context, MaterialPageRoute(builder: (context) => const LoanDetailsScreen()));


}),
            _buildDrawerItem(Icons.help, "Support ", () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const SupportScreen()));
            }),

_buildDrawerItem(Icons.edit_document,"Document",() { Navigator.push(context,
      MaterialPageRoute(
        builder: (context) => const DocumentsScreen(),
      ),
    );
  },
),



            const Divider(),
           _buildDrawerItem(Icons.logout, "Logout", () {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (_) => const LoginScreen()),
    (route) => false,
  );
}),

          ],
        ),
      ),
      
      appBar: AppBar(
        title: const Text("ZyPay", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF0D47A1),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Company Logo on Dashboard
            const Center(
              child: Column(
                children: [
                  Icon(Icons.account_balance_wallet, size: 50, color: Color(0xFF43A047)),
                  Text("ZyPay Finance", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF0D47A1))),
                ],
              ),
            ),
            const SizedBox(height: 25),

            // LARGE BALANCE CARD (Easy to read for everyone)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF43A047), width: 2),
              ),
              child: Column(
                children: [
                  // LARGE BALANCE CARD (Easy to read for everyone)
Container(

  child: Column(
    children: [
      const Text(
        "Due Amount",
        style: TextStyle(fontSize: 16, color: Colors.black87),
      ),

      const SizedBox(height: 5),

      //  DYNAMIC AMOUNT
      Text(
        "₹$dueAmount",
        style: const TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1B5E20),
        ),
      ),

      const SizedBox(height: 8),

      //  LAN
      Text(
        "LAN: $lan",
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),

      const SizedBox(height: 10),

      //  DYNAMIC DATE
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: overdueAmount > 0
              ? Colors.red.shade100
              : Colors.orange.shade100,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          "Due Date: $dueDate",
          style: TextStyle(
            color: overdueAmount > 0 ? Colors.red : Colors.orange,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ],
  ),
),

                ],
              ),
            ),
            
            const SizedBox(height: 25),
            
            // SIMPLE LARGE BUTTONS
            _buildLargeMenuButton(context, "Pay Next EMI", Icons.payment, Colors.blue.shade800),
             const SizedBox(height: 15),
            _buildLargeMenuButton(context, "ForClouse", Icons.mobile_off, Colors.blue.shade800),
            const SizedBox(height: 15),
            _buildLargeMenuButton(context, "Call Support", Icons.phone_forwarded, Colors.green.shade700),
                    
        
          ],
        ),
      ),
    );
  }

  // Large Button Helper
  Widget _buildLargeMenuButton(BuildContext context, String title, IconData icon, Color color) {
    return SizedBox(
      width: double.infinity,
      height: 100,
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: Icon(icon, size: 35, color: Colors.white),
        label: Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
      ),
    );
  }

  // Sidebar Item Helper
  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF0D47A1)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      onTap: onTap,
    );
  }
}