import 'package:flutter/material.dart';
import '../constants/app_routes.dart';
import '../constants/app_theme.dart';
import '../services/auth_service.dart';
import '../widgets/app_logo.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();

  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final success = await _authService.login(
      _usernameController.text,
      _passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      setState(() => _isLoading = false);
      Navigator.of(context).pushReplacementNamed(AppRoutes.dashboard);
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Invalid credentials. Enter "admin" and "admin".';
      });
    }
  }

  void _fillDemoCredentials() {
    setState(() {
      _usernameController.text = 'admin';
      _passwordController.text = 'admin';
      _errorMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softGray, // Soft Gray #F5F7FA
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Card(
              color: AppColors.white, // White #FFFFFF
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusDialog),
                side: const BorderSide(color: AppColors.border),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xxxl,
                  vertical: AppSpacing.xxxl + 4,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Unified Product Logo
                      const Center(
                        child: AppLogo(iconSize: 32, isCompact: false),
                      ),
                      const SizedBox(height: AppSpacing.xxl),

                      // Sign In Heading (Deep Blue #1F4E79)
                      const Text(
                        'Sign In',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.deepBlue,
                          letterSpacing: -0.4,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Enter your administrator credentials to proceed',
                        style: AppTypography.caption.copyWith(fontSize: 13),
                      ),
                      const SizedBox(height: AppSpacing.xxl),

                      // Error Banner
                      if (_errorMessage != null) ...[
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          decoration: BoxDecoration(
                            color: AppColors.deleteBg,
                            borderRadius: BorderRadius.circular(AppSpacing.radiusInput),
                            border: Border.all(color: AppColors.deleteBorder),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.error_outline, color: AppColors.red, size: 18),
                              const SizedBox(width: AppSpacing.sm),
                              Expanded(
                                child: Text(
                                  _errorMessage!,
                                  style: AppTypography.caption.copyWith(
                                    color: AppColors.red,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                      ],

                      // Username Input
                      _buildFieldLabel('Username'),
                      TextFormField(
                        controller: _usernameController,
                        decoration: const InputDecoration(
                          hintText: 'admin',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Username is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // Password Input
                      _buildFieldLabel('Password'),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          hintText: 'admin',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              size: 18,
                            ),
                            onPressed: () {
                              setState(() => _obscurePassword = !_obscurePassword);
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Password is required';
                          }
                          return null;
                        },
                        onFieldSubmitted: (_) => _handleLogin(),
                      ),
                      const SizedBox(height: AppSpacing.xxl),

                      // Sign In Button (Corporate Blue #5B9BD5)
                      SizedBox(
                        height: AppSpacing.buttonHeight + 2,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.corporateBlue, // Corporate Blue
                            foregroundColor: Colors.white,
                          ),
                          onPressed: _isLoading ? null : _handleLogin,
                          child: _isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text('Sign In to Dashboard'),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxl),

                      // Demo Credentials Box
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.md + 2),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(AppSpacing.radiusInput),
                          border: Border.all(color: AppColors.corporateBlue.withValues(alpha: 0.3)),
                        ),
                        child: Column(
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.key_outlined, size: 15, color: AppColors.deepBlue),
                                SizedBox(width: AppSpacing.xs + 2),
                                Text(
                                  'Demo Administrator Account',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.5,
                                    color: AppColors.deepBlue,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            const Text(
                              'Username: admin  •  Password: admin',
                              style: TextStyle(fontSize: 12.5, color: AppColors.charcoal),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            InkWell(
                              onTap: _fillDemoCredentials,
                              borderRadius: BorderRadius.circular(AppSpacing.radiusBadge),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.auto_fix_high, size: 14, color: AppColors.deepBlue),
                                    SizedBox(width: 4),
                                    Text(
                                      'Auto-fill credentials',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.deepBlue,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
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
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.charcoal, // Charcoal #1F2937
        ),
      ),
    );
  }
}
