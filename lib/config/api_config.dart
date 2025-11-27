/// API Configuration
/// This file contains API keys and should be kept secure
///
/// IMPORTANT: This file is in .gitignore and will NOT be committed to git
/// For production, use environment variables or secure key management
library;

class ApiConfig {
  // Gemini API Key
  // Get your key from: https://makersuite.google.com/app/apikey
  static const String geminiApiKey = String.fromEnvironment(
    'GEMINI_API_KEY',
    defaultValue: 'AIzaSyABbDG8WNdZj-MjyrBO7JEHKBENTiZeErk',
  );

  // Check if API key is configured
  static bool get isConfigured =>
      geminiApiKey.isNotEmpty && geminiApiKey != 'YOUR_GEMINI_API_KEY';

  // Validate API key format
  static bool get isValid =>
      geminiApiKey.startsWith('AIza') && geminiApiKey.length > 30;
}
