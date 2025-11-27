import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/recipe_model.dart';
import 'package:uuid/uuid.dart';
import '../config/api_config.dart';

class GeminiService {
  late final GenerativeModel _model;

  GeminiService() {
    // Use API key from secure configuration
    _model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: ApiConfig.geminiApiKey,
    );
  }

  Future<Recipe?> generateRecipe({
    required String prompt,
    String? cuisine,
    String? difficulty,
    int? servings,
    List<String>? dietaryRestrictions,
  }) async {
    try {
      // Build detailed prompt
      final fullPrompt = _buildRecipePrompt(
        prompt: prompt,
        cuisine: cuisine,
        difficulty: difficulty,
        servings: servings,
        dietaryRestrictions: dietaryRestrictions,
      );

      final content = [Content.text(fullPrompt)];
      final response = await _model.generateContent(content);

      if (response.text != null) {
        final recipe = _parseRecipeFromResponse(response.text!);
        // Add a sample video URL for demonstration
        recipe.videoUrl =
            'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4';
        return recipe;
      }
    } catch (e) {
      debugPrint('Error generating recipe: $e');
      rethrow;
    }
    return null;
  }

  Future<List<Recipe>> generateMultipleRecipes({
    required String prompt,
    int count = 3,
  }) async {
    try {
      final fullPrompt =
          '''
Generate $count different recipe variations based on: "$prompt"

For each recipe, provide:
1. Title
2. Description
3. Ingredients (list)
4. Step-by-step instructions (list)
5. Prep time (minutes)
6. Cook time (minutes)
7. Servings
8. Difficulty (Easy/Medium/Hard)
9. Category
10. Tags (comma-separated)
11. Estimated calories

Format each recipe as JSON with the following structure:
{
  "title": "Recipe Name",
  "description": "Brief description",
  "ingredients": ["ingredient 1", "ingredient 2"],
  "instructions": ["step 1", "step 2"],
  "prepTime": 15,
  "cookTime": 30,
  "servings": 4,
  "difficulty": "Medium",
  "category": "Main Course",
  "tags": ["tag1", "tag2"],
  "calories": 350
}

Return an array of $count recipes in valid JSON format.
''';

      final content = [Content.text(fullPrompt)];
      final response = await _model.generateContent(content);

      if (response.text != null) {
        return _parseMultipleRecipes(response.text!);
      }
    } catch (e) {
     debugPrint('Error generating multiple recipes: $e');
      rethrow;
    }
    return [];
  }

  Future<String> generateRecipeVariation(Recipe recipe) async {
    try {
      final prompt =
          '''
Create a variation of this recipe: "${recipe.title}"

Original ingredients: ${recipe.ingredients.join(', ')}

Suggest a creative variation with:
1. Modified ingredients
2. Different cooking technique
3. Unique flavor profile

Keep it concise and exciting!
''';

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);

      return response.text ?? 'No variation generated';
    } catch (e) {
      debugPrint('Error generating variation: $e');
      return 'Error generating variation';
    }
  }

  Future<String> generateCookingTips(Recipe recipe) async {
    try {
      final prompt =
          '''
Provide 5 expert cooking tips for making "${recipe.title}".
Focus on:
- Technique improvements
- Common mistakes to avoid
- Ingredient substitutions
- Presentation ideas
- Storage recommendations
''';

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);

      return response.text ?? 'No tips generated';
    } catch (e) {
      debugPrint('Error generating tips: $e');
      return 'Error generating tips';
    }
  }

  Future<List<String>> suggestIngredientSubstitutions(String ingredient) async {
    try {
      final prompt =
          '''
Suggest 5 common substitutions for: "$ingredient"
Format: "substitute - reason for substitution"
Be practical and consider availability and dietary needs.
''';

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);

      if (response.text != null) {
        return response.text!
            .split('\n')
            .where((line) => line.trim().isNotEmpty)
            .take(5)
            .toList();
      }
    } catch (e) {
      debugPrint('Error suggesting substitutions: $e');
    }
    return [];
  }

  String _buildRecipePrompt({
    required String prompt,
    String? cuisine,
    String? difficulty,
    int? servings,
    List<String>? dietaryRestrictions,
  }) {
    final buffer = StringBuffer();
    buffer.writeln('Generate a detailed recipe based on: "$prompt"');

    if (cuisine != null) buffer.writeln('Cuisine: $cuisine');
    if (difficulty != null) buffer.writeln('Difficulty: $difficulty');
    if (servings != null) buffer.writeln('Servings: $servings');
    if (dietaryRestrictions != null && dietaryRestrictions.isNotEmpty) {
      buffer.writeln('Dietary restrictions: ${dietaryRestrictions.join(', ')}');
    }

    buffer.writeln('''

Provide the recipe in the following JSON format:
{
  "title": "Recipe Name",
  "description": "A brief, appetizing description",
  "ingredients": ["ingredient 1 with quantity", "ingredient 2 with quantity"],
  "instructions": ["Step 1 detailed instruction", "Step 2 detailed instruction"],
  "prepTime": 15,
  "cookTime": 30,
  "servings": 4,
  "difficulty": "Easy/Medium/Hard",
  "category": "Appetizer/Main Course/Dessert/etc",
  "tags": ["tag1", "tag2", "tag3"],
  "calories": 350
}

Make it detailed, practical, and delicious!
''');

    return buffer.toString();
  }

  Recipe _parseRecipeFromResponse(String response) {
    try {
      // Extract JSON from response (handle markdown code blocks)
      String jsonStr = response;
      if (response.contains('```json')) {
        jsonStr = response.split('```json')[1].split('```')[0].trim();
      } else if (response.contains('```')) {
        jsonStr = response.split('```')[1].split('```')[0].trim();
      }

      final Map<String, dynamic> json = jsonDecode(jsonStr);

      return Recipe(
        id: const Uuid().v4(),
        title: json['title'] as String,
        description: json['description'] as String,
        ingredients: List<String>.from(json['ingredients'] as List),
        instructions: List<String>.from(json['instructions'] as List),
        prepTime: json['prepTime'] as int,
        cookTime: json['cookTime'] as int,
        servings: json['servings'] as int,
        difficulty: json['difficulty'] as String,
        tags: List<String>.from(json['tags'] as List),
        category: json['category'] as String?,
        calories: json['calories'] as int?,
        createdAt: DateTime.now(),
        isAIGenerated: true,
      );
    } catch (e) {
      debugPrint('Error parsing recipe: $e');
      debugPrint('Response: $response');
      rethrow;
    }
  }

  List<Recipe> _parseMultipleRecipes(String response) {
    try {
      String jsonStr = response;
      if (response.contains('```json')) {
        jsonStr = response.split('```json')[1].split('```')[0].trim();
      } else if (response.contains('```')) {
        jsonStr = response.split('```')[1].split('```')[0].trim();
      }

      final List<dynamic> jsonList = jsonDecode(jsonStr);

      return jsonList.map((json) {
        return Recipe(
          id: const Uuid().v4(),
          title: json['title'] as String,
          description: json['description'] as String,
          ingredients: List<String>.from(json['ingredients'] as List),
          instructions: List<String>.from(json['instructions'] as List),
          prepTime: json['prepTime'] as int,
          cookTime: json['cookTime'] as int,
          servings: json['servings'] as int,
          difficulty: json['difficulty'] as String,
          tags: List<String>.from(json['tags'] as List),
          category: json['category'] as String?,
          calories: json['calories'] as int?,
          createdAt: DateTime.now(),
          isAIGenerated: true,
        );
      }).toList();
    } catch (e) {
      debugPrint('Error parsing multiple recipes: $e');
      return [];
    }
  }
}
