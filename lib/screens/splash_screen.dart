import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_screen.dart';
import 'onboarding_screen.dart'; // Change to your home screen

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  // @override
  // void initState() {
  //   super.initState();
  //
  //   _controller = AnimationController(
  //     vsync: this,
  //     duration: const Duration(milliseconds: 1500),
  //   );
  //
  //   _fadeAnimation = Tween<double>(
  //     begin: 0,
  //     end: 1,
  //   ).animate(
  //     CurvedAnimation(
  //       parent: _controller,
  //       curve: Curves.easeIn,
  //     ),
  //   );
  //
  //   _scaleAnimation = Tween<double>(
  //     begin: .8,
  //     end: 1,
  //   ).animate(
  //     CurvedAnimation(
  //       parent: _controller,
  //       curve: Curves.easeOutBack,
  //     ),
  //   );
  //
  //   _controller.forward();
  //
  //   Timer(
  //     const Duration(seconds: 3),
  //         () {
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(
  //           builder: (_) =>  HomeScreen(),
  //         ),
  //       );
  //     },
  //   );
  // }
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    _scaleAnimation = Tween<double>(
      begin: .8,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _controller.forward();

    checkFirstTime();
  }
  Future<void> checkFirstTime() async {
    final prefs = await SharedPreferences.getInstance();

    final firstTime = prefs.getBool('first_time') ?? true;

    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    if (firstTime) {
      await prefs.setBool('first_time', false);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const OnboardingScreen(),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>  HomeScreen(),
        ),
      );
    }
  }
  // Future<void> checkFirstTime() async {
  //   final prefs = await SharedPreferences.getInstance();
  //
  //   final firstTime = prefs.getBool("first_time") ?? true;
  //
  //   await Future.delayed(const Duration(seconds: 3));
  //
  //   if (!mounted) return;
  //
  //   if (firstTime) {
  //     await prefs.setBool("first_time", false);
  //
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(
  //         builder: (_) => const OnboardingScreen(),
  //       ),
  //     );
  //   } else {
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(
  //         builder: (_) => HomeScreen(),
  //       ),
  //     );
  //   }
  // }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFDF2F5),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 140,
                  width: 140,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.pink.withOpacity(.15),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.menu_book_rounded,
                    size: 70,
                    color: Color(0xffC97A8D),
                  ),
                ),

                const SizedBox(height: 35),

                const Text(
                  "My Diary",
                  style: TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Caveat",
                    color: Color(0xff5D4037),
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  "Every memory deserves a home.",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade700,
                    letterSpacing: .3,
                  ),
                ),

                const SizedBox(height: 60),

                SizedBox(
                  width: 130,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: const LinearProgressIndicator(
                      minHeight: 5,
                      backgroundColor: Color(0xffF8DDE4),
                      valueColor: AlwaysStoppedAnimation(
                        Color(0xffC97A8D),
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