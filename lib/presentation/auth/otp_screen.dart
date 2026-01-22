// import 'package:flutter/material.dart';
// import 'dart:async';
// import 'package:flutter_application_1/presentation/dashboard/dashboard_screen.dart';
// import '../../core/theme/app_colors.dart';

// class OtpScreen extends StatefulWidget {
//   const OtpScreen({super.key});

//   @override
//   State<OtpScreen> createState() => _OtpScreenState();
// }



// class _OtpScreenState extends State<OtpScreen> {
//   bool isLoading = false;
//   int _counter = 30;
//   late Timer _timer;

//   @override
//   void initState() {
//     super.initState();
//     _startTimer();
//   }

//   void _startTimer() {
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (_counter > 0) {
//         setState(() => _counter--);
//       } else {
//         timer.cancel();
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _timer.cancel();
//     super.dispose();
//   }

//   void verifyOtp() async {
//   setState(() => isLoading = true);

//   await Future.delayed(const Duration(seconds: 2));
//   if (!mounted) return;

//   Navigator.pushAndRemoveUntil(
//     context,
//     MaterialPageRoute(
//       builder: (_) => DashboardScreen(customerId: 1),
//     ),
//     (route) => false,
//   );
// }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // Prevent drawer
//       drawer: null,
//       drawerEnableOpenDragGesture: false,
//       resizeToAvoidBottomInset: true,

//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         automaticallyImplyLeading: false,
//       ),

//       body: SafeArea(
//         child: GestureDetector(
//           onTap: () => FocusScope.of(context).unfocus(),
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const SizedBox(height: 20),

//                 //  ICON
//                 const Icon(
//                   Icons.mark_email_read_outlined,
//                   size: 80,
//                   color: AppColors.secondary,
//                 ),

//                 const SizedBox(height: 24),

//                 //  TITLE
//                 const Text(
//                   "Verification Code",
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     color: AppColors.primary,
//                   ),
//                 ),

//                 const SizedBox(height: 10),

//                 //  SUBTITLE
//                 const Text(
//                   "We have sent a 4-digit code to your registered mobile number",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     color: AppColors.textSecondary,
//                   ),
//                 ),

//                 const SizedBox(height: 40),

//                 //  OTP INPUT
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children:
//                       List.generate(4, (index) => _otpTextField(index == 0)),
//                 ),

//                 const SizedBox(height: 40),

//                 //  BUTTON (THEME APPLIED)
//                 isLoading
//                     ? const CircularProgressIndicator(
//                         color: AppColors.primary,
//                       )
//                     : SizedBox(
//                         width: double.infinity,
//                         height: 55,
//                         child: ElevatedButton(
//                           onPressed: verifyOtp,
//                           child: const Text("VERIFY & PROCEED"),
//                         ),
//                       ),

//                 const SizedBox(height: 20),

//                 //  RESEND
//                 TextButton(
//                   onPressed: _counter == 0
//                       ? () {
//                           setState(() => _counter = 30);
//                           _startTimer();
//                         }
//                       : null,
//                   child: Text(
//                     _counter > 0
//                         ? "Resend code in ${_counter}s"
//                         : "Resend Code",
//                     style: TextStyle(
//                       color: _counter > 0
//                           ? AppColors.textSecondary
//                           : AppColors.secondary,
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 20),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   //  OTP FIELD
//   Widget _otpTextField(bool first) {
//     return SizedBox(
//       height: 68,
//       width: 64,
//       child: TextField(
//         autofocus: first,
//         textAlign: TextAlign.center,
//         keyboardType: TextInputType.number,
//         maxLength: 1,
//         onChanged: (value) {
//           if (value.length == 1) {
//             FocusScope.of(context).nextFocus();
//           }
//         },
//         decoration: InputDecoration(
//           counterText: "",
//           filled: true,
//           fillColor: AppColors.scaffoldBg,
//           enabledBorder: OutlineInputBorder(
//             borderSide: BorderSide(color: AppColors.primary.withOpacity(0.2)),
//             borderRadius: BorderRadius.circular(12),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderSide:
//                 const BorderSide(color: AppColors.secondary, width: 2),
//             borderRadius: BorderRadius.circular(12),
//           ),
//         ),
//       ),
//     );
//   }
// }
