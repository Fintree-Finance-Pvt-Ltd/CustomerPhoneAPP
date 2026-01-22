import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
 
import 'core/theme/app_theme.dart';
import 'presentation/auth/login_screen.dart';
 
Future<void> main() async {
  // ✅ Required for async before runApp
  WidgetsFlutterBinding.ensureInitialized();
 
  // ✅ Load environment variables
  await dotenv.load(fileName: ".env");
 
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
      },
    );
  }
}