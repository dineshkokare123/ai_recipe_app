import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/recipe_model.dart';
import '../services/database_service.dart';
import '../services/gemini_service.dart';

class RecipeProvider extends ChangeNotifier {
  final GeminiService _geminiService = GeminiService();

  List<Recipe> _recipes = [];
  List<Recipe> _favoriteRecipes = [];
  List<Recipe> _searchResults = [];
  bool _isLoading = false;
  bool _isGenerating = false;
  String? _error;
  String _searchQuery = '';
  String? _selectedCategory;
  String? _selectedDifficulty;

  // Getters
  List<Recipe> get recipes => _recipes;
  List<Recipe> get favoriteRecipes => _favoriteRecipes;
  List<Recipe> get searchResults => _searchResults;
  bool get isLoading => _isLoading;
  bool get isGenerating => _isGenerating;
  String? get error => _error;
  String get searchQuery => _searchQuery;
  String? get selectedCategory => _selectedCategory;
  String? get selectedDifficulty => _selectedDifficulty;

  List<Recipe> get displayedRecipes {
    if (_searchQuery.isNotEmpty) {
      return _searchResults;
    }

    var filtered = List<Recipe>.from(_recipes);

    if (_selectedCategory != null) {
      filtered = filtered
          .where(
            (r) =>
                r.category?.toLowerCase() == _selectedCategory?.toLowerCase(),
          )
          .toList();
    }

    if (_selectedDifficulty != null) {
      filtered = filtered
          .where(
            (r) =>
                r.difficulty.toLowerCase() ==
                _selectedDifficulty?.toLowerCase(),
          )
          .toList();
    }

    return filtered;
  }

  List<String> get categories => RecipeDatabase.getAllCategories();
  List<String> get tags => RecipeDatabase.getAllTags();
  int get totalRecipes => RecipeDatabase.getTotalRecipes();
  int get totalFavorites => RecipeDatabase.getTotalFavorites();

  // Initialize
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      await RecipeDatabase.init();
      await loadRecipes();

      // Load sample recipes if database is empty
      if (_recipes.isEmpty) {
        await _loadSampleRecipes();
      }

