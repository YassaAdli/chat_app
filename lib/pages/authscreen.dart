import 'package:chat_app/constants.dart';
import 'package:chat_app/pages/signincard.dart';
import 'package:chat_app/pages/signupcard.dart';
import 'package:flutter/material.dart';



class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  static String id = 'AuthScreen';
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
    late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      Signincard(
        onSignupTap: () {
          _pageController.animateToPage(
            1,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
      ),
      Signupcard(
        onSigninTap: () {
          _pageController.animateToPage(
            0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
      ),
    ];

    return Scaffold(
      backgroundColor: KPrimaryColor,
      body: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Column(
          children: [
            const SizedBox(height: 32),
            const Center(
              child: Text(
                "ChatApp",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 80),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemBuilder: (context, index) {
                  final actualIndex = index % 2;
                  return pages[actualIndex];
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
