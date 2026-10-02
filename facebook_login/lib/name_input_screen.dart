import 'package:flutter/material.dart';
import 'date_of_birth_screen.dart';
import 'validation_utils.dart';

class NameInputScreen extends StatefulWidget {
  const NameInputScreen({super.key});

  @override
  State<NameInputScreen> createState() => _NameInputScreenState();
}

class _NameInputScreenState extends State<NameInputScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  bool _isLoading = false;
  String? _firstNameError;
  String? _surnameError;

  @override
  void dispose() {
    _firstNameController.dispose();
    _surnameController.dispose();
    super.dispose();
  }

  void _validateAndSubmit() {
    setState(() {
      _firstNameError = null;
      _surnameError = null;
    });

    bool hasError = false;

    if (_firstNameController.text.trim().isEmpty) {
      setState(() {
        _firstNameError = 'First name is required';
      });
      hasError = true;
    }

    if (_surnameController.text.trim().isEmpty) {
      setState(() {
        _surnameError = 'Surname is required';
      });
      hasError = true;
    }

    if (!hasError) {
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
              builder: (context) => const DateOfBirthScreen(),
            ),
          );
        }
      });
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
                      "What's your name?",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Subtitle
                    const Text(
                      'Enter the name you use in real life.',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Input fields - side by side
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            'First name',
                            _firstNameController,
                            _firstNameError,
                            (value) {
                              setState(() {
                                _firstNameError = null;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildTextField(
                            'Surname',
                            _surnameController,
                            _surnameError,
                            (value) {
                              setState(() {
                                _surnameError = null;
                              });
                            },
                          ),
                        ),
                      ],
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

  Widget _buildTextField(
    String placeholder,
    TextEditingController controller,
    String? errorText,
    Function(String)? onChanged,
  ) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: placeholder,
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
        suffixIconConstraints: const BoxConstraints(
          minWidth: 40,
          minHeight: 48,
          maxWidth: 48,
          maxHeight: 48,
        ),
        suffixIcon: errorText != null
            ? FacebookErrorTooltip(
                message: errorText,
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Color(0xFFDADDE1),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: errorText != null ? const Color(0xFFC40000) : const Color(0xFFDADDE1),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: errorText != null ? const Color(0xFFC40000) : const Color(0xFF005FD5),
            width: 2,
          ),
        ),
      ),
    );
  }
}
