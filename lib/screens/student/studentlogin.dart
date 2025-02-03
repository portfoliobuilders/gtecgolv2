import 'package:flutter/material.dart';
import 'package:lmsgit/provider/student_provider.dart';
import 'package:lmsgit/screens/student/student_registartion.dart';
import 'package:provider/provider.dart';

class UserLoginScreen extends StatefulWidget {
  const UserLoginScreen({super.key});

  @override
  State<UserLoginScreen> createState() => _UserLoginScreenState();
}

class _UserLoginScreenState extends State<UserLoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 2, 64, 95),
              Colors.black,
              Color.fromARGB(255, 2, 64, 95)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: LayoutBuilder(
            builder: (context, constraints) {
              bool isLargeScreen = constraints.maxWidth > 800;
              double formWidth = isLargeScreen
                  ? constraints.maxWidth * 0.4
                  : constraints.maxWidth * 0.8;
              double imageWidth =
                  isLargeScreen ? constraints.maxWidth * 0.2 : 0;

              return SingleChildScrollView( // Wrap the entire layout with a SingleChildScrollView
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Left Section: Login Form
                    Container(
                      width: formWidth,
                      padding: const EdgeInsets.all(24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Image.asset('assets/gtecwhite.png',
                                    height: 60, width: 60),
                                const SizedBox(width: 8),
                                Image.asset('assets/golblack.png', height: 60),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Welcome Back!',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Enter your details to login',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Email',
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.9),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              style: const TextStyle(color: Colors.black),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter an email';
                                }
                                if (!RegExp(r'^[\w-]+@([\w-]+\.)+[\w]{2,4}$')
                                    .hasMatch(value)) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Password',
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.9),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              style: const TextStyle(color: Colors.black),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a password';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 26),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    Provider.of<StudentAuthProvider>(context,
                                            listen: false)
                                        .StudentLogin(
                                      _emailController.text,
                                      _passwordController.text,
                                      context,
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 39, 220, 244),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                child: const Text(
                                  'Login',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            UserregisterScreen(),
                                      ),
                                    );
                                  },
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text(
                                    'Don’t have an account? Sign Up',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                                if (!isLargeScreen) // Show this only on small screens
                                  Column(
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          // Handle forgot password logic
                                        },
                                        style: TextButton.styleFrom(
                                          foregroundColor: Colors.white,
                                        ),
                                        child: const Text(
                                          'Forgot Password?',
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ),
                                      // TextButton(
                                      //   onPressed: () {
                                      //     Navigator.pushReplacement(
                                      //       context,
                                      //       MaterialPageRoute(
                                      //           builder: (context) =>
                                      //               AdminLoginScreen()),
                                      //     );
                                      //   },
                                      //   style: TextButton.styleFrom(
                                      //     foregroundColor: Colors.white,
                                      //   ),
                                      //   child: const Text(
                                      //     'Login as Admin',
                                      //     style: TextStyle(fontSize: 14),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                if (isLargeScreen) // Keep them on the same line for larger screens
                                  Row(
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          // Handle forgot password logic
                                        },
                                        style: TextButton.styleFrom(
                                          foregroundColor: Colors.white,
                                        ),
                                        child: const Text(
                                          'Forgot Password?',
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ),
                                      // TextButton(
                                      //   onPressed: () {
                                      //     Navigator.pushReplacement(
                                      //       context,
                                      //       MaterialPageRoute(
                                      //           builder: (context) =>
                                      //               AdminLoginScreen()),
                                      //     );
                                      //   },
                                      //   style: TextButton.styleFrom(
                                      //     foregroundColor: Colors.white,
                                      //   ),
                                      //   child: const Text(
                                      //     'Login as Admin',
                                      //     style: TextStyle(fontSize: 14),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (isLargeScreen)
                      Container(
                        width: imageWidth,
                        padding: const EdgeInsets.all(16),
                        child: Image.asset(
                          'assets/youcannot.png',
                          height: 600,
                          fit: BoxFit.contain,
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
