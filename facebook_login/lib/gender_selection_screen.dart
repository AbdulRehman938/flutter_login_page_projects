import 'package:flutter/material.dart';
import 'mobile_number_screen.dart';
import 'find_account_screen.dart';

class GenderSelectionScreen extends StatefulWidget {
  static const String routeName = '/gender';
  const GenderSelectionScreen({super.key});

  @override
  State<GenderSelectionScreen> createState() => _GenderSelectionScreenState();
}

class _GenderSelectionScreenState extends State<GenderSelectionScreen> {
  String? _selectedGender;
  String? _selectedPronoun;
  String _customGender = '';
  bool _isLoading = false;
  String? _errorMessage;
  bool _showMoreOptionsFields = false;

  final List<String> _pronounOptions = [
    'She: Wish her a happy birthday!',
    'He: Wish him a happy birthday!',
    'They: Wish them a happy birthday!',
  ];

  @override
  void initState() {
    super.initState();
  }

  void _handleMoreOptionsSelection() {
    setState(() {
      _selectedGender = 'More options';
      _errorMessage = null;
    });
    _showPronounBottomSheet();
  }

  void _showPronounBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Select your pronoun',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        _showMoreOptionsFields = true;
                      });
                    },
                    child: Image.asset(
                      'assets/images/cross.png',
                      width: 24,
                      height: 24,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Your pronoun is visible to everyone.',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: _pronounOptions.map((option) => GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedPronoun = option.split(':')[0];
                        _showMoreOptionsFields = true;
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            option.split(':')[0],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            option.split(':')[1].trim(),
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _validateAndSubmit() {
    setState(() {
      _errorMessage = null;
    });

    if (_selectedGender == null) {
      setState(() {
        _errorMessage = 'Please select a gender';
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MobileNumberScreen(),
            settings: const RouteSettings(name: MobileNumberScreen.routeName),
          ),
        );
      }
    });
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
                    Navigator.pop(context);
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
                    const SizedBox(height: 20),
                    
                    // Title
                    const Text(
                      "What's your gender?",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Subtitle
                    const Text(
                      'You can change who sees your gender on your profile later.',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Gender options container
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFDADDE1),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          _buildGenderOption('Female'),
                          _buildGenderOption('Male'),
                          _buildGenderOption('More options', showDescription: true),
                        ],
                      ),
                    ),
                    
                    // More options expanded section
                    if (_showMoreOptionsFields) ...[
                      const SizedBox(height: 24),
                      
                      // Bottom inputs container
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFFDADDE1),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            // Pronoun input
                            GestureDetector(
                              onTap: _showPronounBottomSheet,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    topRight: Radius.circular(12),
                                  ),
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey.shade300,
                                      width: 1,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0,
                                          vertical: 14.0,
                                        ),
                                        child: Text(
                                          _selectedPronoun ?? 'Your pronoun',
                                          style: TextStyle(
                                            color: _selectedPronoun != null
                                                ? Colors.black
                                                : const Color(0xFF65676B),
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 16.0),
                                      child: Image.asset(
                                        'assets/images/smallDownArrow.png',
                                        width: 24,
                                        height: 24,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            
                            // Custom gender input (optional)
                            TextField(
                              onChanged: (value) {
                                _customGender = value;
                              },
                              decoration: InputDecoration(
                                hintText: 'Gender (optional)',
                                hintStyle: const TextStyle(
                                  color: Color(0xFF65676B),
                                  fontSize: 16,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(12),
                                    bottomRight: Radius.circular(12),
                                  ),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(12),
                                    bottomRight: Radius.circular(12),
                                  ),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(12),
                                    bottomRight: Radius.circular(12),
                                  ),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    
                    // Error message
                    if (_errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    
                    const SizedBox(height: 32),
                    
                    // Next button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _validateAndSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF005FD5),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          elevation: 0,
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Text(
                                'Next',
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

  Widget _buildGenderOption(String value, {bool showDescription = false}) {
    return GestureDetector(
      onTap: () {
        if (value == 'More options') {
          _handleMoreOptionsSelection();
        } else {
          setState(() {
            _selectedGender = value;
            _showMoreOptionsFields = false;
            _errorMessage = null;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: value == 'More options' ? Colors.transparent : Colors.grey.shade300,
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (showDescription)
                    const Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Text(
                        "Select 'More options' to choose another gender or if you'd rather not say.",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Radio<String>(
              value: value,
              groupValue: _selectedGender,
              onChanged: (value) {
                if (value == 'More options') {
                  _handleMoreOptionsSelection();
                } else {
                  setState(() {
                    _selectedGender = value;
                    _showMoreOptionsFields = false;
                    _errorMessage = null;
                  });
                }
              },
              activeColor: const Color(0xFF005FD5),
            ),
          ],
        ),
      ),
    );
  }
}
