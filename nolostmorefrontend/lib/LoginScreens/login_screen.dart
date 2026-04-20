import 'package:flutter/material.dart';
import 'package:nolostmorefrontend/LoginScreens/app_config.dart';
import 'forget_password_screen.dart';
import 'signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:nolostmorefrontend/LoginScreens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isPasswordHidden = true;
  bool rememberMe = true;

  void handleLogin() async {
    try {
      UserCredential userCredential =
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      User? user = userCredential.user;

      await user!.reload();
      user = FirebaseAuth.instance.currentUser;

      if (!user!.emailVerified) {
        print(" Please verify your email first");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Please verify your email first"),
          ),
        );
        return;
      }

      print(" Email verified — login success");

      final url = Uri.parse(AppConfig.login);

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": user.email,
        }),
      );

      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final name = data['name'];
        final userId = data['id'];
        final image = data['profile_image'] ?? "";
        final bio = data['bio'] ?? "";

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(
              username: name,
              userId: userId,
              profileImage: image,
              bio: bio,
            ),
          ),
        );
      } else {
        print("User not found in DB");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("User not found"),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      String message = "Please check email or password";

      if (e.code == 'wrong-password' || e.code == 'user-not-found') {
        message = "Please check email or password";
      }

      print("Login error: ${e.toString()}");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    } catch (e) {
      print(" Login error: ${e.toString()}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Login failed"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 40),

                Image.asset(
                  "assets/logo.png",
                  height: 320,
                ),

                SizedBox(height: 10),

                Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),

                SizedBox(height: 40),

                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email_outlined),
                    hintText: "Enter your email",
                  ),
                ),

                SizedBox(height: 20),

                TextField(
                  controller: passwordController,
                  obscureText: isPasswordHidden,
                  obscuringCharacter: '●',
                  style: TextStyle(fontSize: 18),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock_outline),
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

                SizedBox(height: 10),

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
                        Text("Remember me"),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ForgetPasswordScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "Forgot password?",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: Text(
                      "Login",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),

                SizedBox(height: 15),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have account? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignupScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "Signup here",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}