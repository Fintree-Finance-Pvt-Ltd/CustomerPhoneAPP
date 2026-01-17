import 'package:flutter/material.dart';
import 'presentation/auth/login_screen.dart';
import 'presentation/auth/otp_screen.dart';
import 'presentation/dashboard/dashboard_screen.dart';

void main() {
  runApp(const ZyPayApp());
}

class ZyPayApp extends StatelessWidget {
  const ZyPayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ZyPay Customer',
      theme: ThemeData(
        primaryColor: const Color(0xFF0D47A1),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF43A047)),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/otp': (context) => const OtpScreen(),
        '/dashboard': (context) => const DashboardScreen(),
      },
    );
  }
}