import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'presentation/auth/login_screen.dart';
import 'presentation/auth/otp_screen.dart';

void main() {
  runApp(const ZyPayApp());
}

class ZyPayApp extends StatelessWidget {
  const ZyPayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,

      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/otp': (context) => const OtpScreen(),
        // 🚫 NO dashboard route here
      },
    );
  }
}
