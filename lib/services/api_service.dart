import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';
import '../models/content_model.dart';

/// API Service for semantic enrichment and intelligent re-ranking
/// Handles communication with AI/NLP backend services
class ApiService {
  // Singleton pattern
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // API configuration
  final String baseUrl = AppConstants.apiBaseUrl;
  final Duration timeout = AppConstants.apiTimeout;
  
  // API key storage key
  static const String _apiKeyStorageKey = 'ai_api_key';

  /// Get stored API key from local storage
  /// Uses SharedPreferences (works on all platforms without additional setup)
  Future<String?> getApiKey() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_apiKeyStorageKey);
    } catch (e) {
      // If there's an error, return null
      return null;
    }
  }

  /// Save API key to local storage
  /// Uses SharedPreferences for reliable cross-platform storage
  Future<void> setApiKey(String apiKey) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_apiKeyStorageKey, apiKey);
    } catch (e) {
      throw Exception('Failed to save API key: $e');
    }
  }

  /// Clear stored API key
  Future<void> clearApiKey() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_apiKeyStorageKey);
    } catch (e) {
      // Ignore errors when clearing
    }
  }

  /// Get HTTP headers
  /// OpenRouter uses Authorization header, Gemini uses query parameter
  Future<Map<String, String>> _getHeaders() async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    // Add OpenRouter-specific headers if using OpenRouter
    if (baseUrl.contains('openrouter.ai')) {
      final apiKey = await getApiKey();
      if (apiKey != null && apiKey.isNotEmpty) {
        headers['Authorization'] = 'Bearer $apiKey';
        headers['HTTP-Referer'] = 'https://github.com'; // Optional: your app URL
        headers['X-Title'] = 'E-Reputation Enhancer'; // Optional: your app name
      }
    }
    
    return headers;
  }

  /// Get API key for query parameter (Gemini uses key as query param, not header)
  Future<String> _getApiKeyForRequest() async {
    final apiKey = await getApiKey();
    if (apiKey == null || apiKey.isEmpty) {
      throw ApiException(message: 'API key is missing. Please set your API key in settings.');
    }
    return apiKey;
  }

  /// Generic POST request helper
  /// For Google Gemini, API key is passed as query parameter
  Future<Map<String, dynamic>> _post(
    String endpoint,
    Map<String, dynamic> data, {
    bool useQueryKey = false, // Gemini uses query parameter for API key
  }) async {
    try {
      final headers = await _getHeaders();
      
      // Construct URL properly - handle both absolute and relative endpoints
      final String fullUrl;
      if (endpoint.startsWith('http://') || endpoint.startsWith('https://')) {
        fullUrl = endpoint; // Already absolute
      } else {
        // Ensure proper URL construction
        final base = baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;
        final end = endpoint.startsWith('/') ? endpoint : '/$endpoint';
        fullUrl = '$base$end';
      }
      
      // For Gemini, add API key as query parameter
      // For OpenRouter, API key goes in Authorization header (handled in _getHeaders)
      Uri url;
      if (useQueryKey && baseUrl.contains('generativelanguage.googleapis.com')) {
        final apiKey = await _getApiKeyForRequest();
        url = Uri.parse(fullUrl).replace(queryParameters: {'key': apiKey});
      } else {
        url = Uri.parse(fullUrl);
      }
      
      // Debug: Print URL (remove in production)
      print('API Request: $fullUrl');
      print('Headers: ${headers.keys.toList()}');
      
      final response = await http
          .post(
            url,
            headers: headers,
            body: jsonEncode(data),
          )
          .timeout(timeout);

      // Debug: Print response status
      print('Response Status: ${response.statusCode}');
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        // Print error response for debugging
        print('Error Response: ${response.body}');
        throw ApiException(
          statusCode: response.statusCode,
          message: _parseErrorMessage(response.body),
        );
      }
    } on http.ClientException catch (e) {
      print('ClientException: $e');
      throw ApiException(message: 'Network error. Please check your internet connection and API key.');
    } on FormatException catch (e) {
      print('FormatException: $e');
      throw ApiException(message: 'Invalid API response format. Please check your API configuration.');
    } on Exception catch (e) {
      print('Exception: $e');
      if (e is ApiException) rethrow;
      throw ApiException(message: 'API Error: ${e.toString()}');
    } catch (e) {
      print('Unknown Error: $e');
      throw ApiException(message: 'Unexpected error: ${e.toString()}');
    }
  }

  /// Parse error message from API response
  String _parseErrorMessage(String body) {
    try {
      final json = jsonDecode(body) as Map<String, dynamic>;
      return json['message'] ?? json['error'] ?? body;
    } catch (_) {
      return body;
    }
  }

  /// Enrich content semantically using AI
  /// Supports Google Gemini, custom backend, and OpenRouter.ai
  /// Returns enriched content with keywords, suggestions, and SEO score
  Future<EnrichedContent> enrichContent({
    required String content,
    required ContentType contentType,
    String? model, // Optional: specify model (e.g., 'gemini-pro', 'gemini-pro-vision')
  }) async {
    if (AppConstants.useMockData) {
      // Fallback to mock data if enabled
      return _generateMockEnrichedContent(content);
    }

    try {
      // Check which API service to use
      final isGemini = baseUrl.contains('generativelanguage.googleapis.com');
      final isOpenRouter = baseUrl.contains('openrouter.ai');
      
      if (isGemini) {
        // Use Google Gemini API
        return await _enrichWithGemini(content, contentType, model);
      } else if (isOpenRouter) {
        // Use OpenRouter's chat completions API directly
        return await _enrichWithOpenRouter(content, contentType, model);
      } else {
        // Use custom backend endpoints
        return await _enrichWithCustomBackend(content, contentType);
      }
    } catch (e) {
      // If API fails and mock data is disabled, rethrow error
      if (!AppConstants.useMockData) rethrow;
      
      // Otherwise, fallback to mock data
      return _generateMockEnrichedContent(content);
    }
  }

  /// Enrich content using Google Gemini API
  Future<EnrichedContent> _enrichWithGemini(
    String content,
    ContentType contentType,
    String? model,
  ) async {
    // Use specified model or default
    final selectedModel = model ?? AppConstants.geminiModel;
    final endpoint = '/models/$selectedModel:generateContent';
    
    final prompt = '''
You are an expert content enhancement AI. Analyze and enhance the following corporate content for better SEO and semantic richness.

Content Type: ${contentType.toString().split('.').last}
Original Content:
$content

Please provide:
1. An enhanced version of the content with improved SEO keywords and semantic richness
2. A list of 5-8 relevant keywords that were added or emphasized
3. 3-5 optimization suggestions
4. An SEO score from 0-100

Respond in JSON format:
{
  "enriched_text": "enhanced content here...",
  "keywords": ["keyword1", "keyword2", ...],
  "suggestions": ["suggestion1", "suggestion2", ...],
  "seo_score": 85.5
}
''';

    // Gemini API request format
    final requestData = {
      'contents': [
        {
          'parts': [
            {'text': prompt}
          ]
        }
      ],
      'generationConfig': {
        'temperature': 0.7,
        'maxOutputTokens': 2000,
      },
    };

    final response = await _post(endpoint, requestData, useQueryKey: true);

    // Check for API errors first
    if (response.containsKey('error')) {
      final error = response['error'] as Map<String, dynamic>;
      final errorMessage = error['message'] as String? ?? 'Unknown API error';
      final errorCode = error['code'] as int? ?? 0;
      throw ApiException(
        message: 'Gemini API Error ($errorCode): $errorMessage',
      );
    }

    // Parse Gemini response
    final candidates = response['candidates'] as List?;
    if (candidates == null || candidates.isEmpty) {
      throw ApiException(message: 'No response from Gemini API');
    }

    final candidate = candidates[0] as Map<String, dynamic>;
    final contentPart = candidate['content'] as Map<String, dynamic>?;
    final parts = contentPart?['parts'] as List?;
    
    if (parts == null || parts.isEmpty) {
      throw ApiException(message: 'Invalid response format from Gemini');
    }

    final textPart = parts[0] as Map<String, dynamic>;
    final message = textPart['text'] as String? ?? '';
    
    // Try to parse JSON from response
    try {
      // Extract JSON from markdown code blocks if present
      String jsonStr = message;
      if (message.contains('```json')) {
        jsonStr = message.split('```json')[1].split('```')[0].trim();
      } else if (message.contains('```')) {
        jsonStr = message.split('```')[1].split('```')[0].trim();
      }
      
      final parsed = jsonDecode(jsonStr) as Map<String, dynamic>;
      
      return EnrichedContent(
        originalText: content,
        enrichedText: parsed['enriched_text'] as String? ?? content,
        addedKeywords: List<String>.from(parsed['keywords'] as List? ?? []),
        suggestions: List<String>.from(parsed['suggestions'] as List? ?? []),
        seoScore: (parsed['seo_score'] as num?)?.toDouble() ?? 0.0,
        processedAt: DateTime.now(),
      );
    } catch (_) {
      // If JSON parsing fails, use the raw response as enriched text
      return EnrichedContent(
        originalText: content,
        enrichedText: message,
        addedKeywords: [],
        suggestions: ['AI response received but could not parse structured data'],
        seoScore: 75.0,
        processedAt: DateTime.now(),
      );
    }
  }

  /// Enrich content using OpenRouter.ai chat completions API
  Future<EnrichedContent> _enrichWithOpenRouter(
    String content,
    ContentType contentType,
    String? model,
  ) async {
    // Default to a good model if not specified
    final selectedModel = model ?? 'openai/gpt-4o-mini'; // Cost-effective default
    
    final prompt = '''
You are an expert content enhancement AI. Analyze and enhance the following corporate content for better SEO and semantic richness.

Content Type: ${contentType.toString().split('.').last}
Original Content:
$content

Please provide:
1. An enhanced version of the content with improved SEO keywords and semantic richness
2. A list of 5-8 relevant keywords that were added or emphasized
3. 3-5 optimization suggestions
4. An SEO score from 0-100

Respond in JSON format:
{
  "enriched_text": "enhanced content here...",
  "keywords": ["keyword1", "keyword2", ...],
  "suggestions": ["suggestion1", "suggestion2", ...],
  "seo_score": 85.5
}
''';

    final response = await _post(AppConstants.openRouterChatEndpoint, {
      'model': selectedModel,
      'messages': [
        {'role': 'user', 'content': prompt}
      ],
      'temperature': 0.7,
      'max_tokens': 2000,
    });

    // Parse OpenRouter response
    final choices = response['choices'] as List?;
    if (choices == null || choices.isEmpty) {
      throw ApiException(message: 'No response from AI model');
    }

    final message = choices[0]['message']['content'] as String;
    
    // Try to parse JSON from response
    try {
      // Extract JSON from markdown code blocks if present
      String jsonStr = message;
      if (message.contains('```json')) {
        jsonStr = message.split('```json')[1].split('```')[0].trim();
      } else if (message.contains('```')) {
        jsonStr = message.split('```')[1].split('```')[0].trim();
      }
      
      final parsed = jsonDecode(jsonStr) as Map<String, dynamic>;
      
      return EnrichedContent(
        originalText: content,
        enrichedText: parsed['enriched_text'] as String? ?? content,
        addedKeywords: List<String>.from(parsed['keywords'] as List? ?? []),
        suggestions: List<String>.from(parsed['suggestions'] as List? ?? []),
        seoScore: (parsed['seo_score'] as num?)?.toDouble() ?? 0.0,
        processedAt: DateTime.now(),
      );
    } catch (_) {
      // If JSON parsing fails, use the raw response as enriched text
      return EnrichedContent(
        originalText: content,
        enrichedText: message,
        addedKeywords: [],
        suggestions: ['AI response received but could not parse structured data'],
        seoScore: 75.0,
        processedAt: DateTime.now(),
      );
    }
  }

  /// Enrich content using custom backend
  Future<EnrichedContent> _enrichWithCustomBackend(
    String content,
    ContentType contentType,
  ) async {
    final response = await _post(AppConstants.enrichEndpoint, {
      'content': content,
      'content_type': contentType.toString().split('.').last,
      'options': {
        'include_keywords': true,
        'include_suggestions': true,
        'calculate_seo_score': true,
      },
    });

    return EnrichedContent(
      originalText: content,
      enrichedText: response['enriched_text'] as String? ?? content,
      addedKeywords: List<String>.from(
        response['keywords'] as List? ?? [],
      ),
      suggestions: List<String>.from(
        response['suggestions'] as List? ?? [],
      ),
      seoScore: (response['seo_score'] as num?)?.toDouble() ?? 0.0,
      processedAt: DateTime.parse(
        response['processed_at'] as String? ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  /// Rank content intelligently using AI
  /// Supports Google Gemini, custom backend, and OpenRouter.ai
  /// Returns ranked content items with scores
  Future<List<RankedContent>> rankContent({
    required String enrichedContent,
    String criteria = 'overall',
    String? model, // Optional: specify model (e.g., 'gemini-pro')
  }) async {
    if (AppConstants.useMockData) {
      // Fallback to mock data if enabled
      return _generateMockRankedContent(enrichedContent);
    }

    try {
      // Check which API service to use
      final isGemini = baseUrl.contains('generativelanguage.googleapis.com');
      final isOpenRouter = baseUrl.contains('openrouter.ai');
      
      if (isGemini) {
        // Use Google Gemini API for ranking
        return await _rankWithGemini(enrichedContent, criteria, model);
      } else if (isOpenRouter) {
        // Use OpenRouter's chat completions API for ranking
        return await _rankWithOpenRouter(enrichedContent, criteria, model);
      } else {
        // Use custom backend endpoints
        return await _rankWithCustomBackend(enrichedContent, criteria);
      }
    } catch (e) {
      // If API fails and mock data is disabled, rethrow error
      if (!AppConstants.useMockData) rethrow;
      
      // Otherwise, fallback to mock data
      return _generateMockRankedContent(enrichedContent);
    }
  }

  /// Rank content using Google Gemini API
  Future<List<RankedContent>> _rankWithGemini(
    String enrichedContent,
    String criteria,
    String? model,
  ) async {
    final selectedModel = model ?? AppConstants.geminiModel;
    final endpoint = '/models/$selectedModel:generateContent';
    
    // Split content into segments for ranking
    final segments = enrichedContent.split('\n\n').where((s) => s.trim().isNotEmpty).toList();
    
    final prompt = '''
You are an expert content analyst. Rank and score the following content segments based on: $criteria

Content segments to rank:
${segments.asMap().entries.map((e) => '${e.key + 1}. ${e.value}').join('\n\n')}

For each segment, provide:
- relevance_score (0-100): How relevant to target audience
- impact_score (0-100): Business/marketing impact
- seo_score (0-100): SEO effectiveness
- tags: Relevant categorization tags

Respond in JSON format:
{
  "ranked_items": [
    {
      "content": "segment text...",
      "relevance_score": 92.5,
      "impact_score": 88.0,
      "seo_score": 90.0,
      "tags": ["tag1", "tag2"]
    }
  ]
}
''';

    // Gemini API request format
    final requestData = {
      'contents': [
        {
          'parts': [
            {'text': prompt}
          ]
        }
      ],
      'generationConfig': {
        'temperature': 0.5,
        'maxOutputTokens': 2000,
      },
    };

    final response = await _post(endpoint, requestData, useQueryKey: true);

    // Check for API errors first
    if (response.containsKey('error')) {
      final error = response['error'] as Map<String, dynamic>;
      final errorMessage = error['message'] as String? ?? 'Unknown API error';
      final errorCode = error['code'] as int? ?? 0;
      throw ApiException(
        message: 'Gemini API Error ($errorCode): $errorMessage',
      );
    }

    // Parse Gemini response
    final candidates = response['candidates'] as List?;
    if (candidates == null || candidates.isEmpty) {
      throw ApiException(message: 'No response from Gemini API');
    }

    final candidate = candidates[0] as Map<String, dynamic>;
    final contentPart = candidate['content'] as Map<String, dynamic>?;
    final parts = contentPart?['parts'] as List?;
    
    if (parts == null || parts.isEmpty) {
      throw ApiException(message: 'Invalid response format from Gemini');
    }

    final textPart = parts[0] as Map<String, dynamic>;
    final message = textPart['text'] as String? ?? '';
    
    try {
      String jsonStr = message;
      if (message.contains('```json')) {
        jsonStr = message.split('```json')[1].split('```')[0].trim();
      } else if (message.contains('```')) {
        jsonStr = message.split('```')[1].split('```')[0].trim();
      }
      
      final parsed = jsonDecode(jsonStr) as Map<String, dynamic>;
      final items = parsed['ranked_items'] as List? ?? [];
      
      return items.asMap().entries.map((entry) {
        final item = entry.value as Map<String, dynamic>;
        return RankedContent(
          content: item['content'] as String? ?? segments[entry.key],
          relevanceScore: (item['relevance_score'] as num?)?.toDouble() ?? 0.0,
          impactScore: (item['impact_score'] as num?)?.toDouble() ?? 0.0,
          seoScore: (item['seo_score'] as num?)?.toDouble() ?? 0.0,
          rank: entry.key + 1,
          tags: List<String>.from(item['tags'] as List? ?? []),
        );
      }).toList();
    } catch (_) {
      // Fallback: create ranked items from segments
      return segments.asMap().entries.map((entry) {
        return RankedContent(
          content: entry.value,
          relevanceScore: 80.0 - (entry.key * 2.0),
          impactScore: 75.0 - (entry.key * 1.5),
          seoScore: 85.0 - (entry.key * 1.0),
          rank: entry.key + 1,
          tags: ['content', 'segment${entry.key + 1}'],
        );
      }).toList();
    }
  }

  /// Rank content using OpenRouter.ai
  Future<List<RankedContent>> _rankWithOpenRouter(
    String enrichedContent,
    String criteria,
    String? model,
  ) async {
    final selectedModel = model ?? 'openai/gpt-4o-mini';
    
    // Split content into segments for ranking
    final segments = enrichedContent.split('\n\n').where((s) => s.trim().isNotEmpty).toList();
    
    final prompt = '''
You are an expert content analyst. Rank and score the following content segments based on: $criteria

Content segments to rank:
${segments.asMap().entries.map((e) => '${e.key + 1}. ${e.value}').join('\n\n')}

For each segment, provide:
- relevance_score (0-100): How relevant to target audience
- impact_score (0-100): Business/marketing impact
- seo_score (0-100): SEO effectiveness
- tags: Relevant categorization tags

Respond in JSON format:
{
  "ranked_items": [
    {
      "content": "segment text...",
      "relevance_score": 92.5,
      "impact_score": 88.0,
      "seo_score": 90.0,
      "tags": ["tag1", "tag2"]
    }
  ]
}
''';

    final response = await _post(AppConstants.openRouterChatEndpoint, {
      'model': selectedModel,
      'messages': [
        {'role': 'user', 'content': prompt}
      ],
      'temperature': 0.5,
      'max_tokens': 2000,
    });

    final choices = response['choices'] as List?;
    if (choices == null || choices.isEmpty) {
      throw ApiException(message: 'No response from AI model');
    }

    final message = choices[0]['message']['content'] as String;
    
    try {
      String jsonStr = message;
      if (message.contains('```json')) {
        jsonStr = message.split('```json')[1].split('```')[0].trim();
      } else if (message.contains('```')) {
        jsonStr = message.split('```')[1].split('```')[0].trim();
      }
      
      final parsed = jsonDecode(jsonStr) as Map<String, dynamic>;
      final items = parsed['ranked_items'] as List? ?? [];
      
      return items.asMap().entries.map((entry) {
        final item = entry.value as Map<String, dynamic>;
        return RankedContent(
          content: item['content'] as String? ?? segments[entry.key],
          relevanceScore: (item['relevance_score'] as num?)?.toDouble() ?? 0.0,
          impactScore: (item['impact_score'] as num?)?.toDouble() ?? 0.0,
          seoScore: (item['seo_score'] as num?)?.toDouble() ?? 0.0,
          rank: entry.key + 1,
          tags: List<String>.from(item['tags'] as List? ?? []),
        );
      }).toList();
    } catch (_) {
      // Fallback: create ranked items from segments
      return segments.asMap().entries.map((entry) {
        return RankedContent(
          content: entry.value,
          relevanceScore: 80.0 - (entry.key * 2.0),
          impactScore: 75.0 - (entry.key * 1.5),
          seoScore: 85.0 - (entry.key * 1.0),
          rank: entry.key + 1,
          tags: ['content', 'segment${entry.key + 1}'],
        );
      }).toList();
    }
  }

  /// Rank content using custom backend
  Future<List<RankedContent>> _rankWithCustomBackend(
    String enrichedContent,
    String criteria,
  ) async {
    final response = await _post(AppConstants.rankEndpoint, {
      'content': enrichedContent,
      'criteria': criteria,
      'options': {
        'max_items': 10,
        'include_scores': true,
      },
    });

    final items = response['ranked_items'] as List? ?? [];
    return items.asMap().entries.map((entry) {
      final item = entry.value as Map<String, dynamic>;
      return RankedContent(
        content: item['content'] as String? ?? '',
        relevanceScore: (item['relevance_score'] as num?)?.toDouble() ?? 0.0,
        impactScore: (item['impact_score'] as num?)?.toDouble() ?? 0.0,
        seoScore: (item['seo_score'] as num?)?.toDouble() ?? 0.0,
        rank: entry.key + 1,
        tags: List<String>.from(item['tags'] as List? ?? []),
      );
    }).toList();
  }

  /// Generate mock enriched content (fallback)
  EnrichedContent _generateMockEnrichedContent(String original) {
    return EnrichedContent(
      originalText: original,
      enrichedText: '$original\n\n[AI-Enhanced Content]\n\nThis content has been semantically enriched with relevant keywords and optimized for better SEO performance.',
      addedKeywords: [
        'digital transformation',
        'innovation',
        'enterprise solutions',
        'business intelligence',
      ],
      suggestions: [
        'Add more specific metrics and data points',
        'Include customer testimonials or case studies',
        'Emphasize unique value propositions',
      ],
      seoScore: 87.5,
      processedAt: DateTime.now(),
    );
  }

  /// Generate mock ranked content (fallback)
  List<RankedContent> _generateMockRankedContent(String content) {
    final segments = content.split('\n\n').where((s) => s.trim().isNotEmpty).toList();
    return segments.asMap().entries.map((entry) {
      final index = entry.key;
      return RankedContent(
        content: entry.value,
        relevanceScore: 90.0 - (index * 2.0),
        impactScore: 85.0 - (index * 1.5),
        seoScore: 88.0 - (index * 1.0),
        rank: index + 1,
        tags: ['tag${index + 1}', 'content'],
      );
    }).toList();
  }
}

/// API Exception class for error handling
class ApiException implements Exception {
  final int? statusCode;
  final String message;

  ApiException({this.statusCode, required this.message});

  @override
  String toString() {
    if (statusCode != null) {
      return 'API Error ($statusCode): $message';
    }
    return 'API Error: $message';
  }
}

