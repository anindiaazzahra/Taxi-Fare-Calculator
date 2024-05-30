import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxi_fare/utils/colors.dart';
import 'package:taxi_fare/screens/sign_in_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user = prefs.getString('user');
    if (user != null) {
      context.goNamed("home");
    } else {
      Future.delayed(const Duration(seconds: 3), () {
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        color: Colors.white,
        height: size.height,
        width: size.width,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: size.height * 0.53,
                width: size.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    image: const DecorationImage(
                      image: AssetImage("lib/assets/images/taxi.png"),
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    )
                ),
              ),
            ),
            Positioned(
              top: size.height * 0.6,
              left: 0,
              right: 0,
              child: Center(
                child: Column(
                  children: [
                    Text(
                      "Let's Calculate Your\nTaxi Fare\nEffortlessly!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 34,
                        color: textColor1,
                        height: 1.2,
                      ),
                    ),

                    const SizedBox(height: 18),
                    const SizedBox(height: 18),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 26,
                        vertical: 32,
                      ),
                      child: Container(
                        height: size.height * 0.08,
                        width: size.width,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: ElevatedButton(
                            onPressed: () {
                              context.goNamed("signin");
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              minimumSize: Size(size.width, 68),
                            ),
                            child: const Text(
                              "Get Started",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 22,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
