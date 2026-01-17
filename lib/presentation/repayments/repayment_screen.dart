import 'package:flutter/material.dart';

class Repayment extends StatelessWidget {
  const Repayment({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data for the worker to see
    final List<Map<String, dynamic>> payments = [
      {"date": "05 Jan 2026", "amount": "₹2,500", "status": "Paid", "isPaid": true},
      {"date": "05 Feb 2026", "amount": "₹2,500", "status": "Pending", "isPaid": false},
      {"date": "05 Mar 2026", "amount": "₹2,500", "status": "Pending", "isPaid": false},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Repayments"),
        backgroundColor: const Color(0xFF0D47A1),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(15),
        itemCount: payments.length,
        itemBuilder: (context, index) {
          final item = payments[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: ListTile(
              contentPadding: const EdgeInsets.all(15),
              leading: CircleAvatar(
                backgroundColor: item['isPaid'] ? Colors.green.shade100 : Colors.blue.shade100,
                child: Icon(
                  item['isPaid'] ? Icons.check_circle : Icons.schedule,
                  color: item['isPaid'] ? Colors.green : Colors.blue.shade800,
                ),
              ),
              title: Text(
                item['amount'],
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              subtitle: Text("Date: ${item['date']}"),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: item['isPaid'] ? Colors.green : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  item['isPaid'] ? "Paid" : "Due",
                  style: TextStyle(
                    color: item['isPaid'] ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}