import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:slime_shop/providers/user_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                      ),
                      children: [
                        TextSpan(
                          text: "Slime",
                          style: TextStyle(color: Color(0xFF10B981)),
                        ),
                        TextSpan(
                          text: "Shop",
                          style: TextStyle(color: Color(0xFF1F2937)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Welcome back! Please login.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 32),

                  TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 24.0),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed:
                        _isLoading
                            ? null
                            : () async {
                              String username = _usernameController.text;
                              String password = _passwordController.text;

                              setState(() {
                                _isLoading = true;
                              });

                              try {
                                final response = await request.postJson(
                                  "https://bermulya-anugrah-slimeshop.pbp.cs.ui.ac.id/auth/login/",
                                  jsonEncode(<String, String>{
                                    'username': username,
                                    'password': password,
                                  }),
                                );

                                if (context.mounted) {
                                  if (response['status'] == true) {
                                    String message = response['message'];
                                    String uname = response['username'];
                                    int uid = response['id'];
                                    context.read<UserProvider>().setUser(
                                      uid,
                                      uname,
                                    );
                                    Navigator.pushReplacementNamed(
                                      context,
                                      '/',
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "$message Selamat datang, $uname.",
                                        ),
                                        backgroundColor: const Color(
                                          0xFF10B981,
                                        ),
                                      ),
                                    );
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder:
                                          (context) => AlertDialog(
                                            title: const Text('Login Gagal'),
                                            content: Text(
                                              response['message'] ??
                                                  "Cek kredensial Anda.",
                                            ),
                                            actions: [
                                              TextButton(
                                                child: const Text('OK'),
                                                onPressed:
                                                    () =>
                                                        Navigator.pop(context),
                                              ),
                                            ],
                                          ),
                                    );
                                  }
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Terjadi kesalahan: $e"),
                                      backgroundColor: Color.fromARGB(
                                        255,
                                        197,
                                        47,
                                        47,
                                      ),
                                    ),
                                  );
                                }
                              } finally {
                                if (mounted) {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                }
                              }
                            },
                    child:
                        _isLoading
                            ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 3,
                              ),
                            )
                            : const Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                  ),

                  const SizedBox(height: 16.0),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: RichText(
                      text: const TextSpan(
                        text: "Belum punya akun? ",
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                        children: [
                          TextSpan(
                            text: "Daftar disini",
                            style: TextStyle(
                              color: Color(0xFF10B981),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
