import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../providers/auth_provider.dart';
import '../providers/language_provider.dart';
import '../utils/app_localizations.dart';
import 'main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.login(
      _emailController.text.trim(),
      _passwordController.text,
    );

    setState(() {
      _isLoading = false;
    });

    if (success && mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    } else if (mounted) {
      final errorMsg = authProvider.errorMessage ?? AppLocalizations.of(context).invalidCredentials;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMsg),
          backgroundColor: Theme.of(context).colorScheme.error,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  void _showRegisterDialog() {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    bool isRegistering = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Sign Up / Đăng ký'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name / Họ tên',
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password / Mật khẩu',
                    prefixIcon: Icon(Icons.lock),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: isRegistering ? null : () => Navigator.pop(context),
              child: const Text('Cancel / Hủy'),
            ),
            ElevatedButton(
              onPressed: isRegistering
                  ? null
                  : () async {
                      if (nameController.text.isEmpty ||
                          emailController.text.isEmpty ||
                          passwordController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Please fill all fields / Vui lòng điền đầy đủ thông tin'),
                            backgroundColor: Colors.orange,
                          ),
                        );
                        return;
                      }

                      setDialogState(() {
                        isRegistering = true;
                      });

                      final authProvider =
                          Provider.of<AuthProvider>(context, listen: false);
                      final success = await authProvider.register(
                        emailController.text.trim(),
                        passwordController.text,
                        nameController.text.trim(),
                      );

                      if (success && mounted) {
                        Navigator.pop(context); // Close dialog
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Account created successfully! / Tạo tài khoản thành công!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                        // Auto navigate to main screen
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (context) => const MainScreen()),
                        );
                      } else if (mounted) {
                        setDialogState(() {
                          isRegistering = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Registration failed. Please try again. / Đăng ký thất bại.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
              child: isRegistering
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Sign Up / Đăng ký'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),

              // Language Toggle Button
              Align(
                alignment: Alignment.topRight,
                child: TextButton.icon(
                  onPressed: () => languageProvider.toggleLanguage(),
                  icon: const Icon(Icons.language),
                  label: Text(languageProvider.currentLanguageName),
                ),
              ),

              const SizedBox(height: 40),

              // Logo and Title
              Center(
                child: Column(
                  children: [
                    Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(
                                  context,
                                ).primaryColor.withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.inventory_2,
                            size: 50,
                            color: Colors.white,
                          ),
                        )
                        .animate()
                        .scale(duration: 800.ms, curve: Curves.elasticOut)
                        .fadeIn(duration: 600.ms),

                    const SizedBox(height: 24),

                    Text(
                          l10n.welcome,
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        )
                        .animate(delay: 200.ms)
                        .fadeIn(duration: 800.ms)
                        .slideY(begin: 0.3, end: 0),

                    const SizedBox(height: 8),

                    Text(
                          l10n.appTitle,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        )
                        .animate(delay: 400.ms)
                        .fadeIn(duration: 800.ms)
                        .slideY(begin: 0.3, end: 0),
                  ],
                ),
              ),

              const SizedBox(height: 60),

              // Login Form
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Email Field
                    TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: l10n.email,
                            prefixIcon: const Icon(Icons.email_outlined),
                            hintText: 'example@email.com',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!value.contains('@')) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        )
                        .animate(delay: 600.ms)
                        .fadeIn(duration: 800.ms)
                        .slideX(begin: -0.3, end: 0),

                    const SizedBox(height: 16),

                    // Password Field
                    TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            labelText: l10n.password,
                            prefixIcon: const Icon(Icons.lock_outlined),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        )
                        .animate(delay: 700.ms)
                        .fadeIn(duration: 800.ms)
                        .slideX(begin: -0.3, end: 0),

                    const SizedBox(height: 16),

                    // Remember Me & Forgot Password
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Row(
                            children: [
                              Checkbox(
                                value: _rememberMe,
                                onChanged: (value) {
                                  setState(() {
                                    _rememberMe = value ?? false;
                                  });
                                },
                              ),
                              Flexible(
                                child: Text(
                                  l10n.rememberMe,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          child: TextButton(
                            onPressed: () {
                              // TODO: Implement forgot password
                            },
                            child: Text(
                              l10n.forgotPassword,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ).animate(delay: 800.ms).fadeIn(duration: 800.ms),

                    const SizedBox(height: 32),

                    // Login Button
                    SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _login,
                            child: _isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : Text(
                                    l10n.login,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                          ),
                        )
                        .animate(delay: 900.ms)
                        .fadeIn(duration: 800.ms)
                        .slideY(begin: 0.3, end: 0),

                    const SizedBox(height: 24),

                    // Sign Up Section
                    Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? / Chưa có tài khoản?",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        TextButton(
                          onPressed: _showRegisterDialog,
                          child: Text(
                            'Sign Up / Đăng ký',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ).animate(delay: 1000.ms).fadeIn(duration: 800.ms),

                    const SizedBox(height: 8),

                    // Info box
                    Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Theme.of(
                                context,
                              ).primaryColor.withOpacity(0.3),
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: Theme.of(context).primaryColor,
                                size: 32,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'ℹ️ New User? / Người dùng mới?',
                                style: Theme.of(context).textTheme.titleSmall
                                    ?.copyWith(fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Please Sign Up to create your account.\nVui lòng Đăng ký để tạo tài khoản.',
                                style: Theme.of(context).textTheme.bodySmall,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                        .animate(delay: 1100.ms)
                        .fadeIn(duration: 800.ms)
                        .slideY(begin: 0.3, end: 0),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

