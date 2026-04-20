import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'forget_password_screen.dart';
import 'admin_panel_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isPasswordHidden = true;
  bool rememberMe = true;
  bool isLoading = false;

  // ✅ Campus picker
  String? selectedCampus = 'Main Campus';

  Future<void> handleLogin() async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final user = credential.user;

      if (user != null) {
        final tokenResult = await user.getIdTokenResult(true);
        final isAdmin = tokenResult.claims?['admin'] == true;

        if (!mounted) return;

        Navigator.pushReplacementNamed(
          context,
          isAdmin ? '/panel' : '/dashboard',
        );
      }
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login failed")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 40),


                Image.asset(
                  "assets/logo.png",
                  height: 250,
                ),

                const SizedBox(height: 10),


                const Text(
                  "ADMIN LOGIN",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    letterSpacing: 1,
                  ),
                ),

                DropdownButtonFormField<String>(
                  value: selectedCampus,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.location_city),
                    hintText: "Select Campus",
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'Main Campus',
                      child: Text('Main Campus'),
                    ),
                    DropdownMenuItem(
                      value: 'Downtown Campus',
                      child: Text('Downtown Campus'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedCampus = value;
                    });
                  },
                ),



                const SizedBox(height: 20),


                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.email_outlined),
                    hintText: "Enter your email",
                  ),
                ),

                const SizedBox(height: 20),



                TextField(
                  controller: passwordController,
                  obscureText: isPasswordHidden,
                  obscuringCharacter: '●',
                  style: const TextStyle(fontSize: 18),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock_outline),
                    hintText: "Password",
                    suffixIcon: IconButton(
                      icon: Icon(
                        isPasswordHidden
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          isPasswordHidden = !isPasswordHidden;
                        });
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 10),


                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: rememberMe,
                          onChanged: (value) {
                            setState(() {
                              rememberMe = value!;
                            });
                          },
                        ),
                        const Text("Remember me"),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                            ForgetPasswordScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        "Forgot password?",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),


                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                        : const Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}