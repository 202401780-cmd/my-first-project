import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF4F7FC),
      ),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  Future<void> _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse('http://127.0.0.1:8000/api/users/login/');
    
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': _emailController.text,
          'password': _passwordController.text,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login Successful!')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'] ?? 'Invalid credentials')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error connecting to server: $e')),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: -screenSize.height * 0.1,
            right: -screenSize.width * 0.15,
            child: Transform.rotate(
              angle: 0.785398,
              child: Container(
                width: screenSize.width * 0.6,
                height: screenSize.width * 0.6,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.40),
                  borderRadius: BorderRadius.circular(32),
                ),
              ),
            ),
          ),
          Positioned(
            top: screenSize.height * 0.35,
            left: -screenSize.width * 0.2,
            child: Container(
              width: screenSize.width * 0.5,
              height: screenSize.width * 0.5,
              decoration: BoxDecoration(
                color: const Color(0xFF3A7BD5).withOpacity(0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 56),
                  const Text(
                    'Welcome Back,',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A202C),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Sign in to continue.',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF7D8A99),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Container(
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1A202C),
                        ),
                        decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.person_outline,
                            color: Color(0xFF7D8A99),
                            size: 22,
                          ),
                          labelText: 'Email Address',
                          labelStyle: TextStyle(
                            color: Color(0xFF7D8A99),
                            fontSize: 15,
                          ),
                          floatingLabelStyle: TextStyle(
                            color: Color(0xFF3A7BD5),
                            fontSize: 12,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: TextField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1A202C),
                        ),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.lock_outline,
                            color: Color(0xFF7D8A99),
                            size: 22,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword 
                                  ? Icons.visibility_off_outlined 
                                  : Icons.visibility_outlined,
                              color: const Color(0xFF7D8A99),
                              size: 22,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          labelText: 'Password',
                          labelStyle: const TextStyle(
                            color: Color(0xFF7D8A99),
                            fontSize: 15,
                          ),
                          floatingLabelStyle: const TextStyle(
                            color: Color(0xFF3A7BD5),
                            fontSize: 12,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(padding: EdgeInsets.zero),
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1A202C),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Container(
                          width: double.infinity,
                          height: 56,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF3A7BD5).withOpacity(0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF3A7BD5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'LOGIN',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                        ),
                  const SizedBox(height: 28),
                  Row(
                    children: const [
                      Expanded(child: Divider(color: Color(0xFFE2E8F0), thickness: 1)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'OR',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF7D8A99),
                          ),
                        ),
                      ),
                      Expanded(child: Divider(color: Color(0xFFE2E8F0), thickness: 1)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
                    ),
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.network(
                            'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/24px-Google_%22G%22_logo.svg.png',
                            height: 20,
                            width: 20,
                            errorBuilder: (context, error, stackTrace) => const Icon(Icons.g_mobiledata, color: Colors.red),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Sign in with Google',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF1A202C),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(fontSize: 14, fontFamily: 'sans-serif'),
                        children: [
                          const TextSpan(
                            text: "Don't have an account? ",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF1A202C),
                            ),
                          ),
                          TextSpan(
                            text: 'Sign Up',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF3A7BD5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        backgroundColor: const Color(0xFF3A7BD5),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          'Welcome to the Application!',
          style: TextStyle(fontSize: 20, color: Color(0xFF1A202C)),
        ),
      ),
    );
  }
}