      await loadFavorites();
      _error = null;
    } catch (e) {
      _error = 'Failed to initialize: $e';
      if (kDebugMode) {
        print(_error);
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load sample recipes
  Future<void> _loadSampleRecipes() async {
    try {
      // Import sample recipes dynamically to avoid circular dependency
      final sampleRecipes = await _getSampleRecipes();
      for (var recipe in sampleRecipes) {
        await RecipeDatabase.saveRecipe(recipe);
      }
      await loadRecipes();
    } catch (e) {
      if (kDebugMode) {
        print('Failed to load sample recipes: $e');
      }
    }
  }

  Future<List<Recipe>> _getSampleRecipes() async {
    // Sample recipes defined inline to avoid import issues
    final uuid = const Uuid();
    return [
      Recipe(
        id: uuid.v4(),
        title: 'Classic Margherita Pizza',
        description:
            'A traditional Italian pizza with fresh mozzarella, tomatoes, and basil',
        ingredients: [
          '2 cups all-purpose flour',
          '1 tsp active dry yeast',
          '1 tsp sugar',
          '3/4 cup warm water',
          '2 tbsp olive oil',
          '1 tsp salt',
          '1 cup tomato sauce',
          '8 oz fresh mozzarella',
          'Fresh basil leaves',
        ],
        instructions: [
          'Mix warm water, yeast, and sugar. Let sit for 5 minutes.',
          'Combine flour and salt. Add yeast mixture and olive oil.',
          'Knead dough for 8-10 minutes until smooth.',
          'Let rise for 1 hour.',
          'Preheat oven to 475°F (245°C).',
          'Roll out dough and add toppings.',
          'Bake for 12-15 minutes until golden.',
        ],
        prepTime: 20,
        cookTime: 15,
        servings: 4,
        difficulty: 'Medium',
        tags: ['Italian', 'Pizza', 'Vegetarian'],
        category: 'Main Course',
        calories: 285,
        createdAt: DateTime.now(),
        isAIGenerated: false,
        imageUrl:
            'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
        videoUrl: 'https://www.youtube.com/watch?v=sv3TXMSv6Lw',
      ),
    ];
  }

  // Load recipes from database
  Future<void> loadRecipes() async {
    try {
      _recipes = RecipeDatabase.getAllRecipes();
      _recipes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load recipes: $e';
      if (kDebugMode) {
        print(_error);
      }
    }
  }

  // Load favorites
  Future<void> loadFavorites() async {
    try {
      _favoriteRecipes = RecipeDatabase.getFavoriteRecipes();
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load favorites: $e';
      if (kDebugMode) {
        print(_error);
      }
    }
  }

  // Add recipe
  Future<void> addRecipe(Recipe recipe) async {
    try {
      await RecipeDatabase.saveRecipe(recipe);
      await loadRecipes();
      _error = null;
    } catch (e) {
      _error = 'Failed to add recipe: $e';
      if (kDebugMode) {
        print(_error);
      }
    }
  }

  // Update recipe
  Future<void> updateRecipe(Recipe recipe) async {
    try {
      await RecipeDatabase.updateRecipe(recipe);
      await loadRecipes();
      _error = null;
    } catch (e) {
      _error = 'Failed to update recipe: $e';
      if (kDebugMode) {
        print(_error);
      }
    }
  }

  // Delete recipe
  Future<void> deleteRecipe(String id) async {
    try {
      await RecipeDatabase.deleteRecipe(id);
      await loadRecipes();
      await loadFavorites();
      _error = null;
    } catch (e) {
      _error = 'Failed to delete recipe: $e';
      if (kDebugMode) {
        print(_error);
      }
    }
  }

  // Toggle favorite
  Future<void> toggleFavorite(String recipeId) async {
    try {
      await RecipeDatabase.toggleFavorite(recipeId);
      await loadRecipes();
      await loadFavorites();
      _error = null;
    } catch (e) {
      _error = 'Failed to toggle favorite: $e';
      if (kDebugMode) {
        print(_error);
      }
    }
  }

  // Update rating
  Future<void> updateRating(String recipeId, double rating) async {
    try {
      final recipe = RecipeDatabase.getRecipe(recipeId);
      if (recipe != null) {
        final updatedRecipe = recipe.copyWith(rating: rating);
        await updateRecipe(updatedRecipe);
      }
    } catch (e) {
      _error = 'Failed to update rating: $e';
      if (kDebugMode) {
        print(_error);
      }
    }
  }

  // Search
  void search(String query) {
    _searchQuery = query;
    if (query.isEmpty) {
      _searchResults = [];
    } else {
      _searchResults = RecipeDatabase.searchRecipes(query);
    }
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    _searchResults = [];
    notifyListeners();
  }

  // Filters
  void setCategory(String? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setDifficulty(String? difficulty) {
    _selectedDifficulty = difficulty;
    notifyListeners();
  }

  void clearFilters() {
    _selectedCategory = null;
    _selectedDifficulty = null;
    notifyListeners();
  }

  // AI Recipe Generation
  Future<Recipe?> generateRecipe({
    required String prompt,
    String? cuisine,
    String? difficulty,
    int? servings,
    List<String>? dietaryRestrictions,
  }) async {
    _isGenerating = true;
    _error = null;
    notifyListeners();

    try {
      final recipe = await _geminiService.generateRecipe(
        prompt: prompt,
        cuisine: cuisine,
        difficulty: difficulty,
        servings: servings,
        dietaryRestrictions: dietaryRestrictions,
      );

      if (recipe != null) {
        await addRecipe(recipe);
        _isGenerating = false;
        notifyListeners();
        return recipe;
      }
    } catch (e) {
      _error = 'Failed to generate recipe: $e';
      if (kDebugMode) {
        print(_error);
      }
    } finally {
      _isGenerating = false;
      notifyListeners();
    }
    return null;
  }

  Future<List<Recipe>> generateMultipleRecipes({
    required String prompt,
    int count = 3,
  }) async {
    _isGenerating = true;
    _error = null;
    notifyListeners();

    try {
      final recipes = await _geminiService.generateMultipleRecipes(
        prompt: prompt,
        count: count,
      );

      if (recipes.isNotEmpty) {
        for (var recipe in recipes) {
          await addRecipe(recipe);
        }
      }

      return recipes;
    } catch (e) {
      _error = 'Failed to generate recipes: $e';
      if (kDebugMode) {
        print(_error);
      }
      return [];
    } finally {
      _isGenerating = false;
      notifyListeners();
    }
  }

  Future<String> generateRecipeVariation(Recipe recipe) async {
    try {
      return await _geminiService.generateRecipeVariation(recipe);
    } catch (e) {
      _error = 'Failed to generate variation: $e';
      return 'Error generating variation';
    }
  }

  Future<String> generateCookingTips(Recipe recipe) async {
    try {
      return await _geminiService.generateCookingTips(recipe);
    } catch (e) {
      _error = 'Failed to generate tips: $e';
      return 'Error generating tips';
    }
  }

  Future<List<String>> suggestIngredientSubstitutions(String ingredient) async {
    try {
      return await _geminiService.suggestIngredientSubstitutions(ingredient);
    } catch (e) {
      _error = 'Failed to suggest substitutions: $e';
      return [];
    }
  }

  // Get recipe by ID
  Recipe? getRecipeById(String id) {
    return RecipeDatabase.getRecipe(id);
  }

  // Statistics
  Map<String, int> getRecipeStats() {
    return {
      'total': totalRecipes,
      'favorites': totalFavorites,
      'aiGenerated': RecipeDatabase.getAIGeneratedRecipes().length,
      'categories': categories.length,
    };
  }
}
