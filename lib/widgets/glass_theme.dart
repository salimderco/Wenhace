import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Decorative floating orb widget for background
/// Creates gradient circles that float on the background
class FloatingOrb extends StatelessWidget {
  final double size; // Size of the orb
  final Alignment alignment; // Position on screen
  final List<Color> colors; // Gradient colors
  final double opacity; // Transparency level

  const FloatingOrb({
    super.key,
    required this.size,
    required this.alignment,
    required this.colors,
    this.opacity = 0.6,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: colors.map((c) => c.withOpacity(opacity)).toList(),
          ),
        ),
      ),
    );
  }
}

/// Main scaffold with glassmorphism background
/// Provides dark gradient background with floating orbs and blur effects
class GlassScaffold extends StatelessWidget {
  final Widget body; // Main content widget
  final PreferredSizeWidget? appBar; // Optional app bar
  final Widget? floatingActionButton; // Optional FAB
  final Widget? bottomNavigationBar; // Optional bottom nav
  final String? backgroundImage; // Optional background image path
  final bool useOrbsBackground; // Whether to show floating orbs

  const GlassScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.backgroundImage,
    this.useOrbsBackground = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Background image (if provided)
          if (backgroundImage != null)
            Positioned.fill(
              child: Image.asset(
                backgroundImage!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback to gradient if image fails to load
                  return Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF1a1a2e),
                          Color(0xFF16213e),
                          Color(0xFF0f0f1e),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          else
          // Base dark gradient background (fallback if no image)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1a1a2e), // Lighter navy blue
                  Color(0xFF16213e), // Deep blue
                  Color(0xFF0f0f1e), // Dark background
                ],
              ),
            ),
          ),
          
          // Decorative floating orbs (only if useOrbsBackground is true)
          // Creates visual depth and interest
          if (useOrbsBackground) ...[
            const FloatingOrb(
              size: 300,
              alignment: Alignment(-1.2, -0.8),
              colors: [Color(0xFFCC5500), Color(0xFFFF8844)],
              opacity: 0.25,
            ),
            
            const FloatingOrb(
              size: 250,
              alignment: Alignment(1.3, -0.5),
              colors: [Color(0xFFCC5500), Color(0xFFFFAA66)],
              opacity: 0.20,
            ),
            
            const FloatingOrb(
              size: 200,
              alignment: Alignment(-0.8, 1.2),
              colors: [Color(0xFFFF8844), Color(0xFFFFCC99)],
              opacity: 0.22,
            ),
            
            const FloatingOrb(
              size: 280,
              alignment: Alignment(1.1, 1.0),
              colors: [Color(0xFFFF9955), Color(0xFFCC5500)],
              opacity: 0.25,
            ),
            
            const FloatingOrb(
              size: 150,
              alignment: Alignment(0.0, -0.3),
              colors: [Color(0xFFCC5500), Color(0xFF993300)],
              opacity: 0.15,
            ),
            
            const FloatingOrb(
              size: 100,
              alignment: Alignment(1.0, 0.2),
              colors: [Color(0xFFFFAA66), Color(0xFFFF8844)],
              opacity: 0.18,
            ),
          ],
          
          // Blur layer for glassmorphism effect
          // Creates the frosted glass look by blurring background
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40), // Blur intensity
            child: Container(color: Colors.transparent),
          ),

          // Dark overlay for contrast
          // Ensures text remains readable over background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.25), // Top overlay
                  Colors.black.withOpacity(0.35), // Middle overlay
                  Colors.black.withOpacity(0.25), // Bottom overlay
                ],
              ),
            ),
          ),

          // Main content (wrapped in SafeArea for notch/padding)
          SafeArea(child: body),
        ],
      ),
    );
  }
}

/// Frosted glass container widget
/// Creates glassmorphism effect with blur and semi-transparent background
class GlassContainer extends StatelessWidget {
  final Widget child; // Content inside container
  final double padding; // Internal padding
  final double borderRadius; // Corner radius
  final double opacity; // Background opacity
  final Gradient? borderGradient; // Optional gradient border

  const GlassContainer({
    super.key,
    required this.child,
    this.padding = 20.0,
    this.borderRadius = 28.0,
    this.opacity = 0.12,
    this.borderGradient,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
        child: Container(
          padding: EdgeInsets.all(padding),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(opacity + 0.08),
                Colors.white.withOpacity(opacity),
              ],
            ),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 8),
                spreadRadius: 0,
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

/// Glassmorphism button with gradient background
/// Orange gradient button with glass effect and loading state
class GlassButton extends StatelessWidget {
  final VoidCallback? onPressed; // Button tap handler
  final String text; // Button label
  final IconData? icon; // Optional icon
  final bool isLoading; // Shows loading spinner when true
  final Gradient? gradient; // Optional custom gradient

  const GlassButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.icon,
    this.isLoading = false,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: gradient ?? 
          const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFFCC5500),
              Color(0xFFFF8844),
            ],
          ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFCC5500).withOpacity(0.12),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              shadowColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32),
              ),
            ),
            child: isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (icon != null) ...[
                        Icon(icon, size: 24),
                        const SizedBox(width: 12),
                      ],
                      Text(
                        text,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

/// Glassmorphism text input field
/// Styled text field with glass effect, validation, and icons
class GlassTextField extends StatelessWidget {
  final TextEditingController controller; // Text controller
  final String label; // Field label
  final String hint; // Placeholder text
  final IconData? prefixIcon; // Left icon
  final Widget? suffixIcon; // Right widget (e.g., password toggle)
  final bool obscureText; // Hide text (for passwords)
  final TextInputType keyboardType; // Keyboard type (email, number, etc.)
  final int maxLines; // Maximum lines (1 for single, >1 for multiline)
  final String? Function(String?)? validator; // Input validation function
  final TextInputAction? textInputAction; // Keyboard action button
  final Function(String)? onFieldSubmitted; // Called when user submits

  const GlassTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint = '',
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.validator,
    this.textInputAction,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 15,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.08),
                    Colors.white.withOpacity(0.04),
                  ],
                ),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: TextFormField(
                  controller: controller,
                  obscureText: obscureText,
                  keyboardType: keyboardType,
                  maxLines: maxLines,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  textInputAction: textInputAction,
                  onFieldSubmitted: onFieldSubmitted,
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.4),
                      fontWeight: FontWeight.w400,
                    ),
                    prefixIcon: prefixIcon != null
                        ? Icon(prefixIcon, color: Colors.white.withOpacity(0.7), size: 22)
                        : null,
                    suffixIcon: suffixIcon,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 20,
                    ),
                    errorStyle: const TextStyle(
                      color: Color(0xFFFF8A80),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  validator: validator,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Glassmorphism app bar
/// Transparent app bar with blur effect and gradient background
class GlassAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title; // App bar title
  final List<Widget>? actions; // Right-side action buttons
  final Widget? leading; // Left-side widget (usually back button)

  const GlassAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white.withOpacity(0.15),
                Colors.white.withOpacity(0.05),
              ],
            ),
            border: Border(
              bottom: BorderSide(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
            ),
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: leading,
            centerTitle: true,
            title: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 18,
                letterSpacing: 0.5,
              ),
            ),
            actions: actions,
            iconTheme: const IconThemeData(color: Colors.white, size: 24),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
