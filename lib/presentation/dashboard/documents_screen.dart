import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/services/api_service.dart';

class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({super.key});

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  bool isLoading = true;
  List<Map<String, dynamic>> documents = [];

  // 🔹 Public document base URL
  static const String baseUrl = "https://fintreelms.com/uploads/";

  // ✅ ALLOWED DOCUMENT TYPES
  static const Set<String> allowedDocs = {
    "DEALER_PHOTO_WITH_CUSTOMER",
    "CUSTOMER_PHOTO",
    "PAN",
    "CUSTOMER_PHONE_BOX_PIC",
    "OPEN_BOX_PIC",
    "INVOICE",
  };

  @override
  void initState() {
    super.initState();
    loadDocuments();
  }

  // ================= FETCH DOCUMENTS (JWT ONLY) =================
  Future<void> loadDocuments() async {
    try {
      debugPrint("Documents → loading via JWT");

      // ✅ SINGLE API HIT (JWT BASED)
      final allDocs = await ApiService.getDocuments();

      // ✅ FILTER REQUIRED DOCUMENTS ONLY
      documents = allDocs.where((doc) {
        final name = doc['doc_name']?.toString().toUpperCase() ?? "";
        return allowedDocs.contains(name);
      }).toList();
    } catch (e) {
      debugPrint("Documents error: $e");
      documents = [];
    }

    if (mounted) {
      setState(() => isLoading = false);
    }
  }

  // ================= OPEN DOCUMENT =================
  Future<void> openDocument(String fileName) async {
    if (fileName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid document file")),
      );
      return;
    }

    final Uri url = Uri.parse("$baseUrl$fileName");

    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Unable to open document")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Documents"),
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : documents.isEmpty
              ? const Center(child: Text("No required documents found"))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    final doc = documents[index];

                    final String docName =
                        doc['doc_name']?.toString() ?? "Document";
                    final String originalName =
                        doc['original_name']?.toString() ?? "";
                    final String fileName =
                        doc['file_name']?.toString() ?? "";

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: ListTile(
                        leading: const Icon(
                          Icons.description,
                          color: Colors.blue,
                          size: 32,
                        ),
                        title: Text(
                          docName.replaceAll("_", " "),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          originalName,
                          style: const TextStyle(fontSize: 12),
                        ),
                        trailing: ElevatedButton(
                          onPressed: fileName.isEmpty
                              ? null
                              : () => openDocument(fileName),
                          child: const Text("View"),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
