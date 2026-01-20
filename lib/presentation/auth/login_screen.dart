import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}




class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController idController = TextEditingController();
  final FocusNode idFocus = FocusNode();

  bool isLoading = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation =
        Tween<double>(begin: 0, end: 1).animate(_animationController);

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    idController.dispose();
    idFocus.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> handleLogin() async {
    if (isLoading) return;

    final input = idController.text.trim();

    if (input.isEmpty || input.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Enter valid Mobile or Customer ID"),
        ),
      );
      return;
    }

    setState(() => isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;

    setState(() => isLoading = false);
    Navigator.pushReplacementNamed(context, '/otp');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      drawer: null,
      drawerEnableOpenDragGesture: false,
      resizeToAvoidBottomInset: true,

      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          width: double.infinity,
          height: double.infinity,

          // 🔵 THEME GRADIENT
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.secondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),

          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      children: [
                        // 🔵 LOGO
                       
                          


Container(
  height: 180,
  width: 180,
  decoration: BoxDecoration(
    shape: BoxShape.circle,
    color: Colors.white,
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.15),
        blurRadius: 20,
        offset: const Offset(0, 10),
      ),
    ],
  ),
  child: ClipOval(
    child: Image.asset(
      'assets/images/Zypay_background.jpeg',
      fit: BoxFit.cover,
    ),
  ),
),

const SizedBox(height: 24),













                        

                        Text(
                          "Enter details to access your loan account",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),

                        const SizedBox(height: 48),

                        //  LOGIN CARD
                        Container(
                          constraints: BoxConstraints(
                            maxWidth: size.width > 600 ? 420 : double.infinity,
                          ),
                          padding: const EdgeInsets.all(28),
                          decoration: BoxDecoration(
                            color: AppColors.cardBg,
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.12),
                                blurRadius: 30,
                                offset: const Offset(0, 15),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Mobile / Customer ID",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),

                              const SizedBox(height: 12),

                              TextField(
  controller: idController,
  focusNode: idFocus,
  autofocus: true, // Automatically requests keyboard on load
  keyboardType: TextInputType.number, // Better for emulators and mobile users
  inputFormatters: [
    LengthLimitingTextInputFormatter(10),
    FilteringTextInputFormatter.digitsOnly, // Specific to numbers if it's a mobile ID
  ],
  decoration: InputDecoration(
    counterText: "", // Hides the 0/10 counter
    hintText: "10-digit Mobile or ID",
    prefixIcon: const Icon(
      Icons.person_pin_rounded,
      color: AppColors.primary,
    ),
                                  filled: true,
                                  fillColor:
                                      AppColors.scaffoldBg.withOpacity(0.8),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: const BorderSide(
                                      color: AppColors.primary,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 32),

                              SizedBox(
                                width: double.infinity,
                                height: 56,
                                child: ElevatedButton(
                                  onPressed: handleLogin,
                                  child: isLoading
                                      ? const CircularProgressIndicator(
                                          color: Colors.white,
                                        )
                                      : const Text(
                                          "SECURE LOGIN",
                                          
                                    
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),

                        const Text(
                          " SSL Encrypted • Secure Session",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
