import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'facebook_onboarding_screen.dart';
import 'validation_utils.dart';

class TermsPoliciesScreen extends StatefulWidget {
  static const String routeName = '/terms';
  const TermsPoliciesScreen({super.key});

  @override
  State<TermsPoliciesScreen> createState() => _TermsPoliciesScreenState();
}

class _TermsPoliciesScreenState extends State<TermsPoliciesScreen> {
  bool _isLoading = false;

  Future<void> _agreeAndRegister() async {
    final email = AuthService.instance.pendingEmail;
    final password = AuthService.instance.pendingPassword;
    final displayName = AuthService.instance.pendingDisplayName;

    if (AuthService.instance.isFirebaseInitialized && email != null && password != null) {
      setState(() { _isLoading = true; });
      try {
        await AuthService.instance.registerWithEmailPassword(
          email: email,
          password: password,
          displayName: displayName,
        );
        AuthService.instance.clearPendingSignup();
        if (mounted) {
          setState(() { _isLoading = false; });
          showSuccessToast(context, 'Account created successfully!');
          // AuthGate will navigate to HomeScreen automatically.
        }
      } catch (e) {
        if (mounted) {
          setState(() { _isLoading = false; });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(AuthService.getReadableErrorMessage(e)),
            backgroundColor: const Color(0xFFC40000),
            behavior: SnackBarBehavior.floating,
          ));
        }
      }
    } else {
      // Firebase not init or no pending data – simulate
      showSuccessToast(context, 'Account created successfully!');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const FacebookOnboardingScreen(),
          settings: const RouteSettings(name: FacebookOnboardingScreen.routeName),
        ),
      );
    }
  }

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
                    Wrap(
                      children: [
                        const Text(
                          'People who use our service may have uploaded your contact information to Facebook. ',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 15,
                            height: 1.4,
                          ),
                        ),
                        InkWell(
                          onTap: () => showUnderDevelopmentDialog(context, 'Learn more'),
                          child: const Text(
                            'Learn more',
                            style: TextStyle(
                              color: Color(0xFF005FD5),
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Paragraph 2
                    Wrap(
                      children: [
                        const Text(
                          'By tapping I agree, you agree to create an account and to Facebook\'s ',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 15,
                            height: 1.4,
                          ),
                        ),
                        InkWell(
                          onTap: () => showUnderDevelopmentDialog(context, 'terms'),
                          child: const Text(
                            'terms',
                            style: TextStyle(
                              color: Color(0xFF005FD5),
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        const Text(', ', style: TextStyle(color: Colors.black87, fontSize: 15)),
                        InkWell(
                          onTap: () => showUnderDevelopmentDialog(context, 'Privacy Policy'),
                          child: const Text(
                            'Privacy Policy',
                            style: TextStyle(
                              color: Color(0xFF005FD5),
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        const Text(' and ', style: TextStyle(color: Colors.black87, fontSize: 15)),
                        InkWell(
                          onTap: () => showUnderDevelopmentDialog(context, 'Cookies Policy'),
                          child: const Text(
                            'Cookies Policy',
                            style: TextStyle(
                              color: Color(0xFF005FD5),
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        const Text('.', style: TextStyle(color: Colors.black87, fontSize: 15)),
                      ],
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
                        onPressed: _isLoading ? null : _agreeAndRegister,
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
                onTap: () => showUnderDevelopmentDialog(context, 'Find my account'),
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
