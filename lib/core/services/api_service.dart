class ApiService {
  // 🔹 Dummy document API
  static Future<List<Map<String, String>>> fetchDocuments() async {
    await Future.delayed(const Duration(seconds: 2)); // simulate API delay

    return [
      {
        "docName": "Aadhaar Card",
        "docNumber": "XXXX-XXXX-1234",
        "status": "Verified",
        "uploadedOn": "12 Jan 2025",
      },
      {
        "docName": "PAN Card",
        "docNumber": "ABCDE1234F",
        "status": "Verified",
        "uploadedOn": "12 Jan 2025",
      },
      {
        "docName": "Bank Statement",
        "docNumber": "Last 6 Months",
        "status": "Pending",
        "uploadedOn": "13 Jan 2025",
      },
    ];
  }
}
