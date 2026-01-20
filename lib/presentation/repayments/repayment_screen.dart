import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/services/api_service.dart';

class Repayment extends StatefulWidget {
  final int customerId;

  const Repayment({
    super.key,
    required this.customerId,
  });

  @override
  State<Repayment> createState() => _RepaymentState();
}

class _RepaymentState extends State<Repayment> {
  bool isLoading = true;
  List<Map<String, dynamic>> payments = [];

  @override
  void initState() {
    super.initState();
    loadRepayments();
  }

  Future<void> loadRepayments() async {
    try {
      // 1️⃣ Fetch loan info using customerId
      final loanInfo = await ApiService.getLoanInfo(widget.customerId);

      if (loanInfo.isEmpty || loanInfo['lan'] == null) {
        debugPrint("No loan found for customerId ${widget.customerId}");
        payments = [];
      } else {
        final String lan = loanInfo['lan'];

        debugPrint("CustomerId: ${widget.customerId}");
        debugPrint("LAN fetched: $lan");

        // 2️⃣ Fetch repayments using LAN
        payments = await ApiService.getRepaymentsByLan(lan);
      }
    } catch (e) {
      debugPrint("Repayment error: $e");
      payments = [];
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Repayments"),
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : payments.isEmpty
              ? const Center(child: Text("No repayment data found"))
              : ListView.builder(
                  padding: const EdgeInsets.all(15),
                  itemCount: payments.length,
                  itemBuilder: (context, index) {
                    final item = payments[index];

                    final bool isPaid =
                        item['status'].toString().toUpperCase() == "PAID";

                    final String dueDate =
                        item['due_date'].toString().split('T')[0];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          children: [
                            // 🔹 LEFT ICON
                            CircleAvatar(
                              radius: 22,
                              backgroundColor: isPaid
                                  ? Colors.green.shade100
                                  : Colors.orange.shade100,
                              child: Icon(
                                isPaid
                                    ? Icons.check_circle
                                    : Icons.schedule,
                                color: isPaid
                                    ? Colors.green
                                    : Colors.orange,
                              ),
                            ),

                            const SizedBox(width: 14),

                            // 🔹 EMI DETAILS
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "₹${item['emi']}",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Due Date: $dueDate",
                                    style: const TextStyle(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // 🔹 PAY BUTTON / STATUS
                            isPaid
                                ? Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Text(
                                      "Paid",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                                : ElevatedButton(
                                    onPressed: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            "Payment flow coming soon",
                                          ),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 18,
                                        vertical: 10,
                                      ),
                                    ),
                                    child: const Text(
                                      "Pay",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
