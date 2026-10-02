import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'get_started_screen.dart';
import 'validation_utils.dart';

class FacebookLoginScreen extends StatefulWidget {
  const FacebookLoginScreen({super.key});

  @override
  State<FacebookLoginScreen> createState() => _FacebookLoginScreenState();
}

class _FacebookLoginScreenState extends State<FacebookLoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final GlobalKey<TooltipState> _emailTooltipKey = GlobalKey<TooltipState>();
  final GlobalKey<TooltipState> _passwordTooltipKey = GlobalKey<TooltipState>();

  String? _emailError;
  String? _passwordError;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _validateAndLogin() async {
    final emailError = ValidationUtils.validateLoginInput(_emailController.text);
    final passwordError = ValidationUtils.validatePassword(_passwordController.text);

    setState(() {
      _emailError = emailError;
      _passwordError = passwordError;
    });

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
        await AuthService.instance.signInWithEmailPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
        if (mounted) {
          setState(() { _isLoading = false; });
          showSuccessToast(context, 'Login successful!');
        }
      } catch (e) {
        if (mounted) {
          setState(() { _isLoading = false; });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(AuthService.getReadableErrorMessage(e)),
            backgroundColor: const Color(0xFFC40000),
            behavior: SnackBarBehavior.floating,
          ));
        }
      }
    } else {
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() { _isLoading = false; });
          showSuccessToast(context, 'Login successful!');
          debugPrint('Login successful');
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
            // Language selector - centered
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Center(
                child: InkWell(
                  onTap: () => showUnderDevelopmentDialog(context, 'Language Selection'),
                  child: const Text(
                    'English (UK)',
                    style: TextStyle(
                      color: Color(0xFF65676B),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            
            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    const SizedBox(height: 120),
                    
                    // Facebook Logo
                    Image.asset(
                      'assets/images/facebookLogo.png',
                      width: 60,
                      height: 60,
                    ),
                    
                    const SizedBox(height: 120),
                    
                    // Input fields
                    Column(
                      children: [
                        _buildTextField(
                          'Mobile number or email address',
                          controller: _emailController,
                          focusNode: _emailFocusNode,
                          errorText: _emailError,
                          tooltipKey: _emailTooltipKey,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 12),
                        _buildTextField(
                          'Password',
                          controller: _passwordController,
                          focusNode: _passwordFocusNode,
                          errorText: _passwordError,
                          tooltipKey: _passwordTooltipKey,
                          obscureText: true,
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Log in button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _validateAndLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF005FD5),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
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
                                'Log in',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Forgotten password link
                    InkWell(
                      onTap: () => showUnderDevelopmentDialog(context, 'Forgotten password?'),
                      child: const Text(
                        'Forgotten password?',
                        style: TextStyle(
                          color: Color(0xFF005FD5),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Divider
                    Row(
                      children: [
                        const Expanded(
                          child: Divider(
                            color: Color(0xFFE4E6EB),
                            thickness: 1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            'OR',
                            style: TextStyle(
                              color: const Color(0xFF65676B),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const Expanded(
                          child: Divider(
                            color: Color(0xFFE4E6EB),
                            thickness: 1,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Create new account button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const GetStartedScreen(),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF005FD5),
                          side: const BorderSide(
                            color: Color(0xFF005FD5),
                            width: 1,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Create new account',
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
            
            // Footer
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Column(
                children: [
                  // Meta Logo
                  Image.asset(
                    'assets/images/metaLogo.png',
                    width: 80,
                    height: 20,
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Footer links
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildFooterLink(context, 'About'),
                      const SizedBox(width: 16),
                      _buildFooterLink(context, 'Help'),
                      const SizedBox(width: 16),
                      _buildFooterLink(context, 'More'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String placeholder, {
    TextEditingController? controller,
    FocusNode? focusNode,
    String? errorText,
    GlobalKey<TooltipState>? tooltipKey,
    bool obscureText = false,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(
        color: Color(0xFF1C1E21),
        fontSize: 16,
      ),
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
                tooltipKey: tooltipKey,
                message: errorText,
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: errorText != null ? const Color(0xFFC40000) : const Color(0xFFDADDE1),
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
      onChanged: (value) {
        if (placeholder.contains('Mobile number') && _emailError != null) {
          setState(() {
            _emailError = ValidationUtils.validateLoginInput(value);
          });
        } else if (placeholder.contains('Password') && _passwordError != null) {
          setState(() {
            _passwordError = ValidationUtils.validatePassword(value);
          });
        }
      },
    );
  }

  Widget _buildFooterLink(BuildContext context, String text) {
    return InkWell(
      onTap: () {
        showUnderDevelopmentDialog(context, text);
      },
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF65676B),
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
