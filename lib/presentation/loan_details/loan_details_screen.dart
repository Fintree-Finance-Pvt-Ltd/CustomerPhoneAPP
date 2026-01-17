import 'package:flutter/material.dart';

class LoanDetailsScreen extends StatefulWidget {
  const LoanDetailsScreen({super.key});

  @override
  State<LoanDetailsScreen> createState() => _LoanDetailsScreenState();
}

class _LoanDetailsScreenState extends State<LoanDetailsScreen> {
  bool isLoading = true;
  
  // These variables will hold the API data
  Map<String, String> loanData = {};

  @override
  void initState() {
    super.initState();
    fetchLoanDetails(); // Hit the API when page opens
  }

  // --- DUMMY API HIT ---
  Future<void> fetchLoanDetails() async {
    setState(() => isLoading = true);

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // This is where your API data would come from
    loanData = {
  "name": "Vishal",
  "lanId": "ZY-998877",
  "phoneModel": "Samsung Galaxy M14",
  "totalLoan": "₹15,000",
  "emi": "₹2,500",
  "tenure": "6 Months", 
  "status": "Active"
};

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
              child: CircularProgressIndicator(color: Color(0xFF43A047)),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Icon(Icons.assignment_ind, size: 70, color: Color(0xFF43A047)),
                  const SizedBox(height: 10),
                  const Text(
                    "Verified Loan Details",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0D47A1)),
                  ),
                  const SizedBox(height: 20),

                  // FORM STRUCTURE
                  _buildFormField("Customer Name", loanData['name']!, Icons.person),
                  _buildFormField("LAN ID", loanData['lanId']!, Icons.fingerprint),
                  _buildFormField("Mobile Device", loanData['phoneModel']!, Icons.smartphone),
                  _buildFormField("Monthly EMI", loanData['emi']!, Icons.event_repeat),
                  _buildFormField("Total Duration", loanData['tenure']!, Icons.timelapse),

                  const SizedBox(height: 30),

                  // Help Box
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
                            style: TextStyle(fontSize: 13, color: Colors.blue),
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

  // --- FORM FIELD BUILDER ---
  Widget _buildFormField(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        initialValue: value,
        readOnly: true, // User can't change it
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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