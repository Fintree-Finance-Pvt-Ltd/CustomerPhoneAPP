import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/services/api_service.dart';

class DocumentsScreen extends StatefulWidget {
  final int customerId;

  const DocumentsScreen({
    super.key,
    required this.customerId,
  });

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  bool isLoading = true;
  List<Map<String, dynamic>> documents = [];

  static const String baseUrl = "https://fintreelms.com/uploads/";

  @override
  void initState() {
    super.initState();
    loadDocuments();
  }

  // ---------------- FETCH DOCUMENTS ----------------
  Future<void> loadDocuments() async {
    try {
      debugPrint("Documents → customerId: ${widget.customerId}");

      // 1️⃣ Fetch loan info using customerId
      final loanInfo = await ApiService.getLoanInfo(widget.customerId);

      if (loanInfo.isEmpty || loanInfo['lan'] == null) {
        debugPrint("No loan found for customerId ${widget.customerId}");
        documents = [];
      } else {
        final String lan = loanInfo['lan'];

        debugPrint("LAN verified for documents: $lan");

        // 2️⃣ Fetch documents using LAN
        documents = await ApiService.getDocumentsByLan(lan);
      }
    } catch (e) {
      debugPrint("Documents error: $e");
      documents = [];
    }

    if (mounted) {
      setState(() => isLoading = false);
    }
  }

  // ---------------- OPEN / DOWNLOAD DOCUMENT ----------------
  Future<void> openDocument(String fileName) async {
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
              ? const Center(child: Text("No documents found"))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    final doc = documents[index];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: ListTile(
                        leading: const Icon(
                          Icons.picture_as_pdf,
                          color: Colors.red,
                          size: 32,
                        ),
                        title: Text(
                          doc['doc_name'] ?? "Document",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          doc['original_name'] ?? "",
                          style: const TextStyle(fontSize: 12),
                        ),
                        trailing: ElevatedButton(
                          onPressed: () {
                            final fileName = doc['file_name'];
                            openDocument(fileName);
                          },
                          child: const Text("View"),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
