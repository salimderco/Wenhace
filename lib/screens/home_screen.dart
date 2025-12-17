import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/auth_service.dart';
import '../services/api_service.dart';
import 'api_key_setup_screen.dart';
import 'content_input_screen.dart';
import 'login_screen.dart';
import '../widgets/glass_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _handleLogout(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Logout'),
          ),
        ],
      ).animate().scale(duration: 300.ms, curve: Curves.easeOutBack),
    );

    if (shouldLogout == true && context.mounted) {
      await AuthService().logout();
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final userName = authService.currentUserName ?? 'User';

    return GlassScaffold(
      appBar: GlassAppBar(
        title: 'Hi, $userName',
        actions: [
          // API Key Setup button
          IconButton(
            icon: const Icon(Icons.vpn_key, color: Colors.white),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ApiKeySetupScreen(),
                ),
              );
            },
            tooltip: 'API Key Setup',
          ).animate().fadeIn(delay: 500.ms),
          // Logout button
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () => _handleLogout(context),
            tooltip: 'Logout',
          ).animate().fadeIn(delay: 600.ms),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'E-Reputation Enhancer',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
              ).animate().fadeIn(delay: 200.ms).moveY(begin: 20, end: 0),
              const SizedBox(height: 8),
              Text(
                'Enhance your corporate content with AI-powered semantic enrichment and intelligent ranking',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white70,
                    ),
              ).animate().fadeIn(delay: 300.ms).moveY(begin: 20, end: 0),
              const SizedBox(height: 40),

              // Hero Card
              GlassContainer(
                padding: 24,
                opacity: 0.22,
                borderRadius: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.auto_awesome,
                      color: Colors.white,
                      size: 40,
                    ).animate(onPlay: (c) => c.repeat(reverse: true))
                    .scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1), duration: 2.seconds),
                    const SizedBox(height: 16),
                    const Text(
                      'Transform Your Content',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Use advanced NLP and AI techniques to optimize your digital presence',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 24),
                    GlassButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ContentInputScreen(),
                          ),
                        );
                      },
                      text: 'Start Enhancing',
                      icon: Icons.upload_file,
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 400.ms).scale(duration: 500.ms, curve: Curves.easeOutBack),
              
              const SizedBox(height: 32),

              // Features Section
              Text(
                'Key Features',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
              ).animate().fadeIn(delay: 500.ms),
              const SizedBox(height: 16),

              _FeatureCard(
                icon: Icons.edit_note,
                title: 'Semantic Enrichment',
                description:
                    'Enhance content meaning and relevance with advanced NLP techniques',
                color: Colors.purple,
                delay: 600,
              ),
              const SizedBox(height: 12),

              _FeatureCard(
                icon: Icons.query_stats,
                title: 'Query Expansion',
                description:
                    'Automatically expand and optimize search queries for better reach',
                color: Colors.orange,
                delay: 700,
              ),
              const SizedBox(height: 12),

              _FeatureCard(
                icon: Icons.sort,
                title: 'Intelligent Re-Ranking',
                description:
                    'Reorganize content based on relevance, impact, and SEO value',
                color: Colors.green,
                delay: 800,
              ),
              const SizedBox(height: 12),

              _FeatureCard(
                icon: Icons.trending_up,
                title: 'SEO Optimization',
                description:
                    'Improve digital visibility and online reputation metrics',
                color: Colors.blue,
                delay: 900,
              ),
              const SizedBox(height: 32),

              // Statistics Section
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      value: '98%',
                      label: 'Accuracy',
                      icon: Icons.verified,
                      delay: 1000,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      value: '10x',
                      label: 'Faster',
                      icon: Icons.speed,
                      delay: 1100,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      value: '24/7',
                      label: 'Available',
                      icon: Icons.access_time,
                      delay: 1200,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final int delay;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    this.delay = 0,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: 16,
      opacity: 0.14,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: delay.ms).moveX(begin: 50, end: 0, curve: Curves.easeOutQuad);
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final int delay;

  const _StatCard({
    required this.value,
    required this.label,
    required this.icon,
    this.delay = 0,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: 16,
      opacity: 0.14,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 28,
            ).animate(onPlay: (c) => c.repeat(reverse: true))
            .scale(begin: const Offset(1, 1), end: const Offset(1.2, 1.2), duration: 2.seconds),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: delay.ms).scale(duration: 400.ms, curve: Curves.easeOutBack);
  }
}
