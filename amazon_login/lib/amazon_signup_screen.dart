import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'auth_service.dart';
import 'validation_utils.dart';

class AmazonSignupScreen extends StatefulWidget {
  const AmazonSignupScreen({super.key});

  @override
  State<AmazonSignupScreen> createState() => _AmazonSignupScreenState();
}

class _AmazonSignupScreenState extends State<AmazonSignupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  final GlobalKey<TooltipState> _nameTooltipKey = GlobalKey<TooltipState>();
  final GlobalKey<TooltipState> _emailTooltipKey = GlobalKey<TooltipState>();
  final GlobalKey<TooltipState> _passwordTooltipKey = GlobalKey<TooltipState>();
  final GlobalKey<TooltipState> _confirmPasswordTooltipKey = GlobalKey<TooltipState>();

  String? _nameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;

  bool _hasSubmitted = false;
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_onTextChanged);
    _emailController.addListener(_onTextChanged);
    _passwordController.addListener(_onTextChanged);
    _confirmPasswordController.addListener(_onTextChanged);

    _nameFocusNode.addListener(() => _handleFocusChanged(
      _nameFocusNode,
      () => ValidationUtils.validateName(_nameController.text),
      (e) => setState(() => _nameError = e),
      _nameTooltipKey,
      _nameController,
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

    _confirmPasswordFocusNode.addListener(() => _handleFocusChanged(
      _confirmPasswordFocusNode,
      () => ValidationUtils.validateConfirmPassword(
        _confirmPasswordController.text,
        _passwordController.text,
      ),
      (e) => setState(() => _confirmPasswordError = e),
      _confirmPasswordTooltipKey,
      _confirmPasswordController,
    ));
  }

  @override
  void dispose() {
    _nameController.removeListener(_onTextChanged);
    _emailController.removeListener(_onTextChanged);
    _passwordController.removeListener(_onTextChanged);
    _confirmPasswordController.removeListener(_onTextChanged);

    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();

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
        _nameError = ValidationUtils.validateName(_nameController.text);
        _emailError = ValidationUtils.validateEmail(_emailController.text);
        _passwordError = ValidationUtils.validatePassword(_passwordController.text);
        _confirmPasswordError = ValidationUtils.validateConfirmPassword(
          _confirmPasswordController.text,
          _passwordController.text,
        );
      });
    } else {
      if (_nameError != null && ValidationUtils.validateName(_nameController.text) == null) {
        setState(() => _nameError = null);
      }
      if (_emailError != null && ValidationUtils.validateEmail(_emailController.text) == null) {
        setState(() => _emailError = null);
      }
      if (_passwordError != null && ValidationUtils.validatePassword(_passwordController.text) == null) {
        setState(() => _passwordError = null);
      }
      if (_confirmPasswordError != null &&
          ValidationUtils.validateConfirmPassword(
            _confirmPasswordController.text,
            _passwordController.text,
          ) == null) {
        setState(() => _confirmPasswordError = null);
      }
    }
  }

  Future<void> _handleCreateAccount() async {
    _hasSubmitted = true;
    final nameError = ValidationUtils.validateName(_nameController.text);
    final emailError = ValidationUtils.validateEmail(_emailController.text);
    final passwordError = ValidationUtils.validatePassword(_passwordController.text);
    final confirmPasswordError = ValidationUtils.validateConfirmPassword(
      _confirmPasswordController.text,
      _passwordController.text,
    );

    setState(() {
      _nameError = nameError;
      _emailError = emailError;
      _passwordError = passwordError;
      _confirmPasswordError = confirmPasswordError;
    });

    if (nameError != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _nameTooltipKey.currentState?.ensureTooltipVisible();
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
    if (confirmPasswordError != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _confirmPasswordTooltipKey.currentState?.ensureTooltipVisible();
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    if (AuthService.instance.isFirebaseInitialized) {
      try {
        await AuthService.instance.registerWithEmailPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          displayName: _nameController.text.trim(),
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

  void _handleSignIn() {
    Navigator.pop(context);
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
                    horizontal: screenWidth * 0.06,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: screenHeight * 0.02),

                      // Amazon Logo
                      SvgPicture.asset(
                        'assets/amazon_logo.svg',
                        width: screenWidth * 0.3,
                      ),
                      SizedBox(height: screenHeight * 0.03),

                      // Create account heading
                      const Text(
                        'Create account',
                        style: TextStyle(
                          color: Color(0xFF000000),
                          fontSize: 28,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      // Your name input label
                      const Text(
                        'Your name',
                        style: TextStyle(
                          color: Color(0xFF000000),
                          fontSize: 13,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),

                      // Your name input field
                      TextField(
                        controller: _nameController,
                        focusNode: _nameFocusNode,
                        style: const TextStyle(
                          color: Color(0xFF000000),
                          fontSize: 16,
                        ),
                        decoration: InputDecoration(
                          hintText: '',
                          hintStyle: const TextStyle(
                            color: Color(0xFF767676),
                            fontSize: 16,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                          suffixIconConstraints: const BoxConstraints(
                            minWidth: 40,
                            minHeight: 48,
                            maxWidth: 48,
                            maxHeight: 48,
                          ),
                          suffixIcon: _nameError != null
                              ? AmazonErrorTooltip(
                                  tooltipKey: _nameTooltipKey,
                                  message: _nameError!,
                                )
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0),
                            borderSide: BorderSide(
                              color: _nameError != null
                                  ? const Color(0xFFC40000)
                                  : const Color(0xFF888888),
                              width: 1,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0),
                            borderSide: BorderSide(
                              color: _nameError != null
                                  ? const Color(0xFFC40000)
                                  : const Color(0xFF888888),
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0),
                            borderSide: BorderSide(
                              color: _nameError != null
                                  ? const Color(0xFFC40000)
                                  : const Color(0xFFFF9900),
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      // Email input label
                      const Text(
                        'Email',
                        style: TextStyle(
                          color: Color(0xFF000000),
                          fontSize: 13,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),

                      // Email input field
                      TextField(
                        controller: _emailController,
                        focusNode: _emailFocusNode,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(
                          color: Color(0xFF000000),
                          fontSize: 16,
                        ),
                        decoration: InputDecoration(
                          hintText: '',
                          hintStyle: const TextStyle(
                            color: Color(0xFF767676),
                            fontSize: 16,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                          suffixIconConstraints: const BoxConstraints(
                            minWidth: 40,
                            minHeight: 48,
                            maxWidth: 48,
                            maxHeight: 48,
                          ),
                          suffixIcon: _emailError != null
                              ? AmazonErrorTooltip(
                                  tooltipKey: _emailTooltipKey,
                                  message: _emailError!,
                                )
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0),
                            borderSide: BorderSide(
                              color: _emailError != null
                                  ? const Color(0xFFC40000)
                                  : const Color(0xFF888888),
                              width: 1,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0),
                            borderSide: BorderSide(
                              color: _emailError != null
                                  ? const Color(0xFFC40000)
                                  : const Color(0xFF888888),
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0),
                            borderSide: BorderSide(
                              color: _emailError != null
                                  ? const Color(0xFFC40000)
                                  : const Color(0xFFFF9900),
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      // Password input label
                      const Text(
                        'Password',
                        style: TextStyle(
                          color: Color(0xFF000000),
                          fontSize: 13,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),

                      // Password input field with show/hide and error tooltip
                      TextField(
                        controller: _passwordController,
                        focusNode: _passwordFocusNode,
                        obscureText: _obscurePassword,
                        style: const TextStyle(
                          color: Color(0xFF000000),
                          fontSize: 16,
                        ),
                        decoration: InputDecoration(
                          hintText: 'At least 6 characters',
                          hintStyle: const TextStyle(
                            color: Color(0xFF767676),
                            fontSize: 16,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
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
                                AmazonErrorTooltip(
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
                            borderRadius: BorderRadius.circular(0),
                            borderSide: BorderSide(
                              color: _passwordError != null
                                  ? const Color(0xFFC40000)
                                  : const Color(0xFF888888),
                              width: 1,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0),
                            borderSide: BorderSide(
                              color: _passwordError != null
                                  ? const Color(0xFFC40000)
                                  : const Color(0xFF888888),
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0),
                            borderSide: BorderSide(
                              color: _passwordError != null
                                  ? const Color(0xFFC40000)
                                  : const Color(0xFFFF9900),
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      // Re-enter password input label
                      const Text(
                        'Re-enter password',
                        style: TextStyle(
                          color: Color(0xFF000000),
                          fontSize: 13,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),

                      // Re-enter password input field with show/hide and error tooltip
                      TextField(
                        controller: _confirmPasswordController,
                        focusNode: _confirmPasswordFocusNode,
                        obscureText: _obscureConfirmPassword,
                        style: const TextStyle(
                          color: Color(0xFF000000),
                          fontSize: 16,
                        ),
                        decoration: InputDecoration(
                          hintText: '',
                          hintStyle: const TextStyle(
                            color: Color(0xFF767676),
                            fontSize: 16,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                          suffixIconConstraints: const BoxConstraints(
                            minWidth: 48,
                            minHeight: 48,
                            maxHeight: 48,
                          ),
                          suffixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (_confirmPasswordError != null)
                                AmazonErrorTooltip(
                                  tooltipKey: _confirmPasswordTooltipKey,
                                  message: _confirmPasswordError!,
                                ),
                              IconButton(
                                icon: Icon(
                                  _obscureConfirmPassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: const Color(0xFF767676),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureConfirmPassword = !_obscureConfirmPassword;
                                  });
                                },
                              ),
                            ],
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0),
                            borderSide: BorderSide(
                              color: _confirmPasswordError != null
                                  ? const Color(0xFFC40000)
                                  : const Color(0xFF888888),
                              width: 1,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0),
                            borderSide: BorderSide(
                              color: _confirmPasswordError != null
                                  ? const Color(0xFFC40000)
                                  : const Color(0xFF888888),
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0),
                            borderSide: BorderSide(
                              color: _confirmPasswordError != null
                                  ? const Color(0xFFC40000)
                                  : const Color(0xFFFF9900),
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      // Legal disclaimer
                      Wrap(
                        children: [
                          const Text(
                            'By creating an account, you agree to Amazon\'s ',
                            style: TextStyle(
                              color: Color(0xFF000000),
                              fontSize: 11,
                            ),
                          ),
                          InkWell(
                            onTap: () => showUnderDevelopmentDialog(context, 'Conditions of Use'),
                            child: const Text(
                              'Conditions of Use',
                              style: TextStyle(
                                color: Color(0xFF0066C0),
                                fontSize: 11,
                              ),
                            ),
                          ),
                          const Text(
                            ' and ',
                            style: TextStyle(
                              color: Color(0xFF000000),
                              fontSize: 11,
                            ),
                          ),
                          InkWell(
                            onTap: () => showUnderDevelopmentDialog(context, 'Privacy Notice'),
                            child: const Text(
                              'Privacy Notice',
                              style: TextStyle(
                                color: Color(0xFF0066C0),
                                fontSize: 11,
                              ),
                            ),
                          ),
                          const Text(
                            '.',
                            style: TextStyle(
                              color: Color(0xFF000000),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      // Create account button
                      SizedBox(
                        width: double.infinity,
                        height: 32,
                        child: ElevatedButton(
                          onPressed: !_isLoading ? _handleCreateAccount : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF0C14B),
                            foregroundColor: Colors.black,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.black,
                                    ),
                                  ),
                                )
                              : const Text(
                                  'Create your Amazon account',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.04),

                      // Already have account section
                      Row(
                        children: [
                          const Text(
                            'Already have an account? ',
                            style: TextStyle(
                              color: Color(0xFF000000),
                              fontSize: 13,
                            ),
                          ),
                          InkWell(
                            onTap: _handleSignIn,
                            child: const Text(
                              'Sign in',
                              style: TextStyle(
                                color: Color(0xFF0066C0),
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.04),

                      // Footer with legal links
                      _buildFooter(screenWidth),
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

  Widget _buildFooter(double screenWidth) {
    return Column(
      children: [
        const Divider(color: Color(0xFFDDDDDD)),
        SizedBox(height: screenWidth * 0.02),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: screenWidth * 0.02,
          runSpacing: screenWidth * 0.01,
          children: [
            _buildFooterLink('Conditions of Use'),
            _buildFooterLink('Privacy Notice'),
            _buildFooterLink('Help'),
          ],
        ),
        SizedBox(height: screenWidth * 0.02),
        const Text(
          '© 1996-2024, Amazon.com, Inc. or its affiliates',
          style: TextStyle(
            color: Color(0xFF000000),
            fontSize: 11,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: screenWidth * 0.03),
      ],
    );
  }

  Widget _buildFooterLink(String text) {
    return InkWell(
      onTap: () {
        showUnderDevelopmentDialog(context, text);
      },
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF0066C0),
          fontSize: 11,
        ),
      ),
    );
  }
}