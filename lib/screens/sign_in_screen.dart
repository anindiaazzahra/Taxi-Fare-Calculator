import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taxi_fare/constants/colors.dart';
import 'package:taxi_fare/screens/sign_up_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInScreen> {
  bool _obscureText = true;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _signIn() async {
  //   if (_formKey.currentState!.validate()) {
  //     String email = _emailController.text.trim();
  //     String password = _passwordController.text.trim();
  //
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //
  //     List<Map<String, dynamic>>? userList;
  //     try {
  //       userList = (json.decode(prefs.getString('userList') ?? '[]') as List<dynamic>).cast<Map<String, dynamic>>();
  //     } catch (e) {
  //       print('Error decoding user list: $e');
  //       userList = [];
  //     }
  //
  //     bool isLoggedIn = false;
  //     Map<String, dynamic>? loggedInUser;
  //     for (var user in userList) {
  //       if (user['email'] == email && user['password'] == password) {
  //         isLoggedIn = true;
  //         loggedInUser = user;
  //         break;
  //       }
  //     }
  //
  //     if (isLoggedIn) {
  //       await prefs.setBool('isLoggedIn', true);
  //       await prefs.setString('loggedInUserData', json.encode(loggedInUser));
  //       context.goNamed("home");
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content: Text('Invalid username or password!'),
  //         ),
  //       );
  //     }
  //   }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(top: 120.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: size.height * 0.03),
                Text(
                  "Sign In",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 37,
                    color: textColor1,
                  ),
                ),
                const SizedBox(height: 15),
                _inputField("Email", _emailController),
                _inputField("Password", _passwordController, isPassword: true),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 22),
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: _signIn,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          minimumSize: Size(size.width, 68),
                        ),
                        child: const Text(
                          "Sign In",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 22,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text.rich(
                        TextSpan(
                          text: "Not a member? ",
                          style: TextStyle(
                            color: textColor2,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          children: [
                            TextSpan(
                              text: "Sign Up Here",
                              style: TextStyle(
                                color: secondaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  context.goNamed("signup");
                                },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputField(String text, TextEditingController controller,
      {bool isPassword = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(text, style: const TextStyle(fontSize: 18)),
          ),
          TextFormField(
            controller: controller,
            obscureText: isPassword && _obscureText,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 22,
              ),
              fillColor: backgroundColor5,
              filled: true,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(15),
              ),
              hintText: "Enter " + text.toLowerCase(),
              hintStyle: const TextStyle(
                color: Colors.black45,
                fontSize: 18,
              ),
              suffixIcon: isPassword
                  ? GestureDetector(
                onTap: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                child: Icon(
                  _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  color: Colors.black26,
                ),
              )
                  : null,
              errorStyle: const TextStyle(
                fontSize: 14,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              if (text == 'Email' && !value.contains('@')) {
                return 'Please enter a valid email';
              }
              if (isPassword && value.length < 8) {
                return 'Password must be at least 8 characters';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
