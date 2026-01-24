import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_colors.dart';
import '../../core/services/api_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController panController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  bool otpSent = false;
  bool isLoading = false;

  @override
  void dispose() {
    panController.dispose();
    otpController.dispose();
    newPasswordController.dispose();
    super.dispose();
  }

  // ================= SEND OTP =================
  Future<void> sendOtp() async {
    final pan = panController.text.trim().toUpperCase();

    if (pan.length != 10) {
      _showSnack("Enter valid PAN number");
      return;
    }

    setState(() => isLoading = true);

    try {
      final data = await ApiService.sendOtp(pan);

      // 🔥 DEV MODE: PRINT OTP IN CONSOLE
      debugPrint("🔥 DEV OTP: ${data['otp']}");

      setState(() => otpSent = true);
      _showSnack("OTP generated (check console)");
    } catch (e) {
      debugPrint("Send OTP Error: $e");
      _showSnack("Failed to send OTP");
    } finally {
      setState(() => isLoading = false);
    }
  }

  // ================= RESET PASSWORD =================
  Future<void> resetPassword() async {
    if (otpController.text.trim().length != 6) {
      _showSnack("Enter valid OTP");
      return;
    }

    if (newPasswordController.text.trim().length < 6) {
      _showSnack("Password must be at least 6 characters");
      return;
    }

    setState(() => isLoading = true);

    try {
      await ApiService.resetPassword(
        pan: panController.text.trim().toUpperCase(),
        otp: otpController.text.trim(),
        newPassword: newPasswordController.text.trim(),
      );

      _showSnack("Password reset successful");
      Navigator.pop(context);
    } catch (e) {
      debugPrint("Reset Password Error: $e");
      _showSnack("Reset failed");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        title: const Text("Forgot Password"),
        foregroundColor: Colors.white,
        backgroundColor: AppColors.primary,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 30),

              /// 🔐 ICON
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withOpacity(0.1),
                ),
                child: const Icon(
                  Icons.lock_reset,
                  size: 50,
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                "Reset your password",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                "Enter your PAN to receive OTP",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600),
              ),

              const SizedBox(height: 36),

              /// PAN FIELD
              TextField(
                controller: panController,
                maxLength: 10,
                textCapitalization: TextCapitalization.characters,
                inputFormatters: [
                  UpperCaseTextFormatter(),
                  FilteringTextInputFormatter.allow(
                    RegExp('[a-zA-Z0-9]'),
                  ),
                ],
                decoration: _inputDecoration(
                  "ABCDE1234F",
                  Icons.badge,
                ),
              ),

              const SizedBox(height: 20),

              if (otpSent) ...[
                /// OTP FIELD
                TextField(
                  controller: otpController,
                  maxLength: 6,
                  keyboardType: TextInputType.number,
                  decoration: _inputDecoration(
                    "Enter OTP",
                    Icons.sms,
                  ),
                ),

                const SizedBox(height: 20),

                /// NEW PASSWORD FIELD
                TextField(
                  controller: newPasswordController,
                  obscureText: true,
                  decoration: _inputDecoration(
                    "New Password",
                    Icons.lock,
                  ),
                ),
              ],

              const SizedBox(height: 36),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : otpSent
                          ? resetPassword
                          : sendOtp,
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(otpSent ? "RESET PASSWORD" : "SEND OTP"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      counterText: "",
      hintText: hint,
      prefixIcon: Icon(icon, color: AppColors.primary),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
    );
  }
}

/// ================= UPPERCASE FORMATTER =================
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
