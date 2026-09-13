import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:ui';
import 'login_screen.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // X Logo at top
            Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.12),
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.2),
                        blurRadius: 30,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: SvgPicture.asset(
                    'assets/images/landingScreen.svg',
                    width: screenWidth * 0.12,
                    height: screenWidth * 0.12,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
            
            SizedBox(height: screenHeight * 0.15),
            
            // "See what's happening" text
            const Text(
              "See what's happening",
              style: TextStyle(
                color: Color(0xFFF8FAFC),
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            
            const Spacer(),
            
            // "Get the app" button
            SizedBox(
              width: screenWidth * 0.8,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Navigate to app download or continue
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF8FAFC),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Get the app',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            
            SizedBox(height: screenHeight * 0.02),
            
            // "Already have an account?" text
            const Text(
              "Already have an account?",
              style: TextStyle(
                color: Color(0xFFF8FAFC),
                fontSize: 14,
              ),
            ),
            
            SizedBox(height: screenHeight * 0.01),
            
            // "Sign in" button
            SizedBox(
              width: screenWidth * 0.8,
              height: 48,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFF8FAFC),
                  side: const BorderSide(
                    color: Color(0xFF262626),
                    width: 1,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text(
                  'Sign in',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            
            SizedBox(height: screenHeight * 0.04),
            
            // Footer links
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Wrap(
                spacing: 16,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: const [
                  _FooterLink('About'),
                  _FooterLink('Get App'),
                  _FooterLink('Grok'),
                  _FooterLink('Imagine'),
                  _FooterLink('Help'),
                  _FooterLink('Terms'),
                  _FooterLink('Privacy'),
                  _FooterLink('Cookies'),
                  _FooterLink('Careers'),
                  _FooterLink('Ads & Business'),
                  _FooterLink('Developers'),
                  _FooterLink('News'),
                  _FooterLink('Accessibility'),
                ],
              ),
            ),
            
            SizedBox(height: screenHeight * 0.008),
            
            // Copyright
            const Text(
              '© 2026 X Corp.',
              style: TextStyle(
                color: Color(0xFF71767B),
                fontSize: 12,
              ),
            ),
            
            SizedBox(height: screenHeight * 0.02),
          ],
        ),
      ),
    );
  }
}

class _FooterLink extends StatelessWidget {
  final String text;
  
  const _FooterLink(this.text);
  
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFF71767B),
        fontSize: 12,
        decoration: TextDecoration.underline,
      ),
    );
  }
}
