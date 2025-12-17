# Backend & AI Integration Guide

This guide explains how to integrate real AI/NLP services and backend APIs into your E-Reputation Enhancer app.

---

## Table of Contents
1. [Architecture Overview](#architecture-overview)
2. [API Service Setup](#api-service-setup)
3. [AI/NLP Integration](#ainlp-integration)
4. [Authentication](#authentication)
5. [Error Handling](#error-handling)
6. [Testing](#testing)

---

## Architecture Overview

### Current (Mock) Architecture
```
User Input → Local Processing → Mock Data Generation → Display Results
```

### Production Architecture
```
User Input → API Service → Backend Server → AI/NLP Models → Response → Display Results
                ↓
         Error Handling
         State Management
         Caching
```

---

## API Service Setup

### Step 1: Create API Service Layer

Create `/lib/services/api_service.dart`:

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final String baseUrl = AppConstants.apiBaseUrl;
  final Duration timeout = AppConstants.apiTimeout;

  // Headers with authentication
  Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer ${_getAuthToken()}',
  };

  String _getAuthToken() {
    // Implement token retrieval from secure storage
    return 'your-auth-token';
  }

  // Generic POST request
  Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/$endpoint'),
            headers: headers,
            body: jsonEncode(data),
          )
          .timeout(timeout);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw ApiException(
          statusCode: response.statusCode,
          message: response.body,
        );
      }
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  // Content enrichment endpoint
  Future<Map<String, dynamic>> enrichContent({
    required String content,
    required String contentType,
  }) async {
    return await post('api/v1/enrich', {
      'content': content,
      'content_type': contentType,
      'options': {
        'include_keywords': true,
        'include_suggestions': true,
        'calculate_seo_score': true,
      },
    });
  }

  // Content ranking endpoint
  Future<List<dynamic>> rankContent({
    required String enrichedContent,
    required String criteria,
  }) async {
    final response = await post('api/v1/rank', {
      'content': enrichedContent,
      'criteria': criteria,
      'options': {
        'max_items': 10,
        'include_scores': true,
      },
    });
    return response['ranked_items'] as List<dynamic>;
  }
}

class ApiException implements Exception {
  final int? statusCode;
  final String message;
  
  ApiException({this.statusCode, required this.message});
  
  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}
```

### Step 2: Update pubspec.yaml

Add HTTP package:
```yaml
dependencies:
  http: ^1.1.0
  flutter_secure_storage: ^9.0.0  # For token storage
```

### Step 3: Update Constants

In `/lib/utils/constants.dart`:
```dart
// Production API
static const String apiBaseUrl = 'https://your-api.com';
static const bool useMockData = false;  // Set to false for production

// API Endpoints
static const String enrichEndpoint = '/api/v1/enrich';
static const String rankEndpoint = '/api/v1/rank';
static const String authEndpoint = '/api/v1/auth';
```

---

## AI/NLP Integration

### Option 1: Cloud-Based AI Services

#### OpenAI GPT Integration

```dart
import 'package:dart_openai/dart_openai.dart';

class OpenAIService {
  static void initialize() {
    OpenAI.apiKey = 'your-api-key';
  }

  static Future<String> enrichContent(String content) async {
    final response = await OpenAI.instance.completion.create(
      model: "gpt-4",
      prompt: """
        Enhance the following corporate content for better SEO and engagement.
        Add relevant keywords and improve clarity while maintaining the original message.
        
        Content: $content
        
        Enhanced version:
      """,
      maxTokens: 500,
      temperature: 0.7,
    );
    
    return response.choices.first.text.trim();
  }

  static Future<List<String>> extractKeywords(String content) async {
    final response = await OpenAI.instance.completion.create(
      model: "gpt-4",
      prompt: """
        Extract the top 8 most important keywords from this content:
        
        $content
        
        Keywords (comma-separated):
      """,
      maxTokens: 100,
    );
    
    return response.choices.first.text
        .trim()
        .split(',')
        .map((k) => k.trim())
        .toList();
  }
}
```

#### Google Cloud Natural Language

```dart
import 'package:googleapis/language/v1.dart';
import 'package:googleapis_auth/auth_io.dart';

class GoogleNLPService {
  late LanguageApi _languageApi;

  Future<void> initialize() async {
    final credentials = ServiceAccountCredentials.fromJson({
      // Your service account JSON
    });
    
    final client = await clientViaServiceAccount(
      credentials,
      [LanguageApi.cloudPlatformScope],
    );
    
    _languageApi = LanguageApi(client);
  }

  Future<List<String>> extractEntities(String content) async {
    final request = AnalyzeEntitiesRequest()
      ..document = (Document()
        ..content = content
        ..type = 'PLAIN_TEXT');
    
    final response = await _languageApi.documents.analyzeEntities(request);
    
    return response.entities!
        .map((e) => e.name!)
        .take(10)
        .toList();
  }

  Future<double> analyzeSentiment(String content) async {
    final request = AnalyzeSentimentRequest()
      ..document = (Document()
        ..content = content
        ..type = 'PLAIN_TEXT');
    
    final response = await _languageApi.documents.analyzeSentiment(request);
    
    return response.documentSentiment!.score!;
  }
}
```

### Option 2: Custom Transformer Models

#### Using TensorFlow Lite

```dart
import 'package:tflite_flutter/tflite_flutter.dart';

class TransformerService {
  late Interpreter _interpreter;

  Future<void> loadModel() async {
    _interpreter = await Interpreter.fromAsset('model.tflite');
  }

  Future<List<double>> getEmbeddings(String text) async {
    // Tokenize text
    final tokens = _tokenize(text);
    
    // Prepare input tensor
    final input = _prepareInput(tokens);
    
    // Prepare output tensor
    final output = List.filled(768, 0.0).reshape([1, 768]);
    
    // Run inference
    _interpreter.run(input, output);
    
    return output[0];
  }

  List<int> _tokenize(String text) {
    // Implement tokenization logic
    return [];
  }

  List<List<int>> _prepareInput(List<int> tokens) {
    // Prepare input tensor
    return [tokens];
  }
}
```

### Option 3: Custom Python Backend with Flask

**Backend (Python):**
```python
from flask import Flask, request, jsonify
from transformers import pipeline, AutoTokenizer, AutoModel
import torch

app = Flask(__name__)

# Load models
enrichment_model = pipeline('text2text-generation', model='t5-base')
keyword_extractor = pipeline('token-classification', model='bert-base-cased')

@app.route('/api/v1/enrich', methods=['POST'])
def enrich_content():
    data = request.json
    content = data['content']
    content_type = data['content_type']
    
    # Generate enriched content
    enriched = enrichment_model(
        f"enhance this {content_type}: {content}",
        max_length=500
    )[0]['generated_text']
    
    # Extract keywords
    keywords = keyword_extractor(content)
    top_keywords = [k['word'] for k in keywords[:8]]
    
    # Calculate SEO score (custom logic)
    seo_score = calculate_seo_score(content, enriched)
    
    return jsonify({
        'enriched_text': enriched,
        'keywords': top_keywords,
        'seo_score': seo_score,
        'suggestions': generate_suggestions(content, enriched)
    })

@app.route('/api/v1/rank', methods=['POST'])
def rank_content():
    data = request.json
    content = data['content']
    
    # Split into segments
    segments = split_content(content)
    
    # Score each segment
    ranked = []
    for i, segment in enumerate(segments):
        scores = {
            'relevance': calculate_relevance(segment),
            'impact': calculate_impact(segment),
            'seo': calculate_seo(segment)
        }
        ranked.append({
            'content': segment,
            'rank': i + 1,
            'scores': scores
        })
    
    # Sort by overall score
    ranked.sort(key=lambda x: sum(x['scores'].values()), reverse=True)
    
    return jsonify({'ranked_items': ranked})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
```

---

## Update Flutter Screens

### Update Content Input Screen

In `/lib/screens/content_input_screen.dart`:

```dart
void _processContent() async {
  if (_textController.text.trim().isEmpty) {
    // Show error
    return;
  }

  setState(() {
    _isProcessing = true;
  });

  try {
    // Call real API instead of mock data
    final apiService = ApiService();
    final response = await apiService.enrichContent(
      content: _textController.text,
      contentType: _getContentTypeString(_selectedType),
    );

    final content = ContentModel(
      originalText: _textController.text,
      timestamp: DateTime.now(),
      type: _selectedType,
      fileName: _fileName,
    );

    setState(() {
      _isProcessing = false;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EnrichmentResultsScreen(
          content: content,
          apiResponse: response,  // Pass API response
        ),
      ),
    );
  } catch (e) {
    setState(() {
      _isProcessing = false;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: ${e.toString()}'),
        backgroundColor: Colors.red,
      ),
    );
  }
}
```

### Update Enrichment Results Screen

```dart
void _generateEnrichedContent() {
  // Parse API response
  _enrichedContent = EnrichedContent(
    originalText: widget.content.originalText,
    enrichedText: widget.apiResponse['enriched_text'],
    addedKeywords: List<String>.from(widget.apiResponse['keywords']),
    suggestions: List<String>.from(widget.apiResponse['suggestions']),
    seoScore: widget.apiResponse['seo_score'].toDouble(),
    processedAt: DateTime.now(),
  );
}
```

---

## Authentication

### Implement Token-Based Auth

```dart
class AuthService {
  final _storage = FlutterSecureStorage();
  
  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }
  
  Future<void> setToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }
  
  Future<void> clearToken() async {
    await _storage.delete(key: 'auth_token');
  }
  
  Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConstants.apiBaseUrl}/auth/login'),
        body: jsonEncode({'email': email, 'password': password}),
        headers: {'Content-Type': 'application/json'},
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await setToken(data['token']);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
```

---

## Error Handling

### Create Error Handler

```dart
class ErrorHandler {
  static void handle(BuildContext context, dynamic error) {
    String message;
    
    if (error is ApiException) {
      message = _getApiErrorMessage(error.statusCode);
    } else if (error is SocketException) {
      message = 'No internet connection';
    } else if (error is TimeoutException) {
      message = 'Request timeout. Please try again.';
    } else {
      message = 'An unexpected error occurred';
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        action: SnackBarAction(
          label: 'Retry',
          textColor: Colors.white,
          onPressed: () {
            // Implement retry logic
          },
        ),
      ),
    );
  }
  
  static String _getApiErrorMessage(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Invalid request';
      case 401:
        return 'Unauthorized. Please login again.';
      case 403:
        return 'Access forbidden';
      case 404:
        return 'Resource not found';
      case 500:
        return 'Server error. Please try again later.';
      default:
        return 'Network error';
    }
  }
}
```

---

## Testing

### Unit Tests for API Service

Create `/test/api_service_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

