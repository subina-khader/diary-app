import 'package:diary/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../widgets/onboarding_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();

  bool lastPage = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void nextPage() {
    _controller.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFDF2F5),

      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _controller,
                onPageChanged: (index) {
                  setState(() {
                    lastPage = index == 2;
                  });
                },
                children: const [
                  OnboardingPage(
                    image: "assets/images/onboarding/writestory.png",
                    title: "Write Your Story",
                    description:
                    "Capture your thoughts, memories and everyday moments in your own personal diary.",
                  ),

                  OnboardingPage(
                    image: "assets/images/onboarding/memories.png",
                    title: "Relive Every Memory",
                    description:
                    "Add photos, videos and moods to make every diary entry more meaningful.",
                  ),

                  OnboardingPage(
                    image: "assets/images/onboarding/privacy.png",
                    title: "Private & Secure",
                    description:
                    "Protect your diaries with passwords and keep your memories safe.",
                  ),
                ],
              ),
            ),

            SmoothPageIndicator(
              controller: _controller,
              count: 3,
              effect: WormEffect(
                activeDotColor: const Color(0xffC97A8D),
                dotColor: Colors.pink.shade100,
                dotHeight: 10,
                dotWidth: 10,
              ),
            ),

            const SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffC97A8D),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  onPressed: () {
                    if (lastPage) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => HomeScreen(),
                        ),
                      );
                    } else {
                      nextPage();
                    }
                  },
                  child: Text(
                    lastPage ? "Get Started" : "Next",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),

            TextButton(
              onPressed: () {
                _controller.animateToPage(
                  2,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                );
              },
              child: Text(
                lastPage ? "" : "Skip",
                style: TextStyle(
                  color: Colors.grey.shade700,
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}