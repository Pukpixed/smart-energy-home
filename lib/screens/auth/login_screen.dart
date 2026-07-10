import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../dashboard/dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;
  bool _rememberMe = true;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFF071C24);
    const primaryColor = Color(0xFF41D6C3);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        foregroundColor: Colors.white,
        title: const Text("เข้าสู่ระบบ"),
      ),
      body: SafeArea(
        child: Consumer<AuthProvider>(
          builder: (context, auth, child) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    "อีเมล",
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "example@email.com",
                      hintStyle: const TextStyle(color: Colors.white38),
                      filled: true,
                      fillColor: const Color(0xFF0C2731),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "รหัสผ่าน",
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: passwordController,
                    obscureText: _obscureText,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFF0C2731),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.white70,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Checkbox(
                        value: _rememberMe,
                        activeColor: primaryColor,
                        onChanged: (value) {
                          setState(() {
                            _rememberMe = value ?? false;
                          });
                        },
                      ),
                      const Text(
                        "จดจำฉัน",
                        style: TextStyle(color: Colors.white),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          "ลืมรหัสผ่าน?",
                          style: TextStyle(color: primaryColor),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: auth.loading
                          ? null
                          : () async {
                              try {
                                await auth.login(
                                  emailController.text.trim(),
                                  passwordController.text,
                                );

                                if (!mounted) return;

                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const DashboardScreen(),
                                  ),
                                );
                              } catch (e) {
                                if (!mounted) return;

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(e.toString()),
                                  ),
                                );
                              }
                            },
                      child: auth.loading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              "เข้าสู่ระบบ",
                              style: TextStyle(fontSize: 18),
                            ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Center(
                    child: Text(
                      "หรือ เข้าสู่ระบบด้วย",
                      style: TextStyle(color: Colors.white60),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(30),
                        onTap: auth.loading
                            ? null
                            : () async {
                                try {
                                  await auth.signInWithGoogle();

                                  if (!mounted) return;

                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const DashboardScreen(),
                                    ),
                                  );
                                } catch (e) {
                                  if (!mounted) return;

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(e.toString()),
                                    ),
                                  );
                                }
                              },
                        child: Container(
                          width: 55,
                          height: 55,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Icon(
                            Icons.g_mobiledata,
                            color: Colors.red,
                            size: 42,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
