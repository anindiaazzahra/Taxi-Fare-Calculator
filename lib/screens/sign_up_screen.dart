import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:taxi_fare/utils/colors.dart';
import 'package:taxi_fare/models/user.dart';
import 'package:taxi_fare/utils/encryption.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpScreen> {
  bool _obscureText = true;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _birthDateController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();
      String encryptedPassword = EncryptionUtil.encryptText(password);
      String birthDate = _selectedDate != null
          ? "${_selectedDate!.toLocal()}".split(' ')[0]
          : "";

      final userBox = await Hive.openBox<User>('userBox');

      if (userBox.containsKey(email)) {
        _showErrorDialog('Email already exists!');
        return;
      }

      userBox.put(email, User(
        email: email,
        password: encryptedPassword,
        dateOfBirth: birthDate,
      ));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sign Up Successful!'),
          backgroundColor: Colors.green,
        ),
      );

      context.goNamed("signin");

      _emailController.clear();
      _birthDateController.clear();
      _passwordController.clear();
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Row(
          children: [
            Icon(Icons.error_outline, color: errorColor),
            SizedBox(width: 10),
            Text(
              'Error',
              style: TextStyle(
                color: errorColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: TextStyle(
            color: textColor1,
            fontSize: 16,
          ),
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: errorColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'Okay',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(top: 60.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: size.height * 0.03),
                Text(
                  "Sign Up",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 37,
                    color: textColor1,
                  ),
                ),
                const SizedBox(height: 15),
                _inputField("Email", _emailController),
                _datePickerField("Date of birth", _selectedDate),
                _inputField("Password", _passwordController, isPassword: true),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 22),
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: _signUp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          minimumSize: Size(size.width, 68),
                        ),
                        child: const Text(
                          "Sign Up",
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
                          text: "Already have an account? ",
                          style: TextStyle(
                            color: textColor2,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          children: [
                            TextSpan(
                              text: "Sign In Here",
                              style: TextStyle(
                                color: secondaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  context.goNamed("signin");
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
                  _obscureText
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
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

  Widget _datePickerField(String text, DateTime? selectedDate) {
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
            onTap: () => _selectDate(context),
            controller: TextEditingController(
              text: selectedDate != null
                  ? "${selectedDate.toLocal()}".split(' ')[0]
                  : "",
            ),
            readOnly: true,
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
              hintText: "Select " + text.toLowerCase(),
              hintStyle: const TextStyle(
                color: Colors.black45,
                fontSize: 18,
              ),
              suffixIcon: const Icon(
                Icons.calendar_today_outlined,
                color: Colors.black26,
              ),
              errorStyle: const TextStyle(
                fontSize: 14,
              ),
            ),
            validator: (value) {
              if (selectedDate == null) {
                return 'Please select a date';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
