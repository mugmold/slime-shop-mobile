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
      appBar: AppBar(title: const Text('Login')),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            const SizedBox(height: 12.0),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 24.0),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed:
                  _isLoading
                      ? null // matikan tombol jika sedang loading
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

                              context.read<UserProvider>().setUser(uid, uname);

                              Navigator.pushReplacementNamed(context, '/');

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "$message Selamat datang, $uname.",
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
                                              () => Navigator.pop(context),
                                        ),
                                      ],
                                    ),
                              );
                            }
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Terjadi kesalahan: $e")),
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
              child: // loading indicator
                  _isLoading
                      ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      )
                      : const Text('Login', style: TextStyle(fontSize: 16)),
            ),

            const SizedBox(height: 12.0),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/register');
              },
              child: const Text(
                'Belum punya akun? Daftar disini',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
