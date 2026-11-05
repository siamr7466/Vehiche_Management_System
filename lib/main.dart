import 'package:flutter/material.dart';
import 'constants/app_routes.dart';
import 'constants/app_theme.dart';
import 'screens/login_screen.dart';
import 'screens/vehicle_list_screen.dart';

void main() {
  runApp(const VehicleManagementApp());
}

class VehicleManagementApp extends StatelessWidget {
  const VehicleManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VehiclePro • Vehicle Management System',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.login,
      routes: {
        AppRoutes.login: (context) => const LoginScreen(),
        AppRoutes.dashboard: (context) => const VehicleListScreen(),
      },
    );
  }
}
