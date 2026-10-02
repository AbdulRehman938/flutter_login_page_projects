import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_service.dart';
import 'facebook_login_screen.dart';

class FacebookOnboardingScreen extends StatefulWidget {
  static const String routeName = '/onboarding';
  const FacebookOnboardingScreen({super.key});

  @override
  State<FacebookOnboardingScreen> createState() => _FacebookOnboardingScreenState();
}

class _FacebookOnboardingScreenState extends State<FacebookOnboardingScreen> {
  User? _currentUser;
  StreamSubscription<User?>? _authSubscription;

  @override
  void initState() {
    super.initState();
    _currentUser = AuthService.instance.currentUser;
    _authSubscription = AuthService.instance.authStateChanges.listen((user) {
      if (mounted) {
        setState(() {
          _currentUser = user;
        });
      }
    });
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  Future<void> _handleLogout() async {
    await AuthService.instance.signOut();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logged out successfully')),
      );
      // Redirect to login screen and clear navigation stack
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const FacebookLoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Facebook Profile',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // User info card
              if (_currentUser != null)
                Container(
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE7F3FF),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF005FD5), width: 2),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Logged in as:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF005FD5),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: _handleLogout,
                            icon: const Icon(Icons.logout, size: 18),
                            label: const Text('Logout'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF005FD5),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 0,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _buildUserInfoRow('Email:', _currentUser?.email ?? 'N/A'),
                      const SizedBox(height: 12),
                      _buildUserInfoRow('User ID:', _currentUser?.uid ?? 'N/A'),
                    ],
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F2F5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Column(
                    children: [
                      Icon(Icons.info_outline, size: 48, color: Color(0xFF65676B)),
                      SizedBox(height: 16),
                      Text(
                        'Not logged in',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF65676B),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Sign in to see your account information.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF65676B),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 70,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF65676B),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
