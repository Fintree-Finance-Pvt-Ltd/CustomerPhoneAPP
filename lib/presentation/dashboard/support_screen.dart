import 'package:flutter/material.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final TextEditingController _messageController = TextEditingController();
  bool isSending = false;

  void _sendMessage() async {
    if (_messageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a message")),
      );
      return;
    }

    setState(() => isSending = true);
    
    // Simulate sending to ZyPay Support
    await Future.delayed(const Duration(seconds: 2));
    
    if (mounted) {
      setState(() => isSending = false);
      _messageController.clear();
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Message Sent!"),
          content: const Text("ZyPay team will contact you soon.\n(ZyPay "),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Help & Support"),
        backgroundColor: const Color(0xFF0D47A1),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Support Image/Icon
            const Center(
              child: Icon(Icons.support_agent_rounded, size: 80, color: Color(0xFF43A047)),
            ),
            const SizedBox(height: 20),
            const Text(
              "How can we help you?",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF0D47A1)),
            ),
            const Text("for your help"),
            const SizedBox(height: 30),

            // Message Input Area
            const Text("Write your message here:", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextField(
              controller: _messageController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: "Type your problem...",
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: Color(0xFF0D47A1)),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: isSending ? null : _sendMessage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D47A1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: isSending 
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("SEND MESSAGE ", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),

            const SizedBox(height: 40),
            const Divider(),
            const SizedBox(height: 20),

            // Quick Contact Section
            const Text("Quick Contact ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            
            _buildContactTile(
              icon: Icons.call, 
              title: "Call Us ", 
              subtitle: "1800-XXX-XXXX", 
              color: Colors.blue.shade700
            ),
            const SizedBox(height: 10),
            _buildContactTile(
              icon: Icons.chat, 
              title: "WhatsApp", 
              subtitle: "Click to chat with us", 
              color: Colors.green.shade700
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactTile({required IconData icon, required String title, required String subtitle, required Color color}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 5)],
      ),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: color, child: Icon(icon, color: Colors.white)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        onTap: () {
          // You would use url_launcher package here to actually call or open WhatsApp
        },
      ),
    );
  }
}