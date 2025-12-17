import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';
import 'signup_screen.dart';
import 'home_screen.dart';
import '../widgets/glass_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  
  bool _isLoading = false;
  bool _obscurePassword = true;
  
  // Typewriter effect state
  String _displayText = '';
  String _fullText = 'welcome back';
  int _currentIndex = 0;
  late final AnimationController _cursorController;

  @override
  void initState() {
    super.initState();
    _cursorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);
    // Delay typewriter start to ensure controller is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startTypewriter();
    });
  }

  void _startTypewriter() {
    Future.delayed(const Duration(milliseconds: 800), () {
      _typeNextChar();
    });
  }

  void _typeNextChar() {
    if (!mounted) return;
    
    if (_currentIndex < _fullText.length) {
      setState(() {
        _displayText = _fullText.substring(0, _currentIndex + 1);
        _currentIndex++;
      });
      Future.delayed(const Duration(milliseconds: 100), _typeNextChar);
    } else {
      // Wait before resetting
      Future.delayed(const Duration(milliseconds: 2000), () {
        if (mounted) {
          setState(() {
            _displayText = '';
            _currentIndex = 0;
          });
          Future.delayed(const Duration(milliseconds: 500), _typeNextChar);
        }
      });
    }
  }

  @override
  void dispose() {
    _cursorController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final result = await _authService.login(
      _emailController.text,
      _passwordController.text,
    );

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (result.success) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _navigateToSignup() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const SignupScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GlassScaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Lottie Animation
                  SizedBox(
                    height: 300,
                    width: 300,
                    child: Lottie.asset(
                      'assets/animations/signup_animation.json',
                      fit: BoxFit.contain,
                      repeat: true,
                      animate: true,
                      errorBuilder: (context, error, stackTrace) {
                        debugPrint('Lottie asset error: $error');
                        // Fallback to animated icon
                        return Container(
                          height: 100,
                          width: 100,
                          alignment: Alignment.center,
                          child: GlassContainer(
                            borderRadius: 50,
                            child: const Icon(
                              Icons.auto_awesome,
                              size: 50,
                              color: Colors.white,
                            ),
                          ),
                        )
                        .animate(onPlay: (controller) => controller.repeat(reverse: true))
                        .scale(
                          begin: const Offset(1.0, 1.0),
                          end: const Offset(1.1, 1.1),
                          duration: 1500.ms,
                          curve: Curves.easeInOut,
                        );
                      },
                    ),
                  )
                  .animate()
                  .scale(duration: 600.ms, curve: Curves.easeOutBack)
                  .fadeIn(duration: 600.ms),
                  
                  const SizedBox(height: 24),
                  
                  // Typewriter Welcome text
                  AnimatedBuilder(
                    animation: _cursorController,
                    builder: (context, child) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _displayText,
                            style: const TextStyle(
                              fontSize: 42,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'monospace',
                              color: Colors.white,
                              letterSpacing: 2,
                              height: 1.2,
                              shadows: [
                                Shadow(
                                  color: Colors.black26,
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          AnimatedOpacity(
                            opacity: _cursorController.value,
                            duration: const Duration(milliseconds: 100),
                            child: Container(
                              width: 3,
                              height: 42,
                              margin: const EdgeInsets.only(left: 4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(2),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.8),
                                    blurRadius: 8,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  )
                  .animate()
                  .fadeIn(delay: 200.ms)
                  .moveY(begin: 20, end: 0),
                  
                  const SizedBox(height: 8),
                  
                  const Text(
                    'Sign in to continue',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(delay: 300.ms).moveY(begin: 20, end: 0),
                  
                  const SizedBox(height: 48),
                  
                  // Email field
                  GlassTextField(
                    controller: _emailController,
                    label: 'Email',
                    hint: 'Enter your email',
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Please enter your email';
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ).animate().fadeIn(delay: 400.ms).moveX(begin: -20, end: 0),
                  
                  const SizedBox(height: 20),
                  
                  // Password field
                  GlassTextField(
                    controller: _passwordController,
                    label: 'Password',
                    hint: 'Enter your password',
                    prefixIcon: Icons.lock_outline,
                    obscureText: _obscurePassword,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _handleLogin(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        color: Colors.white70,
                      ),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Please enter your password';
                      return null;
                    },
                  ).animate().fadeIn(delay: 500.ms).moveX(begin: -20, end: 0),
                  
                  const SizedBox(height: 12),
                  
                  // Forgot password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: Colors.grey[900]?.withOpacity(0.9),
                            title: const Text('Test Credentials', style: TextStyle(color: Colors.white)),
                            content: const Text(
                              'Email: test@example.com\nPassword: password123',
                              style: TextStyle(color: Colors.white70),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('OK'),
                              ),
                            ],
                          ).animate().scale(duration: 300.ms, curve: Curves.easeOutBack),
                        );
                      },
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ).animate().fadeIn(delay: 600.ms),
                  
                  const SizedBox(height: 32),
                  
                  // Login button
                  GlassButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    text: 'Sign In',
                    isLoading: _isLoading,
                  ).animate().fadeIn(delay: 700.ms).moveY(begin: 20, end: 0),
                  
                  const SizedBox(height: 24),
                  
                  // Sign up link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: TextStyle(color: Colors.white70),
                      ),
                      TextButton(
                        onPressed: _navigateToSignup,
                        child: const Text(
                          'Create New Account',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ).animate().fadeIn(delay: 800.ms),
                  
                  const SizedBox(height: 24),
                  
                  // Test credentials hint
                  GlassContainer(
                    padding: 12,
                    child: Column(
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.info_outline, color: Colors.white, size: 16),
                            SizedBox(width: 8),
                            Text(
                              'Test Credentials',
                              style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Email: test@example.com\nPassword: password123',
                          style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.8)),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 1000.ms).moveY(begin: 20, end: 0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
