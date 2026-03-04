import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:read_quest/styles/app_text_styles.dart';
import 'package:read_quest/routes/app_routes.dart';
import '../viewmodel/login_view_model.dart';
import 'register_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      hintText: hint,
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(27),
        borderSide: const BorderSide(color: Color(0xFF8C8C8C)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(27),
        borderSide: const BorderSide(color: Color(0xFF111391)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginViewModel(),
      child: Builder(
        builder: (context) {
          final vm = context.watch<LoginViewModel>();

          return Scaffold(
            resizeToAvoidBottomInset: true,
            body: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFEDFCFF), Color(0xFF9EEFFF)],
                ),
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      Center(
                        child: Image.asset(
                          'assets/images/read_quest_logo_splash.png',
                          height: MediaQuery.of(context).size.height * 0.3,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Divider(color: Colors.grey[400], thickness: 1),
                      const SizedBox(height: 32),

                      const Text('Login', style: AppTextStyles.pageTitle),
                      const SizedBox(height: 24),

                      // Email
                      const Text('Email', style: AppTextStyles.inputLabel),
                      const SizedBox(height: 8),
                      TextField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: _inputDecoration('Enter your email'),
                        onChanged: vm.setEmail,
                      ),

                      const SizedBox(height: 16),

                      // Password
                      const Text('Password', style: AppTextStyles.inputLabel),
                      const SizedBox(height: 8),
                      _PasswordField(decoration: _inputDecoration('Enter your password')),

                      const SizedBox(height: 24),

                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: vm.isLoading
                              ? null
                              : () async {
                                  final msg = await context
                                      .read<LoginViewModel>()
                                      .login();

                                  if (!context.mounted) return;

                                  if (msg == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Login successful!')),
                                    );
                                    Navigator.pushReplacementNamed(
                                      context,
                                      AppRoutes.home,
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(msg)),
                                    );
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF155DFC),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(27),
                            ),
                            elevation: 5,
                          ),
                          child: vm.isLoading
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Text('Login',
                                  style: AppTextStyles.buttonText),
                        ),
                      ),

                      const SizedBox(height: 32),

                      Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Don’t have an account? ',
                              style: AppTextStyles.smallMuted,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const RegisterScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Create new account',
                                style: AppTextStyles.clickableAccent,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PasswordField extends StatefulWidget {
  final InputDecoration decoration;
  const _PasswordField({required this.decoration});

  @override
  State<_PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<_PasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    final vm = context.read<LoginViewModel>();

    return TextField(
      obscureText: _obscure,
      decoration: widget.decoration.copyWith(
        suffixIcon: IconButton(
          onPressed: () => setState(() => _obscure = !_obscure),
          icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
        ),
      ),
      onChanged: vm.setPassword,
    );
  }
}