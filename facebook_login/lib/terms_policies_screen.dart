import 'package:flutter/material.dart';
import 'facebook_onboarding_screen.dart';
import 'find_account_screen.dart';

class TermsPoliciesScreen extends StatelessWidget {
  static const String routeName = '/terms';
  const TermsPoliciesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Back button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context); // Go back to save login info screen
                  },
                  child: Image.asset(
                    'assets/images/leftSideArrow.png',
                    width: 24,
                    height: 24,
                  ),
                ),
              ),
            ),
            
            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    
                    // Title
                    const Text(
                      'Agree to Facebook\'s terms and policies',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Paragraph 1
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          height: 1.4,
                        ),
                        children: [
                          TextSpan(text: 'People who use our service may have uploaded your contact information to Facebook. '),
                          TextSpan(
                            text: 'Learn more',
                            style: TextStyle(
                              color: Color(0xFF005FD5),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Paragraph 2
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          height: 1.4,
                        ),
                        children: [
                          TextSpan(text: 'By tapping I agree, you agree to create an account and to Facebook\'s '),
                          TextSpan(
                            text: 'terms',
                            style: TextStyle(
                              color: Color(0xFF005FD5),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(text: ', '),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: TextStyle(
                              color: Color(0xFF005FD5),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(text: ' and '),
                          TextSpan(
                            text: 'Cookies Policy',
                            style: TextStyle(
                              color: Color(0xFF005FD5),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(text: '.'),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Paragraph 3
                    const Text(
                      'The Privacy Policy describes the ways we can use the information we collect when you create an account. For example, we use this information to provide, personalise and improve our products, including ads.',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        height: 1.4,
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // I agree button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const FacebookOnboardingScreen(),
                              settings: const RouteSettings(name: FacebookOnboardingScreen.routeName),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF005FD5),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'I agree',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
            
            // Bottom link
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FindAccountScreen(),
                    ),
                  );
                },
                child: const Text(
                  'Find my account',
                  style: TextStyle(
                    color: Color(0xFF005FD5),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
