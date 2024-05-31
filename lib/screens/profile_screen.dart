import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxi_fare/models/user.dart';
import 'package:taxi_fare/utils/colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String _email = '';
  User? currentUser = null;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString('user');
    if (userJson != null) {
      setState(() {
        _email = json.decode(userJson)['email'];
      });

      final userBox = await Hive.openBox<User>('userBox');
      User? currentUser = userBox.values.firstWhere(
              (user) => user.email == _email);
      if (currentUser != null) {
        setState(() {
          // Menetapkan currentUser
          this.currentUser = currentUser;
        });
      }
    }
  }

  Future<void> _signOut(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('user');
    context.go('/signin');
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: _email.isEmpty
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : Container(
        width: double.infinity,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 40.0, 0.0, 30.0),
              child: Center(
                child: CircleAvatar(
                  radius: 80,
                  backgroundImage: AssetImage('lib/assets/images/profile.png'),
                ),
              ),
            ),
            Text(
              _email.split('@').first,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _email.isNotEmpty
                ? Container(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    const Text(
                      'Email',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                      ),
                    ),
                    Text(
                      currentUser?.email ?? 'No email available',
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black54
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Date of Birth',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                      ),
                    ),
                    Text(
                      currentUser?.dateOfBirth ?? 'No date of birth available',
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black54
                      ),
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: ElevatedButton(
                        onPressed: () => _signOut(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          minimumSize: Size(size.width, 50),
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                        ),
                        child: const Text(
                          "Sign Out",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
                : const Text(
              'No user data available',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
