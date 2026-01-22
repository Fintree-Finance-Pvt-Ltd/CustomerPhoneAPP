import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/services/api_service.dart';



class LoanDetailsScreen extends StatefulWidget {
  const LoanDetailsScreen({super.key});

  @override
  State<LoanDetailsScreen> createState() => _LoanDetailsScreenState();
}

class _LoanDetailsScreenState extends State<LoanDetailsScreen> {
  bool isLoading = true;

  // 🔹 DATA FROM BACKEND (JWT BASED)
  Map<String, dynamic> loanData = {};

  @override
  void initState() {
    super.initState();
    fetchLoanDetails();
  }

  // ================= FETCH LOAN DETAILS (JWT ONLY) =================
  Future<void> fetchLoanDetails() async {
    try {
      debugPrint("LoanDetails → loading via JWT");

      // ✅ SINGLE JWT-BASED API
      loanData = await ApiService.getLoanDetails();
    } catch (e) {
      debugPrint("LoanDetails API error: $e");
      loanData = {};
    }

    if (mounted) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Loan Info"),
        backgroundColor: const Color(0xFF0D47A1),
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF43A047),
              ),
            )
          : loanData.isEmpty
              ? const Center(child: Text("No loan data found"))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.assignment_ind,
                        size: 70,
                        color: Color(0xFF43A047),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Verified Loan Details",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0D47A1),
                        ),
                      ),
                      const SizedBox(height: 20),

                      _buildFormField(
                        "Customer Name",
                        loanData['customer_name']?.toString() ?? "-",
                        Icons.person,
                      ),

                      _buildFormField(
                        "LAN ID",
                        loanData['lan']?.toString() ?? "-",
                        Icons.fingerprint,
                      ),

                      _buildFormField(
                        "Mobile Number",
                        loanData['mobile_number']?.toString() ?? "-",
                        Icons.phone_android,
                      ),

                      _buildFormField(
                        "Monthly EMI",
                        "₹${double.tryParse(
                          loanData['emi_amount']?.toString() ?? '0',
                        )?.toStringAsFixed(0)}",
                        Icons.event_repeat,
                      ),

                      _buildFormField(
                        "Total Duration (Months)",
                        loanData['loan_tenure'] != null
                            ? loanData['loan_tenure']
                                .toString()
                                .split('.')
                                .first
                            : "-",
                        Icons.timelapse,
                      ),

                      const SizedBox(height: 30),

                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.blue.shade200),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.info, color: Colors.blue),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                "In case of any issue, call ZyPay help center.",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  // ================= FORM FIELD BUILDER =================
  Widget _buildFormField(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        initialValue: value,
        readOnly: true,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Color(0xFF0D47A1)),
          prefixIcon: Icon(icon, color: const Color(0xFF43A047)),
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
        ),
      ),
    );
  }
}