void main() {
  group('ApiService', () {
    late ApiService apiService;
    late MockClient mockClient;
    
    setUp(() {
      mockClient = MockClient();
      apiService = ApiService();
    });
    
    test('enrichContent returns valid response', () async {
      when(mockClient.post(any, headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response(
            '{"enriched_text": "test", "keywords": [], "seo_score": 85}',
            200,
          ));
      
      final result = await apiService.enrichContent(
        content: 'test content',
        contentType: 'article',
      );
      
      expect(result['enriched_text'], 'test');
      expect(result['seo_score'], 85);
    });
  });
}
```

---

## Deployment Checklist

### Before Going Live

- [ ] Replace all mock data with real API calls
- [ ] Set `AppConstants.useMockData = false`
- [ ] Update `apiBaseUrl` with production URL
- [ ] Implement proper error handling
- [ ] Add loading states and retry logic
- [ ] Set up authentication
- [ ] Configure API timeouts
- [ ] Add request/response logging
- [ ] Implement caching strategy
- [ ] Add analytics tracking
- [ ] Test on slow network conditions
- [ ] Handle offline mode gracefully
- [ ] Secure API keys (use environment variables)
- [ ] Add rate limiting handling
- [ ] Implement request queuing for poor connections
- [ ] Add comprehensive error messages

---

## Environment Configuration

### Use flavors for different environments

```dart
enum Environment { development, staging, production }

class Config {
  static Environment env = Environment.development;
  
  static String get apiUrl {
    switch (env) {
      case Environment.development:
        return 'http://localhost:5000';
      case Environment.staging:
        return 'https://staging-api.example.com';
      case Environment.production:
        return 'https://api.example.com';
    }
  }
}
```

---

## Recommended Backend Stack

### Option 1: Node.js + Express
- Fast, lightweight
- Good TypeScript support
- Easy to deploy

### Option 2: Python + FastAPI
- Great for ML/AI integration
- Type hints support
- Async capabilities

### Option 3: Firebase + Cloud Functions
- Serverless
- Built-in authentication
- Auto-scaling

---

## Additional Resources

- [Hugging Face Models](https://huggingface.co/models)
- [OpenAI API Docs](https://platform.openai.com/docs)
- [Google Cloud NLP](https://cloud.google.com/natural-language)
- [TensorFlow Lite Flutter](https://pub.dev/packages/tflite_flutter)
- [Flutter HTTP Package](https://pub.dev/packages/http)

---

**Ready to integrate? Start with the API service layer and gradually replace mock functions!**

