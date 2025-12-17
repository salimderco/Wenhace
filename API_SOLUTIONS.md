# API Solutions Guide

## Current Issue
The app is having trouble connecting to Google Gemini API. Here are multiple solutions:

## Solution 1: Switch to OpenRouter.ai (RECOMMENDED - Easiest)

**Why OpenRouter?**
- ✅ Works with multiple AI models (GPT-4, Claude, Gemini, etc.)
- ✅ Simple API key setup
- ✅ No model compatibility issues
- ✅ Pay-per-use pricing
- ✅ Already supported in the code!

**Steps:**
1. Get API key: https://openrouter.ai/keys
2. Update `lib/utils/constants.dart`:
   ```dart
   static const String apiBaseUrl = 'https://openrouter.ai/api/v1';
   ```
3. Set your OpenRouter API key in the app
4. Done! It will automatically use OpenRouter

**Models available:**
- `openai/gpt-4o-mini` (cheapest, good quality)
- `openai/gpt-4o` (best quality)
- `anthropic/claude-3-sonnet` (great for analysis)
- `google/gemini-pro` (Google's model via OpenRouter)

---

## Solution 2: Fix Google Gemini API

**The Problem:**
- Model name might be wrong
- API version might be wrong
- API key might be invalid

**Try these fixes:**

### Option A: Use v1beta with correct model
Update `lib/utils/constants.dart`:
```dart
static const String apiBaseUrl = 'https://generativelanguage.googleapis.com/v1beta';
static const String geminiModel = 'gemini-1.5-flash-latest';
```

### Option B: Use v1 with different model
```dart
static const String apiBaseUrl = 'https://generativelanguage.googleapis.com/v1';
static const String geminiModel = 'gemini-1.5-pro-latest';
```

### Option C: Check your API key
1. Go to https://ai.google.dev/
2. Make sure API is enabled for your project
3. Check API key permissions
4. Try generating a new key

---

## Solution 3: Use OpenAI Directly

**Steps:**
1. Get API key: https://platform.openai.com/api-keys
2. Update `lib/utils/constants.dart`:
   ```dart
   static const String apiBaseUrl = 'https://api.openai.com';
   ```
3. Update `lib/services/api_service.dart` to add OpenAI support (or use OpenRouter which is easier)

---

## Solution 4: Use Mock Data (For Testing UI)

If you just want to test the UI without API:
```dart
// In lib/utils/constants.dart
static const bool useMockData = true;
```

---

## Quick Fix: Switch to OpenRouter Now

**Fastest solution - do this:**

1. **Get OpenRouter API key:**
   - Visit: https://openrouter.ai/keys
   - Sign up (free)
   - Create API key

2. **Update the code:**
   ```dart
   // In lib/utils/constants.dart, line 54:
   static const String apiBaseUrl = 'https://openrouter.ai/api/v1';
   ```

3. **Set API key in app:**
   - Run the app
   - Go to API key settings
   - Enter your OpenRouter API key

4. **Hot reload** (press `r` in terminal)

**That's it!** OpenRouter is already fully supported in the code.

---

## Which Solution Should You Choose?

| Solution | Difficulty | Cost | Reliability |
|----------|-----------|------|-------------|
| **OpenRouter** | ⭐ Easy | Pay-per-use | ⭐⭐⭐⭐⭐ |
| Fix Gemini | ⭐⭐ Medium | Free tier | ⭐⭐⭐ |
| OpenAI Direct | ⭐⭐⭐ Hard | Pay-per-use | ⭐⭐⭐⭐ |
| Mock Data | ⭐ Very Easy | Free | N/A (testing only) |

**Recommendation:** Use **OpenRouter** - it's the easiest and most reliable!

---

## Need Help?

If you choose OpenRouter:
1. The code already supports it
2. Just change the base URL
3. Get an API key
4. It will work immediately

If you want to stick with Gemini:
1. Check the error message in Chrome console
2. Try different model names
3. Verify your API key is valid
4. Check Google AI Studio for available models

