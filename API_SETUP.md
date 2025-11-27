# API Configuration

## Gemini API Key Setup

To use the AI recipe generation features, you need to obtain a Gemini API key:

1. Visit [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Sign in with your Google account
3. Click "Create API Key"
4. Copy your API key

## Adding the API Key to the App

### Option 1: Direct Configuration (Development)

Open `lib/services/gemini_service.dart` and replace the placeholder:

```dart
static const String _apiKey = 'YOUR_GEMINI_API_KEY';
```

with your actual key:

```dart
static const String _apiKey = 'AIza...your-actual-key';
```

### Option 2: Environment Variables (Production)

For production apps, it's recommended to use environment variables:

1. Create a `.env` file in the root directory (already in .gitignore)
2. Add your key:
   ```
   GEMINI_API_KEY=AIza...your-actual-key
   ```

3. Use the `flutter_dotenv` package to load it

### Security Best Practices

⚠️ **IMPORTANT**: Never commit your API key to version control!

- The `.gitignore` file already excludes common secret files
- For production, use backend proxy or Firebase Functions
- Consider implementing rate limiting
- Monitor API usage in Google Cloud Console

## API Limits

Free tier limits (as of 2024):
- 60 requests per minute
- 1,500 requests per day

For higher limits, check [Google AI Pricing](https://ai.google.dev/pricing)

## Testing Without API Key

If you don't have an API key yet, you can still:
- Browse the UI
- View sample recipes (if added)
- Test offline features
- Explore the app design

The AI generation features will require a valid API key to function.
