import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/services/api_service.dart';

class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({super.key});

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  bool isLoading = true;
  List<Map<String, String>> documents = [];

  @override
  void initState() {
    super.initState();
    fetchDocs();
  }

  Future<void> fetchDocs() async {
    setState(() => isLoading = true);
    documents = await ApiService.fetchDocuments();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Documents",),
        backgroundColor: const Color.fromARGB(255, 13, 161, 13),
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : documents.isEmpty
              ? const Center(child: Text("No documents found"))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    final doc = documents[index];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        title: Text(
                          doc["docName"] ?? "",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: ElevatedButton(
                          onPressed: () {
                            //  View document logic here
                            // Example: open PDF / show dialog / navigate
                          },


                           style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0D47A1),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        ),
                          child: const Text("View", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                               
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
