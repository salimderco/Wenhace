import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Animated processing indicator
/// Shows rotating rings and pulsing core to indicate content is being processed
class ModernProcessingIndicator extends StatelessWidget {
  final String message; // Text message to display
  final double size; // Size of the indicator

  const ModernProcessingIndicator({
    super.key,
    this.message = 'Processing...',
    this.size = 60,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Animated processing visualization
          SizedBox(
            width: size,
            height: size,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Outer rotating ring
                Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF1E88E5).withOpacity(0.3), // Blue border
                      width: 4,
                    ),
                  ),
                )
                .animate(onPlay: (controller) => controller.repeat()) // Continuous rotation
                .rotate(duration: 2.seconds), // 2 second rotation

                // Inner pulsing core
                Container(
                  width: size * 0.6, // 60% of outer size
                  height: size * 0.6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF1E88E5), // Blue center
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF1E88E5).withOpacity(0.5), // Glow effect
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                )
                .animate(onPlay: (controller) => controller.repeat(reverse: true)) // Pulse animation
                .scale(begin: const Offset(0.8, 0.8), end: const Offset(1.2, 1.2), duration: 1.seconds),
                
                // Orbiting particles (3 small dots rotating around)
                ...List.generate(3, (index) {
                  return Positioned.fill(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF64B5F6),
                        ),
                      ),
                    )
                    .animate(onPlay: (controller) => controller.repeat())
                    .rotate(duration: 3.seconds, delay: (index * 1).seconds),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Animated pulsing text message
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          )
          .animate(onPlay: (controller) => controller.repeat(reverse: true)) // Continuous fade
          .fadeIn(duration: 800.ms, curve: Curves.easeInOut) // Fade in
          .then() // Wait
          .fadeOut(duration: 800.ms), // Fade out
        ],
      ),
    );
  }
}

