import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uber_db_project/Authentications/signup_screen.dart';

import '../methods/common_methods.dart';
import '../pages/home_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  CommonMethods cMethods = CommonMethods();

  signinFormValidation() {
    if (_passwordController.text.trim().length < 8) {
      cMethods.displaysnackBar("Your password must be at least 8 characters.", context);
    } else if (!_emailController.text.contains("@") || !_emailController.text.contains(".")) {
      cMethods.displaysnackBar("Please enter a valid email address.", context);
    } else {
      signInUser();
    }
  }

  // Sign in with Firebase Authentication
  signInUser() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => Center(child: CircularProgressIndicator()),
    );

    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      Navigator.pop(context); // Close the dialog
      cMethods.displaysnackBar("Logged in successfully! Welcome, ${userCredential.user!.email}", context);

      // Navigate to the Home Screen after login (replace with your actual screen)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (c) => HomePage()), // Replace with your actual home screen
      );
    } catch (e) {
      Navigator.pop(context); // Close the dialog
      cMethods.displaysnackBar("Login failed: ${e.toString()}", context);
    }}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              "Login",
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            TextFormField(
              controller: _passwordController,
              obscureText: true, // Hide password characters
              decoration: const InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                //checkIfNetworkIsAvailable();
              },
              child: const Text("Login"),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Don\'t have an account?'),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (c) => SignupScreen()),
                    );
                  },
                  child: const Text("Sign Up"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
