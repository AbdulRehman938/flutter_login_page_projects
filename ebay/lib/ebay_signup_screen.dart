import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'auth_service.dart';
import 'validation_utils.dart';

class EbaySignupScreen extends StatefulWidget {
  const EbaySignupScreen({super.key});

  @override
  State<EbaySignupScreen> createState() => _EbaySignupScreenState();
}

class _EbaySignupScreenState extends State<EbaySignupScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _firstNameFocusNode = FocusNode();
  final FocusNode _lastNameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  final GlobalKey<TooltipState> _firstNameTooltipKey = GlobalKey<TooltipState>();
  final GlobalKey<TooltipState> _lastNameTooltipKey = GlobalKey<TooltipState>();
  final GlobalKey<TooltipState> _emailTooltipKey = GlobalKey<TooltipState>();
  final GlobalKey<TooltipState> _passwordTooltipKey = GlobalKey<TooltipState>();

  String? _firstNameError;
  String? _lastNameError;
  String? _emailError;
  String? _passwordError;

  bool _hasSubmitted = false;
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _firstNameController.addListener(_onTextChanged);
    _lastNameController.addListener(_onTextChanged);
    _emailController.addListener(_onTextChanged);
    _passwordController.addListener(_onTextChanged);

    _firstNameFocusNode.addListener(() => _handleFocusChanged(
      _firstNameFocusNode,
      () => ValidationUtils.validateFirstName(_firstNameController.text),
      (e) => setState(() => _firstNameError = e),
      _firstNameTooltipKey,
      _firstNameController,
    ));

    _lastNameFocusNode.addListener(() => _handleFocusChanged(
      _lastNameFocusNode,
      () => ValidationUtils.validateLastName(_lastNameController.text),
      (e) => setState(() => _lastNameError = e),
      _lastNameTooltipKey,
      _lastNameController,
    ));

    _emailFocusNode.addListener(() => _handleFocusChanged(
      _emailFocusNode,
      () => ValidationUtils.validateEmail(_emailController.text),
      (e) => setState(() => _emailError = e),
      _emailTooltipKey,
      _emailController,
    ));

    _passwordFocusNode.addListener(() => _handleFocusChanged(
      _passwordFocusNode,
      () => ValidationUtils.validatePassword(_passwordController.text),
      (e) => setState(() => _passwordError = e),
      _passwordTooltipKey,
      _passwordController,
    ));
  }

  @override
  void dispose() {
    _firstNameController.removeListener(_onTextChanged);
    _lastNameController.removeListener(_onTextChanged);
    _emailController.removeListener(_onTextChanged);
    _passwordController.removeListener(_onTextChanged);

    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();

    _firstNameFocusNode.dispose();
    _lastNameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();

    super.dispose();
  }

  void _handleFocusChanged(
    FocusNode node,
    String? Function() validator,
    void Function(String?) updateError,
    GlobalKey<TooltipState> tooltipKey,
    TextEditingController controller,
  ) {
    if (!node.hasFocus && controller.text.isNotEmpty) {
      final error = validator();
      updateError(error);
      if (error != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          tooltipKey.currentState?.ensureTooltipVisible();
        });
      }
    }
  }

  void _onTextChanged() {
    if (_hasSubmitted) {
      setState(() {
        _firstNameError = ValidationUtils.validateFirstName(_firstNameController.text);
        _lastNameError = ValidationUtils.validateLastName(_lastNameController.text);
        _emailError = ValidationUtils.validateEmail(_emailController.text);
        _passwordError = ValidationUtils.validatePassword(_passwordController.text);
      });
    } else {
      if (_firstNameError != null && ValidationUtils.validateFirstName(_firstNameController.text) == null) {
        setState(() => _firstNameError = null);
      }
      if (_lastNameError != null && ValidationUtils.validateLastName(_lastNameController.text) == null) {
        setState(() => _lastNameError = null);
      }
      if (_emailError != null && ValidationUtils.validateEmail(_emailController.text) == null) {
        setState(() => _emailError = null);
      }
      if (_passwordError != null && ValidationUtils.validatePassword(_passwordController.text) == null) {
        setState(() => _passwordError = null);
      }
    }
  }

  Future<void> _handleCreateAccount() async {
    _hasSubmitted = true;
    final firstNameError = ValidationUtils.validateFirstName(_firstNameController.text);
    final lastNameError = ValidationUtils.validateLastName(_lastNameController.text);
    final emailError = ValidationUtils.validateEmail(_emailController.text);
    final passwordError = ValidationUtils.validatePassword(_passwordController.text);

    setState(() {
      _firstNameError = firstNameError;
      _lastNameError = lastNameError;
      _emailError = emailError;
      _passwordError = passwordError;
    });

    if (firstNameError != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _firstNameTooltipKey.currentState?.ensureTooltipVisible();
      });
      return;
    }
    if (lastNameError != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _lastNameTooltipKey.currentState?.ensureTooltipVisible();
      });
      return;
    }
    if (emailError != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _emailTooltipKey.currentState?.ensureTooltipVisible();
      });
      return;
    }
    if (passwordError != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _passwordTooltipKey.currentState?.ensureTooltipVisible();
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    if (AuthService.instance.isFirebaseInitialized) {
      try {
        final fullName = '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}'.trim();
        await AuthService.instance.registerWithEmailPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          displayName: fullName,
        );
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          showSuccessToast(context, 'Account created successfully!');
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
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
          setState(() {
            _isLoading = false;
          });
          showSuccessToast(context, 'Account created successfully!');
          debugPrint('Account created successfully');
        }
      });
    }
  }

  void _handleSocialSignup(String provider) {
    showUnderDevelopmentDialog(context, 'Sign up with $provider');
  }

  void _handleBusinessAccount() {
    showUnderDevelopmentDialog(context, 'Create a business account');
  }

  void _handleSignIn() {
    Navigator.pop(context);
  }

  Widget _buildValidatedTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String hintText,
    required String? error,
    required GlobalKey<TooltipState> tooltipKey,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      style: const TextStyle(
        color: Color(0xFF191927),
        fontSize: 16,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Color(0xFF767676),
          fontSize: 16,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        suffixIconConstraints: const BoxConstraints(
          minWidth: 40,
          minHeight: 48,
          maxWidth: 48,
          maxHeight: 48,
        ),
        suffixIcon: error != null
            ? EbayErrorTooltip(
                tooltipKey: tooltipKey,
                message: error,
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: error != null ? const Color(0xFFC40000) : const Color(0xFFD3D3D3),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: error != null ? const Color(0xFFC40000) : const Color(0xFFD3D3D3),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: error != null ? const Color(0xFFC40000) : const Color(0xFF0964EC),
            width: 2,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.08,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: screenHeight * 0.02),

                      // Header with logo and sign in link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SvgPicture.asset(
                            'assets/ebayLogo.svg',
                            width: screenWidth * 0.2,
                          ),
                          TextButton(
                            onPressed: _handleSignIn,
                            child: const Text(
                              'Sign in',
                              style: TextStyle(
                                color: Color(0xFF0964EC),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.04),

                      // Create an account heading
                      const Text(
                        'Create an account',
                        style: TextStyle(
                          color: Color(0xFF191927),
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),

                      // Business account section
                      Row(
                        children: [
                          const Text(
                            'Are you a business or nonprofit?',
                            style: TextStyle(
                              color: Color(0xFF191927),
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 4),
                          TextButton(
                            onPressed: _handleBusinessAccount,
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text(
                              'Create a business account',
                              style: TextStyle(
                                color: Color(0xFF0964EC),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.03),

                      // Continue with section
                      const Text(
                        'Continue with:',
                        style: TextStyle(
                          color: Color(0xFF191927),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      // Social signup buttons
                      Row(
                        children: [
                          _buildCircularSocialButton(
                            'assets/googleLogo.png',
                            () => _handleSocialSignup('Google'),
                          ),
                          SizedBox(width: screenWidth * 0.04),
                          _buildCircularSocialButton(
                            'assets/appleLogo.png',
                            () => _handleSocialSignup('Apple'),
                          ),
                          SizedBox(width: screenWidth * 0.04),
                          _buildCircularSocialButton(
                            'assets/facebookLogo.png',
                            () => _handleSocialSignup('Facebook'),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.03),

                      // OR separator
                      Row(
                        children: [
                          const Expanded(
                            child: Divider(
                              color: Color(0xFFD3D3D3),
                              thickness: 1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'or',
                              style: TextStyle(
                                color: const Color(0xFF191927).withValues(alpha: 0.6),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const Expanded(
                            child: Divider(
                              color: Color(0xFFD3D3D3),
                              thickness: 1,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.03),

                      // First name input
                      _buildValidatedTextField(
                        controller: _firstNameController,
                        focusNode: _firstNameFocusNode,
                        hintText: 'First name',
                        error: _firstNameError,
                        tooltipKey: _firstNameTooltipKey,
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      // Last name input
                      _buildValidatedTextField(
                        controller: _lastNameController,
                        focusNode: _lastNameFocusNode,
                        hintText: 'Last name',
                        error: _lastNameError,
                        tooltipKey: _lastNameTooltipKey,
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      // Email input
                      _buildValidatedTextField(
                        controller: _emailController,
                        focusNode: _emailFocusNode,
                        hintText: 'Email',
                        error: _emailError,
                        tooltipKey: _emailTooltipKey,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      // Password input with show/hide and error tooltip
                      TextField(
                        controller: _passwordController,
                        focusNode: _passwordFocusNode,
                        obscureText: _obscurePassword,
                        style: const TextStyle(
                          color: Color(0xFF191927),
                          fontSize: 16,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Password',
                          hintStyle: const TextStyle(
                            color: Color(0xFF767676),
                            fontSize: 16,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          suffixIconConstraints: const BoxConstraints(
                            minWidth: 48,
                            minHeight: 48,
                            maxHeight: 48,
                          ),
                          suffixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (_passwordError != null)
                                EbayErrorTooltip(
                                  tooltipKey: _passwordTooltipKey,
                                  message: _passwordError!,
                                ),
                              IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: const Color(0xFF767676),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ],
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: _passwordError != null ? const Color(0xFFC40000) : const Color(0xFFD3D3D3),
                              width: 1,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: _passwordError != null ? const Color(0xFFC40000) : const Color(0xFFD3D3D3),
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: _passwordError != null ? const Color(0xFFC40000) : const Color(0xFF0964EC),
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),

                      // Legal disclaimer with clickable dialog links
                      Wrap(
                        children: [
                          const Text(
                            'By Creating an account, you agree to our ',
                            style: TextStyle(
                              color: Color(0xFF191927),
                              fontSize: 12,
                            ),
                          ),
                          InkWell(
                            onTap: () => showUnderDevelopmentDialog(context, 'User Agreement'),
                            child: const Text(
                              'User Agreement',
                              style: TextStyle(
                                color: Color(0xFF0964EC),
                                fontSize: 12,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          const Text(
                            ' and acknowledge reading our ',
                            style: TextStyle(
                              color: Color(0xFF191927),
                              fontSize: 12,
                            ),
                          ),
                          InkWell(
                            onTap: () => showUnderDevelopmentDialog(context, 'User Privacy Notice'),
                            child: const Text(
                              'User Privacy Notice.',
                              style: TextStyle(
                                color: Color(0xFF0964EC),
                                fontSize: 12,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.03),

                      // Create account button
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: !_isLoading ? _handleCreateAccount : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0964EC),
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
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : const Text(
                                  'Create account',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.04),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCircularSocialButton(String iconPath, VoidCallback onPressed) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFFD3D3D3),
          width: 1,
        ),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Image.asset(
          iconPath,
          width: 20,
          height: 20,
        ),
      ),
    );
  }
}