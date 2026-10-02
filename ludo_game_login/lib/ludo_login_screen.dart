import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'auth_service.dart';
import 'validation_utils.dart';

class LudoLoginScreen extends StatefulWidget {
  const LudoLoginScreen({super.key});

  @override
  State<LudoLoginScreen> createState() => _LudoLoginScreenState();
}

class _LudoLoginScreenState extends State<LudoLoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _agreeToPromotions = false;

  String? _emailError;
  String? _nameError;
  String? _passwordError;

  final GlobalKey<TooltipState> _emailTooltipKey = GlobalKey<TooltipState>();
  final GlobalKey<TooltipState> _nameTooltipKey = GlobalKey<TooltipState>();
  final GlobalKey<TooltipState> _passwordTooltipKey =
      GlobalKey<TooltipState>();

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleContinue() async {
    final emailErr = ValidationUtils.validateEmail(_emailController.text);
    final nameErr = ValidationUtils.validateName(_nameController.text);
    final passErr = ValidationUtils.validatePassword(_passwordController.text);

    setState(() {
      _emailError = emailErr;
      _nameError = nameErr;
      _passwordError = passErr;
    });

    if (emailErr != null) {
      Future.microtask(
          () => _emailTooltipKey.currentState?.ensureTooltipVisible());
    } else if (nameErr != null) {
      Future.microtask(
          () => _nameTooltipKey.currentState?.ensureTooltipVisible());
    } else if (passErr != null) {
      Future.microtask(
          () => _passwordTooltipKey.currentState?.ensureTooltipVisible());
    }

    if (emailErr != null || nameErr != null || passErr != null) return;

    setState(() => _isLoading = true);

    if (AuthService.instance.isFirebaseInitialized) {
      try {
        await AuthService.instance.registerWithEmailPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          displayName: _nameController.text.trim(),
        );
        if (mounted) {
          setState(() => _isLoading = false);
          showSuccessToast(context, 'Account created successfully!');
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      } catch (e) {
        if (mounted) {
          setState(() => _isLoading = false);
          final errorMessage = AuthService.getReadableErrorMessage(e);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: const Color(0xFFC40000),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } else {
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() => _isLoading = false);
          showSuccessToast(context, 'Account created successfully!');
        }
      });
    }
  }

  void _handleSignIn() {
    Navigator.pop(context);
  }

  void _handleBack() {
    Navigator.pop(context);
  }

  void _handleHeaderSignIn() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF280031),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final screenHeight = constraints.maxHeight;
            final screenWidth = constraints.maxWidth;

            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: screenHeight,
                ),
                child: Column(
                  children: [
                    // Header
                    Container(
                      color: const Color(0xFF3C1F42),
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.04,
                        vertical: screenHeight * 0.02,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Left side: Hamburger menu and logo
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.menu,
                                  color: Colors.white,
                                ),
                                onPressed: _handleBack,
                              ),
                              SizedBox(width: screenWidth * 0.02),
                              Image.asset(
                                'assets/logo.png',
                                width: screenWidth * 0.25,
                                height: screenHeight * 0.04,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Text(
                                    'CODASHOP',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          // Right side: Search, flag, EN, Sign in button
                          Row(
                            children: [
                              SvgPicture.asset(
                                'assets/searchIcon.svg',
                                width: 24,
                                height: 24,
                                colorFilter: const ColorFilter.mode(
                                  Colors.white,
                                  BlendMode.srcIn,
                                ),
                              ),
                              SizedBox(width: screenWidth * 0.02),
                              SvgPicture.asset(
                                'assets/flagLogo.svg',
                                width: 24,
                                height: 24,
                              ),
                              SizedBox(width: screenWidth * 0.01),
                              const Text(
                                'EN',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(width: screenWidth * 0.02),
                              InkWell(
                                onTap: _handleHeaderSignIn,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF583BE3),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Text(
                                    'Sign in',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Main content
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.06,
                        vertical: screenHeight * 0.03,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Back arrow and Sign Up
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.white,
                                ),
                                onPressed: _handleBack,
                              ),
                              const Text(
                                'Sign Up',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: screenHeight * 0.03),

                          // Pakistan and globe
                          Row(
                            children: [
                              const Text(
                                'Pakistan',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(width: screenWidth * 0.02),
                              SvgPicture.asset(
                                'assets/globeLogo.svg',
                                width: 20,
                                height: 20,
                                colorFilter: const ColorFilter.mode(
                                  Colors.white,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: screenHeight * 0.04),

                          // Email input
                          _buildInputField(
                            controller: _emailController,
                            hintText: 'Your Email Here',
                            icon: 'assets/emailIcon.svg',
                            errorText: _emailError,
                            tooltipKey: _emailTooltipKey,
                            onChanged: (_) {
                              if (_emailError != null) {
                                setState(() => _emailError = null);
                              }
                            },
                          ),
                          SizedBox(height: screenHeight * 0.02),

                          // Name input
                          _buildInputField(
                            controller: _nameController,
                            hintText: 'Your Name',
                            icon: 'assets/userNameIcon.svg',
                            errorText: _nameError,
                            tooltipKey: _nameTooltipKey,
                            onChanged: (_) {
                              if (_nameError != null) {
                                setState(() => _nameError = null);
                              }
                            },
                          ),
                          SizedBox(height: screenHeight * 0.02),

                          // Password input
                          _buildPasswordField(),
                          SizedBox(height: screenHeight * 0.02),

                          // Password requirements
                          const Text(
                            'Password must contain at least 8 characters including at least 1 number',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.03),

                          // Checkbox for promotions
                          Row(
                            children: [
                              Checkbox(
                                value: _agreeToPromotions,
                                onChanged: (value) {
                                  setState(() {
                                    _agreeToPromotions = value ?? false;
                                  });
                                },
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                visualDensity: VisualDensity.compact,
                                activeColor: const Color(0xFF583BE3),
                              ),
                              const Expanded(
                                child: Text(
                                  'I want to be the first to hear of discounts, promotions and more on Codashop',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: screenHeight * 0.03),

                          // Already have account
                          Row(
                            children: [
                              const Text(
                                'Already have an account? ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                              InkWell(
                                onTap: _handleSignIn,
                                child: const Text(
                                  'Sign in here',
                                  style: TextStyle(
                                    color: Color(0xFF583BE3),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: screenHeight * 0.04),

                          // Continue button
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _handleContinue,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF583BE3),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          Colors.white,
                                        ),
                                      ),
                                    )
                                  : const Text(
                                      'Continue',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.04),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required String icon,
    String? errorText,
    GlobalKey<TooltipState>? tooltipKey,
    void Function(String)? onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF3C1F42),
        borderRadius: BorderRadius.circular(8),
        border: errorText != null
            ? Border.all(color: const Color(0xFFED4956), width: 1)
            : null,
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Colors.white54,
            fontSize: 16,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(12),
            child: SvgPicture.asset(
              icon,
              width: 20,
              height: 20,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
          ),
          suffixIconConstraints:
              const BoxConstraints(minWidth: 0, minHeight: 0),
          suffixIcon: errorText != null && tooltipKey != null
              ? ErrorTooltip(
                  tooltipKey: tooltipKey,
                  message: errorText,
                )
              : null,
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: Color(0xFF583BE3),
              width: 2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF3C1F42),
        borderRadius: BorderRadius.circular(8),
        border: _passwordError != null
            ? Border.all(color: const Color(0xFFED4956), width: 1)
            : null,
      ),
      child: TextField(
        controller: _passwordController,
        obscureText: _obscurePassword,
        onChanged: (_) {
          if (_passwordError != null) {
            setState(() => _passwordError = null);
          }
        },
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          hintText: 'Your Password Here',
          hintStyle: const TextStyle(
            color: Colors.white54,
            fontSize: 16,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(12),
            child: SvgPicture.asset(
              'assets/passwordIcon.svg',
              width: 20,
              height: 20,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
          ),
          suffixIconConstraints:
              const BoxConstraints(minWidth: 0, minHeight: 0),
          suffixIcon: _passwordError != null
              ? ErrorTooltip(
                  tooltipKey: _passwordTooltipKey,
                  message: _passwordError!,
                )
              : SizedBox(
                  width: 40,
                  height: 40,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: SvgPicture.asset(
                      _obscurePassword
                          ? 'assets/closedEye.svg'
                          : 'assets/openEyeIcon.svg',
                      width: 20,
                      height: 20,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: Color(0xFF583BE3),
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}