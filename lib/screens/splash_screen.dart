import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../widgets/glass_theme.dart';
import 'login_screen.dart';
import 'home_screen.dart';
import '../services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _controller.forward();

    // Navigate after animation
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => AuthService().isAuthenticated
                ? const HomeScreen()
                : const LoginScreen(),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GlassScaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated Logo Container
            Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFCC5500),
                    Color(0xFFFF8844),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFCC5500).withOpacity(0.18),
                    blurRadius: 24,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.auto_awesome,
                  size: 80,
                  color: Colors.white,
                ),
              ),
            )
                .animate()
                .scale(
                  duration: 600.ms,
                  curve: Curves.elasticOut,
                )
                .fadeIn(duration: 400.ms)
                .then() // Start continuous animations after initial appearance
                .animate(onPlay: (controller) => controller.repeat(reverse: true))
                .shimmer(
                  duration: 2000.ms,
                  color: Colors.white.withOpacity(0.3),
                )
                .animate(onPlay: (controller) => controller.repeat(reverse: true))
                .scale(
                  begin: const Offset(1.0, 1.0),
                  end: const Offset(1.05, 1.05),
                  duration: 1500.ms,
                  curve: Curves.easeInOut,
                ),
            
            const SizedBox(height: 40),
            
            // App Name
            const Text(
              'E-Reputation',
              style: TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 1,
              ),
            )
                .animate(delay: 300.ms)
                .fadeIn(duration: 600.ms)
                .slideY(begin: 0.3, end: 0)
                .then() // Start continuous shimmer effect
                .shimmer(
                  duration: 2500.ms,
                  color: const Color(0xFFFF8844).withOpacity(0.5),
                ),
            
            const SizedBox(height: 8),
            
            // Subtitle
            Text(
              'Enhancer',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w300,
                color: Colors.white.withOpacity(0.8),
                letterSpacing: 2,
              ),
            )
                .animate(delay: 500.ms)
                .fadeIn(duration: 600.ms)
                .slideY(begin: 0.3, end: 0),
            
            const SizedBox(height: 60),
            
            // Loading indicator
            SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.white.withOpacity(0.5),
                ),
                strokeWidth: 3,
              ),
            )
                .animate(delay: 800.ms)
                .fadeIn(duration: 400.ms)
                .animate(onPlay: (controller) => controller.repeat())
                .rotate(duration: 2000.ms),
          ],
        ),
      ),
    );
  }
}

