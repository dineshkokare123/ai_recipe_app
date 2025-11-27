# AI Recipe App 🍳

A beautiful Flutter application that generates recipes using Google's Gemini AI with offline support and video integration.

## Features ✨

- **🤖 AI-Powered Recipe Generation**: Generate custom recipes using Gemini AI
- **💾 Offline Support**: All recipes stored locally using Hive database
- **🎥 Video Integration**: Support for recipe videos
- **❤️ Favorites System**: Save your favorite recipes
- **🔍 Smart Search**: Search by ingredients, tags, or recipe names
- **🏷️ Category Filtering**: Filter recipes by category and difficulty
- **⭐ Rating System**: Rate your recipes
- **📱 Beautiful UI**: Modern dark theme with gradients and animations
- **🎨 Staggered Animations**: Smooth, eye-catching animations
- **🍽️ Cooking Tips**: AI-generated cooking tips for each recipe

## Getting Started 🚀

### Prerequisites

- Flutter SDK (3.10.0 or higher)
- Dart SDK
- Google Gemini API Key

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/dineshkokare123/ai_recipe_app
   cd ai_recipe_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate Hive adapters**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Add your Gemini API Key**
   
   Open `lib/services/gemini_service.dart` and replace `YOUR_GEMINI_API_KEY` with your actual API key:
   
   ```dart
   static const String _apiKey = 'YOUR_ACTUAL_GEMINI_API_KEY';
   ```
   
   Get your API key from: https://makersuite.google.com/app/apikey

5. **Run the app**
   ```bash
   flutter run
   ```

## Project Structure 📁

```
lib/
├── models/
│   ├── recipe_model.dart          # Recipe data model with Hive annotations
│   └── recipe_model.g.dart        # Generated Hive adapter
├── providers/
│   └── recipe_provider.dart       # State management with Provider
├── screens/
│   ├── home_screen.dart           # Main home screen with recipe grid
│   ├── ai_generate_screen.dart    # AI recipe generation interface
│   └── recipe_detail_screen.dart  # Detailed recipe view
├── services/
│   ├── database_service.dart      # Hive database operations
│   └── gemini_service.dart        # Gemini AI integration
├── theme/
│   └── app_theme.dart             # App-wide theme configuration
├── widgets/
│   ├── recipe_card.dart           # Recipe card widget
│   ├── search_bar_widget.dart     # Search bar component
│   ├── category_chip.dart         # Category filter chip
│   ├── stats_card.dart            # Statistics card
│   └── video_player_widget.dart   # Video player component
└── main.dart                       # App entry point
```

## Key Technologies 🛠️

- **Flutter**: Cross-platform mobile framework
- **Google Generative AI**: Gemini AI for recipe generation
- **Hive**: Lightweight and fast NoSQL database for offline storage
- **Provider**: State management solution
- **Cached Network Image**: Efficient image loading and caching
- **Video Player & Chewie**: Video playback support
- **Google Fonts**: Beautiful typography (Poppins & Inter)
- **Flutter Staggered Animations**: Smooth list animations
- **Shimmer**: Loading state animations
- **Share Plus**: Recipe sharing functionality
- **Flutter Rating Bar**: Interactive rating system

## Usage 💡

### Generating Recipes with AI

1. Tap the **"Generate with AI"** floating action button
2. Describe what you want to cook
3. Optionally select:
   - Cuisine type
   - Difficulty level
   - Number of servings
   - Dietary restrictions
4. Tap **"Generate Recipe"**
5. Wait for AI to create your custom recipe

### Managing Recipes

- **View All Recipes**: Browse all saved recipes on the home screen
- **Search**: Use the search bar to find recipes by name, ingredients, or tags
- **Filter**: Select categories to filter recipes
- **Favorite**: Tap the heart icon to add/remove from favorites
- **Rate**: Rate recipes using the star rating system
- **Share**: Share recipes with friends using the share button

### AI Features

- **Cooking Tips**: Get AI-generated tips for any recipe
- **Variations**: Generate recipe variations
- **Ingredient Substitutions**: Find alternatives for ingredients

## Customization 🎨

### Theme Colors

Edit `lib/theme/app_theme.dart` to customize colors:

```dart
static const Color primaryColor = Color(0xFF6C63FF);
static const Color secondaryColor = Color(0xFFFF6584);
static const Color accentColor = Color(0xFF4ECDC4);
```

### Fonts

The app uses Google Fonts (Poppins and Inter). You can change them in `app_theme.dart`.

## Offline Support 💾

All recipes are automatically saved to local storage using Hive. The app works perfectly offline once recipes are generated and saved.

## API Configuration ⚙️

### Gemini AI Setup

1. Visit [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Create a new API key
3. Add the key to `lib/services/gemini_service.dart`

## Building for Production 📦

### Android

```bash
flutter build apk --release
```

### iOS

```bash
flutter build ios --release
```

## Troubleshooting 🔧

### Common Issues

1. **Hive adapter not found**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

2. **API key errors**
   - Ensure your Gemini API key is correctly set
   - Check your internet connection for AI features

3. **Video playback issues**
   - Ensure video URLs are valid and accessible
   - Check platform-specific video player configurations

## Future Enhancements 🚀

- [ ] Recipe video recording
- [ ] Meal planning calendar
- [ ] Shopping list generation
- [ ] Nutritional information tracking
- [ ] Social features (share recipes with community)
- [ ] Voice-guided cooking mode
- [ ] AR cooking instructions
- [ ] Multi-language support

## App Screenshots:

[Uploading ai_recipe_app.webm…]()



## Contributing 🤝

Contributions are welcome! Please feel free to submit a Pull Request.

## License 📄

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments 🙏

- Google Gemini AI for powerful recipe generation
- Flutter team for the amazing framework
- All open-source package contributors

## Support 💬

For support, email [dineshkokare5@gmail.com] or open an issue in the repository.

---

Made with ❤️ using Flutter and Gemini AI
