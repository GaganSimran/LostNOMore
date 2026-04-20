import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nolostmorefrontend/LoginScreens/app_config.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool isPasswordHidden = true;
  bool isConfirmPasswordHidden = true;

  String? passwordError;
  String? confirmPasswordError;
  String? phoneError;
  String? emailError;

  void handleSignup() async {
    setState(() {
      passwordError = null;
      confirmPasswordError = null;
      phoneError = null;
      emailError = null;
    });

    try {
      if (passwordController.text.length < 8) {
        setState(() {
          passwordError = "Password must be at least 8 characters";
        });
        return;
      }

      if (passwordController.text != confirmPasswordController.text) {
        setState(() {
          confirmPasswordError = "Passwords do not match";
        });
        return;
      }

      if (!emailController.text.contains("@gmail.com")) {
        setState(() {
          emailError = "Enter a valid Gmail address";
        });
        return;
      }

      if (phoneController.text.length != 10) {
        setState(() {
          phoneError = "Phone must be 10 digits";
        });
        return;
      }

      UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      User? user = userCredential.user;

      await user!.sendEmailVerification();

      final url = Uri.parse("${AppConfig.baseUrl}/users/signup");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "firebase_uid": user.uid,
          "email": user.email,
          "name": nameController.text,
          "phone": phoneController.text,
          "course": "flutter",
          "password": passwordController.text
        }),
      );

      print(response.body);

      Navigator.pop(context);
    } catch (e) {
      if (e is FirebaseAuthException) {
        print(" Firebase Error Code: ${e.code}");
        print(" Firebase Message: ${e.message}");
      } else {
        print(" Unknown Error: $e");
      }
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(height: 10),
                Center(
                  child: Text(
                    "Register Now",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                ),
                SizedBox(height: 40),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person_outline, color: Colors.grey),
                    hintText: "Enter your name",
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                ),
                SizedBox(height: 25),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    errorText: emailError,
                    prefixIcon: Icon(Icons.email_outlined, color: Colors.grey),
                    hintText: "Email adress",
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                ),
                SizedBox(height: 25),
                TextField(
                  controller: phoneController,
                  decoration: InputDecoration(
                    errorText: phoneError,
                    prefixIcon: Icon(Icons.phone_outlined, color: Colors.grey),
                    hintText: "Phone number",
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                ),
                SizedBox(height: 25),
                TextField(
                  controller: passwordController,
                  obscureText: isPasswordHidden,
                  decoration: InputDecoration(
                    errorText: passwordError,
                    prefixIcon: Icon(Icons.lock_outline, color: Colors.grey),
                    hintText: "Password",
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(isPasswordHidden
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          isPasswordHidden = !isPasswordHidden;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 25),
                TextField(
                  controller: confirmPasswordController,
                  obscureText: isConfirmPasswordHidden,
                  decoration: InputDecoration(
                    errorText: confirmPasswordError,
                    prefixIcon: Icon(Icons.lock_outline, color: Colors.grey),
                    hintText: "Confirm password",
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(isConfirmPasswordHidden
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          isConfirmPasswordHidden =
                          !isConfirmPasswordHidden;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: handleSignup,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[800],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      "Signup",
                      style: TextStyle(fontSize: 16, color: Colors.white70),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}