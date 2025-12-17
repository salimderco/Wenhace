import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/api_service.dart';
import '../widgets/glass_theme.dart';

/// Screen for setting up API key
/// Allows users to enter and save their AI API key securely
class ApiKeySetupScreen extends StatefulWidget {
  const ApiKeySetupScreen({super.key});

  @override
  State<ApiKeySetupScreen> createState() => _ApiKeySetupScreenState();
}

class _ApiKeySetupScreenState extends State<ApiKeySetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _apiKeyController = TextEditingController();
  final _apiService = ApiService();
  bool _obscureKey = true; // Hide API key by default
  bool _isLoading = false;
  String? _currentApiKey;

  @override
  void initState() {
    super.initState();
    _loadCurrentApiKey();
  }

  /// Load existing API key (masked) to show if one is set
  Future<void> _loadCurrentApiKey() async {
    final apiKey = await _apiService.getApiKey();
    if (apiKey != null && mounted) {
      setState(() {
        _currentApiKey = apiKey;
        // Show masked version
        _apiKeyController.text = '••••••••${apiKey.substring(apiKey.length - 4)}';
      });
    }
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  /// Save API key to secure storage
  Future<void> _saveApiKey() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final apiKey = _apiKeyController.text.trim();
      await _apiService.setApiKey(apiKey);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('API key saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true); // Return true to indicate success
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving API key: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// Clear stored API key
  Future<void> _clearApiKey() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900]?.withOpacity(0.9),
        title: const Text('Clear API Key', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Are you sure you want to clear the stored API key?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _apiService.clearApiKey();
      setState(() {
        _currentApiKey = null;
        _apiKeyController.clear();
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('API key cleared'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GlassScaffold(
      appBar: GlassAppBar(
        title: 'API Key Setup',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Info Card
              GlassContainer(
                padding: 20,
                opacity: 0.16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.info_outline, color: Colors.white, size: 24),
                        SizedBox(width: 12),
                        Text(
                          'AI API Key Configuration',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Enter your Google Gemini API key to enable semantic enrichment and intelligent re-ranking features.',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Your API key is stored securely on your device and never shared.',
                      style: TextStyle(color: Colors.white60, fontSize: 12),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 200.ms).moveY(begin: 20, end: 0),

              const SizedBox(height: 32),

              // API Key Input
              GlassTextField(
                controller: _apiKeyController,
                label: 'AI API Key',
                hint: 'Enter your API key (e.g., sk-...)',
                prefixIcon: Icons.vpn_key,
                obscureText: _obscureKey,
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        _obscureKey ? Icons.visibility_off : Icons.visibility,
                        color: Colors.white70,
                      ),
                      onPressed: () => setState(() => _obscureKey = !_obscureKey),
                    ),
                    if (_currentApiKey != null)
                      IconButton(
                        icon: const Icon(Icons.clear, color: Colors.white70),
                        onPressed: _clearApiKey,
                        tooltip: 'Clear API key',
                      ),
                  ],
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your API key';
                  }
                  if (value.trim().length < 10) {
                    return 'API key seems too short';
                  }
                  return null;
                },
              ).animate().fadeIn(delay: 400.ms).moveX(begin: -20, end: 0),

              const SizedBox(height: 24),

              // Save Button
              GlassButton(
                onPressed: _isLoading ? null : _saveApiKey,
                text: _isLoading ? 'Saving...' : 'Save API Key',
                icon: _isLoading ? null : Icons.save,
                isLoading: _isLoading,
              ).animate().fadeIn(delay: 600.ms).moveY(begin: 20, end: 0),

              const SizedBox(height: 32),

              // Help Section
              GlassContainer(
                padding: 16,
                opacity: 0.12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.help_outline, color: Colors.white, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Where to get your API key?',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildHelpItem('Google Gemini: https://ai.google.dev/ (Currently configured)'),
                    _buildHelpItem('OpenAI: https://platform.openai.com/api-keys'),
                    _buildHelpItem('OpenRouter.ai: https://openrouter.ai/keys'),
                    _buildHelpItem('Anthropic: https://console.anthropic.com/'),
                  ],
                ),
              ).animate().fadeIn(delay: 800.ms).moveY(begin: 20, end: 0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHelpItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(color: Colors.white70)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

