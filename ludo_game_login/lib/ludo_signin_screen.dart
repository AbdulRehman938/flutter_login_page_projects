import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
<<<<<<< HEAD
import 'auth_service.dart';
import 'ludo_login_screen.dart';
import 'validation_utils.dart';
=======
import 'ludo_login_screen.dart';
>>>>>>> 11ff43f526d279c60815de22f34273dcada4f19d

class LudoSigninScreen extends StatefulWidget {
  const LudoSigninScreen({super.key});

  @override
  State<LudoSigninScreen> createState() => _LudoSigninScreenState();
}

class _LudoSigninScreenState extends State<LudoSigninScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
<<<<<<< HEAD
  bool _isLoading = false;
  bool _obscurePassword = true;

  String? _emailError;
  String? _passwordError;

  final GlobalKey<TooltipState> _emailTooltipKey = GlobalKey<TooltipState>();
  final GlobalKey<TooltipState> _passwordTooltipKey =
      GlobalKey<TooltipState>();
=======
  bool _isButtonEnabled = false;
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateInput);
    _passwordController.addListener(_validateInput);
  }
>>>>>>> 11ff43f526d279c60815de22f34273dcada4f19d

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

<<<<<<< HEAD
  Future<void> _handleSignIn() async {
    final emailErr = ValidationUtils.validateEmail(_emailController.text);
    final passErr =
        ValidationUtils.validateSigninPassword(_passwordController.text);

    setState(() {
      _emailError = emailErr;
      _passwordError = passErr;
    });

    if (emailErr != null) {
      Future.microtask(
          () => _emailTooltipKey.currentState?.ensureTooltipVisible());
    } else if (passErr != null) {
      Future.microtask(
          () => _passwordTooltipKey.currentState?.ensureTooltipVisible());
    }

    if (emailErr != null || passErr != null) return;

    setState(() => _isLoading = true);

    if (AuthService.instance.isFirebaseInitialized) {
      try {
        await AuthService.instance.signInWithEmailPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
        if (mounted) {
          setState(() => _isLoading = false);
          showSuccessToast(context, 'Signed in successfully!');
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
          showSuccessToast(context, 'Signed in successfully!');
        }
      });
    }
=======
  void _validateInput() {
    String email = _emailController.text.trim();
    String password = _passwordController.text;

    setState(() {
      _isButtonEnabled = email.isNotEmpty && password.isNotEmpty;
    });
  }

  void _handleSignIn() {
    if (!_isButtonEnabled) return;

    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        // TODO: Navigate to next screen
        print('Sign in button pressed');
      }
    });
>>>>>>> 11ff43f526d279c60815de22f34273dcada4f19d
  }

  void _handleSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LudoLoginScreen(),
      ),
    );
  }

  void _handleHeaderSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LudoLoginScreen(),
      ),
    );
  }

  void _handleRecoverPassword() {
<<<<<<< HEAD
    showUnderDevelopmentDialog(context, 'Recover Password');
  }

  void _handleBack() {
    if (Navigator.canPop(context)) Navigator.pop(context);
=======
    print('Recover password pressed');
  }

  void _handleBack() {
    print('Back pressed');
>>>>>>> 11ff43f526d279c60815de22f34273dcada4f19d
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
                          // Right side: Search, flag, EN, Sign up button
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
                                onTap: _handleHeaderSignUp,
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
                                    'Sign up',
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
                          // Back arrow and Sign In
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
                                'Sign In',
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
<<<<<<< HEAD
                            errorText: _emailError,
                            tooltipKey: _emailTooltipKey,
                            onChanged: (_) {
                              if (_emailError != null) {
                                setState(() => _emailError = null);
                              }
                            },
=======
>>>>>>> 11ff43f526d279c60815de22f34273dcada4f19d
                          ),
                          SizedBox(height: screenHeight * 0.02),

                          // Password input
                          _buildPasswordField(),
                          SizedBox(height: screenHeight * 0.02),

                          // Forgot password
                          Row(
                            children: [
                              const Text(
                                'Forgot password? ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                              InkWell(
                                onTap: _handleRecoverPassword,
                                child: const Text(
                                  'Recover here',
                                  style: TextStyle(
                                    color: Color(0xFFFFD700),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: screenHeight * 0.04),

                          // Sign In button
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
<<<<<<< HEAD
                              onPressed: _isLoading ? null : _handleSignIn,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF583BE3),
=======
                              onPressed: _isButtonEnabled && !_isLoading
                                  ? _handleSignIn
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _isButtonEnabled
                                    ? const Color(0xFF583BE3)
                                    : const Color(0xFF3C1F42),
>>>>>>> 11ff43f526d279c60815de22f34273dcada4f19d
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
<<<<<<< HEAD
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
=======
                                        valueColor: AlwaysStoppedAnimation<Color>(
>>>>>>> 11ff43f526d279c60815de22f34273dcada4f19d
                                          Colors.white,
                                        ),
                                      ),
                                    )
                                  : const Text(
                                      'Sign In',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.04),

                          // Don't have account
                          Row(
                            children: [
                              const Text(
<<<<<<< HEAD
                                "Don't have an account? ",
=======
                                'Don\'t have an account? ',
>>>>>>> 11ff43f526d279c60815de22f34273dcada4f19d
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                              InkWell(
                                onTap: _handleSignUp,
                                child: const Text(
                                  'Sign up here',
                                  style: TextStyle(
                                    color: Color(0xFFFFD700),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: screenHeight * 0.04),

                          // Security info
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.lock,
                                color: Colors.white,
                                size: 16,
                              ),
                              SizedBox(width: screenWidth * 0.01),
                              const Text(
                                'Your info is safely secured',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
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
<<<<<<< HEAD
    String? errorText,
    GlobalKey<TooltipState>? tooltipKey,
    void Function(String)? onChanged,
=======
>>>>>>> 11ff43f526d279c60815de22f34273dcada4f19d
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF3C1F42),
        borderRadius: BorderRadius.circular(8),
<<<<<<< HEAD
        border: errorText != null
            ? Border.all(color: const Color(0xFFED4956), width: 1)
            : null,
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
=======
      ),
      child: TextField(
        controller: controller,
>>>>>>> 11ff43f526d279c60815de22f34273dcada4f19d
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
<<<<<<< HEAD
          suffixIconConstraints:
              const BoxConstraints(minWidth: 0, minHeight: 0),
          suffixIcon: errorText != null && tooltipKey != null
              ? ErrorTooltip(
                  tooltipKey: tooltipKey,
                  message: errorText,
                )
              : null,
=======
>>>>>>> 11ff43f526d279c60815de22f34273dcada4f19d
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
<<<<<<< HEAD
        border: _passwordError != null
            ? Border.all(color: const Color(0xFFED4956), width: 1)
            : null,
=======
>>>>>>> 11ff43f526d279c60815de22f34273dcada4f19d
      ),
      child: TextField(
        controller: _passwordController,
        obscureText: _obscurePassword,
<<<<<<< HEAD
        onChanged: (_) {
          if (_passwordError != null) {
            setState(() => _passwordError = null);
          }
        },
=======
>>>>>>> 11ff43f526d279c60815de22f34273dcada4f19d
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
<<<<<<< HEAD
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
=======
          suffixIcon: IconButton(
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
>>>>>>> 11ff43f526d279c60815de22f34273dcada4f19d
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