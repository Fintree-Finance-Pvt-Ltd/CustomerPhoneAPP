import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  // ===============================
  // 🌐 BASE URL (from .env)
  // ===============================
  static final String baseUrl =
      dotenv.env['API_BASE_URL'] ?? 'http://localhost:5000/api';

  static final String jwtKey =
      dotenv.env['JWT_STORAGE_KEY'] ?? 'jwt';

  // ===============================
  // 🔐 GET JWT TOKEN
  // ===============================
  static Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(jwtKey);

    if (token == null || token.isEmpty) {
      throw Exception("JWT token missing");
    }
    return token;
  }

  // ===============================
  // 🔑 COMMON AUTH HEADERS
  // ===============================
  static Future<Map<String, String>> _authHeaders() async {
    final token = await _getToken();
    return {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };
  }

  // ===============================
  // 🔓 LOGIN (PAN + PASSWORD → JWT)
  // ===============================
  static Future<Map<String, dynamic>> login(
    String panNumber,
    String password,
  ) async {
    final res = await http.post(
      Uri.parse("$baseUrl/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "panNumber": panNumber,
        "password": password,
      }),
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      throw Exception("Login failed: ${res.body}");
    }
  }

  // ===============================
  // 🏠 DASHBOARD SUMMARY (JWT BASED)
  // ===============================
  static Future<Map<String, dynamic>> getDashboardSummary() async {
    final res = await http.get(
      Uri.parse("$baseUrl/dashboard"),
      headers: await _authHeaders(),
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      throw Exception("Dashboard load failed");
    }
  }

  // ===============================
  // 👤 USER PROFILE (JWT BASED)
  // ===============================
  static Future<Map<String, dynamic>> getProfile() async {
    final res = await http.get(
      Uri.parse("$baseUrl/profile"),
      headers: await _authHeaders(),
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      throw Exception("Profile load failed");
    }
  }

  // ===============================
  // 💳 REPAYMENTS (JWT BASED)
  // ===============================
  static Future<List<Map<String, dynamic>>> getRepayments() async {
    final res = await http.get(
      Uri.parse("$baseUrl/repayments"),
      headers: await _authHeaders(),
    );

    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception("Repayments load failed");
    }
  }

  // ===============================
  // 📁 DOCUMENTS (JWT BASED)
  // ===============================
  static Future<List<Map<String, dynamic>>> getDocuments() async {
    final res = await http.get(
      Uri.parse("$baseUrl/documents"),
      headers: await _authHeaders(),
    );

    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception("Documents load failed");
    }
  }

  // ===============================
  // 🚪 LOGOUT
  // ===============================
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(jwtKey);
  }

  // ===============================
// 📄 LOAN DETAILS (JWT BASED)
// ===============================
static Future<Map<String, dynamic>> getLoanDetails() async {
  final token = await _getToken();

  final res = await http.get(
    Uri.parse("$baseUrl/loan-details"),
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    },
  );

  if (res.statusCode == 200) {
    return jsonDecode(res.body);
  } else {
    throw Exception("Loan details load failed");
  }
}

}
