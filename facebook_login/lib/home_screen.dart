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
        : user.email?.split('@').first ?? 'Facebook User';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF005FD5),
        elevation: 0,
        title: const Text(
          'Facebook',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
        ),
        actions: [
          IconButton(
            tooltip: 'Log Out',
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async => await AuthService.instance.signOut(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Row(
              children: [
                const CircleAvatar(
                  radius: 36,
                  backgroundColor: Color(0xFF005FD5),
                  child: Icon(Icons.person, size: 36, color: Colors.white),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(displayName,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(user.email ?? '',
                          style: const TextStyle(fontSize: 14, color: Colors.grey)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(children: [
                      Icon(Icons.verified_user, color: Color(0xFF005FD5)),
                      SizedBox(width: 8),
                      Text('Firebase Auth Connected',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ]),
                    const Divider(height: 20),
                    Text('UID: ${user.uid}',
                        style: const TextStyle(fontSize: 13, color: Colors.black87)),
                    const SizedBox(height: 6),
                    Text('Email Verified: ${user.emailVerified ? "Yes" : "No"}',
                        style: const TextStyle(fontSize: 13, color: Colors.black87)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () async => await AuthService.instance.signOut(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF005FD5),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                child: const Text('Log Out', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
