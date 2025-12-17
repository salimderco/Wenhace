# API Key Setup Guide

This guide explains how to set up your AI API key for semantic enrichment and intelligent re-ranking features.

## Quick Start

1. **Get your API key** from your AI service provider (OpenAI, Google AI, Anthropic, etc.)
2. **Open the app** and tap the 🔑 (key) icon in the top-right corner
3. **Enter your API key** in the setup screen
4. **Save** and start using AI-powered features!

## Step-by-Step Instructions

### Step 1: Get Your API Key

Choose your AI service provider:

#### Google Gemini (Currently Configured)
- Visit: https://ai.google.dev/
- Sign in with your Google account
- Click "Get API Key"
- Create a new project or select existing one
- Copy the API key
- **Base URL**: `https://generativelanguage.googleapis.com/v1beta` (already configured)
- **Models available**: `gemini-pro`, `gemini-pro-vision`
- **Cost**: Free tier available, pay-per-use pricing

#### OpenAI (GPT models)
- Visit: https://platform.openai.com/api-keys
- Sign up or log in
- Click "Create new secret key"
- Copy the key (starts with `sk-...`)
- **Base URL**: `https://api.openai.com`

#### Google AI (Gemini)
- Visit: https://makersuite.google.com/app/apikey
- Sign in with Google account
- Create API key
- Copy the key
- **Base URL**: `https://generativelanguage.googleapis.com`

#### Anthropic (Claude)
- Visit: https://console.anthropic.com/
- Sign up or log in
- Navigate to API Keys section
- Create new key
- Copy the key
- **Base URL**: `https://api.anthropic.com`

#### Custom Backend
- Contact your backend administrator
- Get your API endpoint URL and key

### Step 2: Configure API Base URL (Already Set for Google Gemini!)

The base URL is already configured for Google Gemini: `https://generativelanguage.googleapis.com/v1beta`

If you want to use a different service, update it in `lib/utils/constants.dart`:

```dart
// For Google Gemini (already set)
static const String apiBaseUrl = 'https://generativelanguage.googleapis.com/v1beta';

// For OpenAI
static const String apiBaseUrl = 'https://api.openai.com';

// For OpenRouter.ai
static const String apiBaseUrl = 'https://openrouter.ai/api/v1';

// For custom backend
static const String apiBaseUrl = 'https://your-backend.com';
```

**Note**: The app automatically detects Google Gemini and uses the generateContent API directly. No backend wrapper needed!

### Step 3: Set Up API Key in App

1. Launch the app
2. Log in (or use test credentials: `test@example.com` / `password123`)
3. Tap the 🔑 icon in the top-right corner of the home screen
4. Enter your API key
5. Tap "Save API Key"

### Step 4: Enable Real API (Disable Mock Data)

1. Open `lib/utils/constants.dart`
2. Set `useMockData` to `false`:

```dart
static const bool useMockData = false; // Use real API
```

3. Restart the app

## How It Works with Google Gemini

When using Google Gemini, the app:
1. ✅ Automatically detects Gemini from the base URL
2. ✅ Uses the `/models/gemini-pro:generateContent` endpoint directly
3. ✅ Sends prompts to Gemini for content enrichment
4. ✅ Parses JSON responses from the AI
5. ✅ No backend wrapper needed!

### Available Gemini Models

You can use these Gemini models:
- `gemini-pro` - Standard text model (default)
- `gemini-pro-vision` - For text + image analysis
- `gemini-1.5-pro` - Latest advanced model (if available)

## API Endpoints (For Custom Backend)

If you're using a custom backend (not OpenRouter), it should have these endpoints:

### Content Enrichment
- **Endpoint**: `POST /api/v1/enrich`
- **Request Body**:
```json
{
  "content": "Your content text here...",
  "content_type": "article",
  "options": {
    "include_keywords": true,
    "include_suggestions": true,
    "calculate_seo_score": true
  }
}
```

- **Response**:
```json
{
  "enriched_text": "Enhanced content...",
  "keywords": ["keyword1", "keyword2"],
  "suggestions": ["suggestion1", "suggestion2"],
  "seo_score": 87.5,
  "processed_at": "2024-01-01T12:00:00Z"
}
```

### Content Ranking
- **Endpoint**: `POST /api/v1/rank`
- **Request Body**:
```json
{
  "content": "Enriched content...",
  "criteria": "overall",
  "options": {
    "max_items": 10,
    "include_scores": true
  }
}
```

- **Response**:
```json
{
  "ranked_items": [
    {
      "content": "Content snippet...",
      "relevance_score": 92.5,
      "impact_score": 88.0,
      "seo_score": 90.0,
      "tags": ["tag1", "tag2"]
    }
  ]
}
```

## Security Notes

- ✅ API key is stored securely on your device using `SharedPreferences`
- ✅ Key is never shared or transmitted except to your API endpoint
- ✅ You can clear the key anytime from the setup screen
- ⚠️ Keep your API key secret - don't commit it to version control

## Troubleshooting

### "API Key Required" Error
- Make sure you've entered and saved your API key
- Check that `useMockData` is set to `false` in constants

### "Network Error"
- Check your internet connection
- Verify the API base URL is correct
- Ensure your API service is accessible

### "API Error (401)"
- Your API key might be invalid or expired
- Check if the key is correct
- Verify the key has proper permissions

### "API Error (404)"
- The endpoint URL might be incorrect
- Check that your backend has the required endpoints
- Verify the API version matches

## Testing with Mock Data

To test the app without an API key:

1. Set `useMockData = true` in `lib/utils/constants.dart`
2. The app will use simulated data
3. No API key required

## Next Steps

After setting up your API key:

1. ✅ Test content enrichment
2. ✅ Test intelligent ranking
3. ✅ Verify results match your expectations
4. ✅ Adjust API endpoints if needed
5. ✅ Customize enrichment options

## Support

If you encounter issues:
1. Check the error message in the app
2. Verify your API key is valid
3. Test your API endpoints directly
4. Check network connectivity
5. Review the API service logs

---

**Note**: The app includes fallback to mock data if the API fails, so you can always test the UI even without a working API.

