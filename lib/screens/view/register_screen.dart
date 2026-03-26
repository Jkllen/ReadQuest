import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:read_quest/styles/app_text_styles.dart';
import 'login_screen.dart';
import 'package:read_quest/services/auth_services.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool obscurePassword = true;
  bool isLoading = false;
  bool autoValidate = false;

  @override
  void dispose() {
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  String? validateEmail(String? value) {
    final email = value?.trim() ?? '';

    if (email.isEmpty) {
      return 'Email is required.';
    }

    final emailRegex = RegExp(
      r'^[\w\.\-]+@([\w\-]+\.)+[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(email)) {
      return 'Enter a valid email address.';
    }

    return null;
  }

  String? validateUsername(String? value) {
    final username = value?.trim() ?? '';

    if (username.isEmpty) {
      return 'Username is required.';
    }

    if (username.length < 3) {
      return 'Username must be at least 3 characters.';
    }

    if (username.length > 20) {
      return 'Username must be at most 20 characters.';
    }

    final usernameRegex = RegExp(r'^[a-zA-Z0-9_]+$');

    if (!usernameRegex.hasMatch(username)) {
      return 'Only letters, numbers, and underscores are allowed.';
    }

    return null;
  }

  String? validatePassword(String? value) {
    final password = value ?? '';

    if (password.isEmpty) {
      return 'Password is required.';
    }

    if (password.length < 6) {
      return 'Password must be at least 6 characters.';
    }

    if (password.contains(' ')) {
      return 'Password must not contain spaces.';
    }

    return null;
  }

  Future<void> handleRegister() async {
    FocusScope.of(context).unfocus();

    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      setState(() => autoValidate = true);
      return;
    }

    setState(() => isLoading = true);

    final email = emailController.text.trim();
    final username = usernameController.text.trim();
    final password = passwordController.text;

    try {
      final user = await AuthService().register(
        email: email,
        password: password,
        username: username,
      );

      if (!mounted) return;

      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registered successfully!')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      final msg = switch (e.code) {
        'email-already-in-use' => 'That email is already registered.',
        'invalid-email' => 'Invalid email format.',
        'weak-password' => 'Password is too weak.',
        _ => 'Register failed: ${e.message}',
      };

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg)),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Register failed: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  InputDecoration inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppTextStyles.inputLabel,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(27),
        borderSide: const BorderSide(color: Color(0xFF8C8C8C)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(27),
        borderSide: const BorderSide(color: Color(0xFF8C8C8C)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(27),
        borderSide: const BorderSide(color: Color(0xFF111391)),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(27),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(27),
        borderSide: const BorderSide(color: Colors.red),
      ),
      errorStyle: const TextStyle(fontSize: 12),
    );
  }

  @override
  Widget build(BuildContext context) {
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
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            child: Form(
              key: _formKey,
              autovalidateMode: autoValidate
                  ? AutovalidateMode.onUserInteraction
                  : AutovalidateMode.disabled,
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

                  const Text('Register', style: AppTextStyles.pageTitle),
                  const SizedBox(height: 32),

                  // Email
                  TextFormField(
                    controller: emailController,
                    decoration: inputDecoration('Email'),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: validateEmail,
                  ),

                  const SizedBox(height: 20),

                  // Username
                  TextFormField(
                    controller: usernameController,
                    decoration: inputDecoration('Username'),
                    textInputAction: TextInputAction.next,
                    validator: validateUsername,
                  ),

                  const SizedBox(height: 20),

                  // Password
                  TextFormField(
                    controller: passwordController,
                    obscureText: obscurePassword,
                    textInputAction: TextInputAction.done,
                    validator: validatePassword,
                    onFieldSubmitted: (_) {
                      if (!isLoading) {
                        handleRegister();
                      }
                    },
                    decoration: inputDecoration('Password').copyWith(
                      suffixIcon: IconButton(
                        onPressed: () =>
                            setState(() => obscurePassword = !obscurePassword),
                        icon: Icon(
                          obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  Center(
                    child: SizedBox(
                      width: 160,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : handleRegister,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF155DFC),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(27),
                          ),
                          elevation: 5,
                        ),
                        child: isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Register',
                                style: AppTextStyles.buttonText,
                              ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Already have an account? ',
                          style: AppTextStyles.smallMuted,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            'Login',
                            style: AppTextStyles.clickableAccent,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}