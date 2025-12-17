import 'package:flutter/material.dart';

/// App-wide constants and configuration
/// Centralized place for all app settings and values
class AppConstants {
  // App Information
  static const String appName = 'E-Reputation Enhancer'; // App display name
  static const String appVersion = '1.0.0'; // Current version
  static const String appDescription =
      'Enhance your corporate content with AI-powered semantic enrichment'; // App description

  // Input Constraints
  static const int maxTextInputLength = 5000; // Maximum characters in text input
  static const int maxFileSize = 10 * 1024 * 1024; // Maximum file size (10MB)
  static const List<String> supportedFileExtensions = [
    'txt', // Plain text files
    'doc', // Microsoft Word (old format)
    'docx', // Microsoft Word (new format)
    'pdf' // PDF documents
  ];

  // Colors
  static const Color primaryColor = Color(0xFF1E88E5); // Main blue color
  static const Color secondaryColor = Color(0xFF1565C0); // Darker blue
  static const Color accentColor = Color(0xFF64B5F6); // Light blue accent
  static const Color successColor = Colors.green; // Success messages
  static const Color warningColor = Colors.orange; // Warning messages
  static const Color errorColor = Colors.red; // Error messages

  // Score Thresholds (for SEO and content scoring)
  static const double excellentScoreThreshold = 90.0; // Excellent score (90+)
  static const double goodScoreThreshold = 80.0; // Good score (80-89)
  static const double fairScoreThreshold = 70.0; // Fair score (70-79)
  static const double poorScoreThreshold = 60.0; // Poor score (below 60)

  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 300); // Quick animations
  static const Duration mediumAnimationDuration = Duration(milliseconds: 600); // Medium animations
  static const Duration longAnimationDuration = Duration(milliseconds: 1000); // Long animations

  // Mock Data Settings
  // Set to false to use real API (OpenRouter.ai recommended - works reliably)
  static const bool useMockData = false; // Set to false when using real backend (true for testing)
  static const Duration mockProcessingDelay = Duration(milliseconds: 1500); // Simulated processing time

  // API Configuration
  // Google Gemini API base URL: https://generativelanguage.googleapis.com/v1
  // Note: v1beta may not support all models, using v1 for better compatibility
  // Examples:
  // - Google Gemini: 'https://generativelanguage.googleapis.com/v1'
  // - OpenAI: 'https://api.openai.com'
  // - OpenRouter.ai: 'https://openrouter.ai/api/v1'
  // - Custom backend: 'https://your-backend.com'
  static const String apiBaseUrl = 'https://openrouter.ai/api/v1'; // OpenRouter.ai API (recommended - works with multiple AI models)
  static const String apiVersion = 'v1'; // API version
  static const Duration apiTimeout = Duration(seconds: 30); // Request timeout
  
  // Google Gemini API Configuration
  // Try gemini-1.5-flash or gemini-1.5-pro if gemini-pro doesn't work
  static const String geminiModel = 'gemini-1.5-flash'; // Default Gemini model (updated to newer model)
  static const String geminiGenerateEndpoint = '/models/gemini-1.5-flash:generateContent'; // Gemini generate endpoint
  
  // API Endpoints
  static const String enrichEndpoint = '/enrich'; // Content enrichment endpoint (custom backend)
  static const String rankEndpoint = '/rank'; // Content ranking endpoint (custom backend)
  static const String openRouterChatEndpoint = '/chat/completions'; // OpenRouter chat endpoint (for OpenRouter support)

  // Feature Flags (enable/disable features)
  static const bool enableFileUpload = true; // Allow file uploads
  static const bool enableExport = true; // Allow exporting results
  static const bool enableAnalytics = false; // Enable analytics tracking
}

/// Text constants and strings used throughout the app
/// Centralized strings for easy localization and updates
class AppStrings {
  // Home Screen
  static const String homeTitle = 'E-Reputation Enhancer'; // Main title
  static const String homeSubtitle =
      'Enhance your corporate content with AI-powered semantic enrichment and intelligent ranking'; // Subtitle
  static const String startButton = 'Start Enhancing'; // CTA button text

  // Content Input
  static const String textInputHint =
      'Enter your article, blog post, product description, or any corporate content here...'; // Text field hint
  static const String fileUploadHint = 'Tap to Upload File'; // File upload hint
  static const String enrichButton = 'Enrich Content'; // Process button text

  // Enrichment Results
  static const String seoScoreLabel = 'SEO Score'; // SEO score label
  static const String addedKeywordsLabel = 'Added Keywords'; // Keywords section title
  static const String suggestionsLabel = 'Optimization Suggestions'; // Suggestions section title

  // Ranking
  static const String rankingTitle = 'Intelligent Re-Ranking'; // Ranking screen title
  static const String sortByLabel = 'Sort by:'; // Sort dropdown label
  static const String overallScore = 'Overall Score'; // Overall score option
  static const String relevanceScore = 'Relevance'; // Relevance score option
  static const String impactScore = 'Impact'; // Impact score option
  static const String seoScore = 'SEO Score'; // SEO score option

  // Messages
  static const String successMessage = 'Content processed successfully!'; // Success notification
  static const String errorMessage = 'An error occurred. Please try again.'; // Error notification
  static const String emptyContentError = 'Please enter some content first'; // Validation error
  static const String copiedToClipboard = 'Copied to clipboard'; // Copy confirmation
}

/// Icon constants for consistent icon usage
class AppIcons {
  static const IconData home = Icons.home; // Home icon
  static const IconData upload = Icons.upload_file; // Upload icon
  static const IconData edit = Icons.edit_note; // Edit icon
  static const IconData analytics = Icons.analytics; // Analytics icon
  static const IconData ranking = Icons.sort; // Ranking/sort icon
  static const IconData keywords = Icons.label; // Keywords icon
  static const IconData suggestions = Icons.lightbulb_outline; // Suggestions icon
  static const IconData success = Icons.check_circle; // Success icon
  static const IconData error = Icons.error; // Error icon
  static const IconData info = Icons.info_outline; // Info icon
}

/// Padding and spacing constants for consistent layout
class AppSpacing {
  static const double xs = 4.0; // Extra small spacing
  static const double sm = 8.0; // Small spacing
  static const double md = 16.0; // Medium spacing
  static const double lg = 24.0; // Large spacing
  static const double xl = 32.0; // Extra large spacing
  static const double xxl = 48.0; // Extra extra large spacing
}

/// Border radius constants for consistent rounded corners
class AppRadius {
  static const double sm = 8.0; // Small radius
  static const double md = 12.0; // Medium radius
  static const double lg = 16.0; // Large radius
  static const double xl = 24.0; // Extra large radius
  
  // Convenience getters for BorderRadius objects
  static BorderRadius get smallRadius => BorderRadius.circular(sm);
  static BorderRadius get mediumRadius => BorderRadius.circular(md);
  static BorderRadius get largeRadius => BorderRadius.circular(lg);
  static BorderRadius get extraLargeRadius => BorderRadius.circular(xl);
}

