import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // 🔹 Backend base URL
  static const String baseUrl = "http://localhost:5000/api";

  // ===============================
  // LOGIN
  // ===============================
  static Future<Map<String, dynamic>> login(String email) async {
    final response = await http.post(
      Uri.parse("$baseUrl/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Login failed");
    }
  }

  // ===============================
  // PROFILE
  // ===============================
  static Future<Map<String, dynamic>> getProfile(int id) async {
    final response =
        await http.get(Uri.parse("$baseUrl/profile/$id"));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Profile load failed");
    }
  }

  // ===============================
  // LOAN (BASIC)
  // ===============================
  static Future<Map<String, dynamic>> getLoan(int customerId) async {
    final response =
        await http.get(Uri.parse("$baseUrl/loan/$customerId"));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Loan load failed");
    }
  }

  // ===============================
  // LOAN META
  // ===============================
  static Future<Map<String, dynamic>> getLoanMeta(int customerId) async {
    final response =
        await http.get(Uri.parse("$baseUrl/loan-meta/$customerId"));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Loan meta load failed");
    }
  }

  // GET LOAN INFO (SINGLE TABLE)
  // ===============================
  static Future<Map<String, dynamic>> getLoanInfo(int customerId) async {
    final res =
        await http.get(Uri.parse("$baseUrl/loan-info/$customerId"));

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      throw Exception("Loan info load failed");
    }
  }
// ===============================
// GET REPAYMENTS BY LAN
// ===============================
static Future<List<Map<String, dynamic>>> getRepaymentsByLan(
    String lan) async {
  final res =
      await http.get(Uri.parse("$baseUrl/repayments/$lan"));

  if (res.statusCode == 200) {
    final List data = jsonDecode(res.body);
    return data.cast<Map<String, dynamic>>();
  } else {
    throw Exception("Failed to load repayments");
  }
}

// ===============================
// GET DOCUMENTS BY LAN
// ===============================
static Future<List<Map<String, dynamic>>> getDocumentsByLan(
    String lan) async {
  final res =
      await http.get(Uri.parse("$baseUrl/documents/$lan"));

  if (res.statusCode == 200) {
    final List data = jsonDecode(res.body);
    return data.cast<Map<String, dynamic>>();
  } else {
    throw Exception("Failed to load documents");
  }
}

}
