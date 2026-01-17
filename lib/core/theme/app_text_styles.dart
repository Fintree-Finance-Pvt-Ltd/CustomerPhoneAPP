import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Titles
  static const appBarTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const screenTitle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );

  // Amounts
  static const amountLarge = TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.bold,
    color: AppColors.success,
  );

  // Normal text
  static const body = TextStyle(
    fontSize: 14,
    color: AppColors.textPrimary,
  );

  static const subtitle = TextStyle(
    fontSize: 13,
    color: AppColors.textSecondary,
  );

  // Drawer
  static const drawerTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );
}
