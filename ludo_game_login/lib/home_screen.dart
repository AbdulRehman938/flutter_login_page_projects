import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_service.dart';

class HomeScreen extends StatelessWidget {
  final User user;

  const HomeScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final displayName = user.displayName?.isNotEmpty == true
        ? user.displayName!
        : user.email?.split('@').first ?? 'Player';

    return Scaffold(
      backgroundColor: const Color(0xFF280031),
      appBar: AppBar(
        backgroundColor: const Color(0xFF3C1F42),
        elevation: 0,
        title: const Text(
          'Ludo Game',
          style: TextStyle(
            color: Color(0xFFFFD700),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Sign Out',
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await AuthService.instance.signOut();
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 40,
                backgroundColor: Color(0xFF583BE3),
                child: Icon(Icons.sports_esports, size: 40, color: Colors.white),
              ),
              const SizedBox(height: 16),
              Text(
                'Welcome, $displayName!',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                user.email ?? '',
                style: const TextStyle(fontSize: 14, color: Colors.white70),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF3C1F42),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    const Text('Status: Authenticated', style: TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text('UID: ${user.uid}', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: 200,
                height: 48,
                child: ElevatedButton(
                  onPressed: () async {
                    await AuthService.instance.signOut();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE50914),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  ),
                  child: const Text('Sign Out', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
