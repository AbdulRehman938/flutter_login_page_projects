import 'package:flutter/material.dart';
import 'gender_selection_screen.dart';
import 'facebook_login_screen.dart';
import 'get_started_screen.dart';
import 'name_input_screen.dart';
import 'date_of_birth_screen.dart';
import 'mobile_number_screen.dart';
import 'email_address_screen.dart';
import 'password_screen.dart';
import 'save_login_info_screen.dart';
import 'terms_policies_screen.dart';
import 'find_account_screen.dart';
import 'search_by_mobile_screen.dart';

class FacebookOnboardingScreen extends StatelessWidget {
  static const String routeName = '/onboarding';
  const FacebookOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Facebook Demo',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome message
            const Text(
              'Facebook Onboarding Demo',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Navigate to any screen in the signup flow',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF65676B),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Navigation buttons
            const Text(
              'Navigate to Screens',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 2.5,
              children: [
                _buildNavButton(context, 'Login', const FacebookLoginScreen()),
                _buildNavButton(context, 'Get Started', const GetStartedScreen()),
                _buildNavButton(context, 'Name Input', const NameInputScreen()),
                _buildNavButton(context, 'Date of Birth', const DateOfBirthScreen()),
                _buildNavButton(context, 'Gender', const GenderSelectionScreen()),
                _buildNavButton(context, 'Mobile', const MobileNumberScreen()),
                _buildNavButton(context, 'Email', const EmailAddressScreen()),
                _buildNavButton(context, 'Password', const PasswordScreen()),
                _buildNavButton(context, 'Save Login', const SaveLoginInfoScreen()),
                _buildNavButton(context, 'Terms', const TermsPoliciesScreen()),
                _buildNavButton(context, 'Find Account', const FindAccountScreen()),
                _buildNavButton(context, 'Search Mobile', const SearchByMobileScreen()),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Instructions
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F2F5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Instructions:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '• Tap any button above to navigate to that screen\n• Use the back button on each screen to return\n• This is a frontend demo only',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF65676B),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavButton(BuildContext context, String label, Widget screen) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => screen,
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF005FD5),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 0,
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
