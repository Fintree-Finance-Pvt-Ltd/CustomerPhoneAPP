import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


class ApiService {
  // ===============================
  // 🌐 BASE URL (from .env)
  // ===============================
  static final String baseUrl =
      dotenv.env['API_BASE_URL'] ?? 'https://customer-app.zypay.co.in/api';

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
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString("jwt");

  debugPrint("Dashboard API → JWT: $token");

  if (token == null || token.isEmpty) {
    throw Exception("JWT missing");
  }

  final res = await http.get(
    Uri.parse("$baseUrl/dashboard"),
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    },
  );

  debugPrint("Dashboard API → status: ${res.statusCode}");
  debugPrint("Dashboard API → body: ${res.body}");

  if (res.statusCode == 200) {
    return jsonDecode(res.body) as Map<String, dynamic>;
  } else {
    throw Exception("Dashboard failed: ${res.body}");
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


static Future<Map<String, String>> authHeaders() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString("jwt");

  return {
    "Authorization": "Bearer $token",
  };
}

static String documentViewUrl(String fileName) {
  return "$baseUrl/documents/view/$fileName";
}


// ===============================
// 🆘 SUPPORT MESSAGE (JWT BASED)
// ===============================
static Future<bool> sendSupportMessage(String message) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString("jwt");

  if (token == null) {
    throw Exception("JWT missing");
  }

  final response = await http.post(
    Uri.parse("$baseUrl/support/send"),
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    },
    body: jsonEncode({
      "message": message,
    }),
  );

  debugPrint("Support API status: ${response.statusCode}");
  debugPrint("Support API body: ${response.body}");

  if (response.statusCode == 200) {
    return true;
  } else {
    throw Exception("Support failed");
  }
}

 // ===============================
// 🔐 FORGOT PASSWORD (OTP FLOW)
// ===============================
static Future<Map<String, dynamic>> sendOtp(String pan) async {
  final res = await http.post(
    Uri.parse("$baseUrl/send-otp"),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({"pan": pan}),
  );

  if (res.statusCode == 200) {
    return jsonDecode(res.body);
  } else {
    throw Exception("Send OTP failed: ${res.body}");
  }
}

static Future<void> resetPassword({
  required String pan,
  required String otp,
  required String newPassword,
}) async {
  final res = await http.post(
    Uri.parse("$baseUrl/reset-password"),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "pan": pan,
      "otp": otp,
      "newPassword": newPassword,
    }),
  );

  if (res.statusCode != 200) {
    throw Exception("Reset password failed: ${res.body}");
  }
}


}
