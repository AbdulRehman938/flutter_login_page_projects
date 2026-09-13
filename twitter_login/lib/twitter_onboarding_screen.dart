import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TwitterOnboardingScreen extends StatelessWidget {
  const TwitterOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFF8FAFC)),
          onPressed: () => Navigator.pop(context),
        ),
        title: SvgPicture.asset(
          'assets/images/twitterIcon.svg',
          width: 24,
          height: 24,
          colorFilter: const ColorFilter.mode(
            Color(0xFFF8FAFC),
            BlendMode.srcIn,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Color(0xFFF8FAFC)),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Color(0xFFF8FAFC)),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        children: [
          // Stories section
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
              itemCount: 5,
              itemBuilder: (context, index) {
                return Container(
                  width: 80,
                  margin: const EdgeInsets.only(right: 8.0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundColor: const Color(0xFF2F3336),
                        child: index == 0
                            ? const Icon(Icons.add, color: Color(0xFFF8FAFC))
                            : null,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        index == 0 ? 'Your story' : 'User ${index + 1}',
                        style: const TextStyle(
                          color: Color(0xFFF8FAFC),
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const Divider(color: Color(0xFF2F3336), thickness: 1),

          // Create post section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: const Color(0xFF1D9BF0),
                  child: const Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "What's happening?!",
                      hintStyle: TextStyle(
                        color: Color(0xFF71767B),
                        fontSize: 16,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              const SizedBox(width: 12),
              const Icon(Icons.image, color: Color(0xFF1D9BF0)),
              const SizedBox(width: 12),
              const Icon(Icons.gif_box_outlined, color: Color(0xFF1D9BF0)),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1D9BF0),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 0,
                ),
                child: const Text('Post'),
              ),
            ],
          ),
        ),
        ],
      ),
    );
  }
}
