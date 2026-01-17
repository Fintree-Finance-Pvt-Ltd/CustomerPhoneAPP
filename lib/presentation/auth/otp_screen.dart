import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_application_1/presentation/dashboard/dashboard_screen.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  bool isLoading = false;
  int _counter = 30;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_counter > 0) {
        setState(() => _counter--);
      } else {
        _timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void verifyOtp() async {
    setState(() => isLoading = true);

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const DashboardScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  Prevent drawer completely
      drawer: null,
      drawerEnableOpenDragGesture: false,

      //  Allow resizing when keyboard opens
      resizeToAvoidBottomInset: true,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),

      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            //  THIS FIXES OVERFLOW
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 20),

                const Icon(
                  Icons.mark_email_read_outlined,
                  size: 80,
                  color: Color(0xFF43A047),
                ),

                const SizedBox(height: 24),

                const Text(
                  "Verification Code",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0D47A1),
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  "We have sent a 4-digit code to your registered mobile number",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color.fromARGB(255, 91, 89, 89)),
                ),

                const SizedBox(height: 40),

                // OTP boxes
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(4, (index) => _otpTextField(index == 0)),
                ),

                const SizedBox(height: 40),

                isLoading
                    ? const CircularProgressIndicator(
                        color: Color(0xFF43A047),
                      )
                    : SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: verifyOtp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0D47A1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: const Text(
                            "VERIFY & PROCEED",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                const SizedBox(height: 20),

                TextButton(
                  onPressed: _counter == 0
                      ? () {
                          setState(() => _counter = 30);
                          _startTimer();
                        }
                      : null,
                  child: Text(
                    _counter > 0
                        ? "Resend code in ${_counter}s"
                        : "Resend Code",
                    style: TextStyle(
                      color: _counter > 0
                          ? Colors.grey
                          : const Color(0xFF43A047),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _otpTextField(bool first) {
    return SizedBox(
      height: 68,
      width: 64,
      child: TextField(
        autofocus: first,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }
        },
        decoration: InputDecoration(
          counterText: "",
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black12),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                const BorderSide(color: Color(0xFF43A047), width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
