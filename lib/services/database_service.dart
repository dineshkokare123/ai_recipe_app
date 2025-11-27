import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import '../models/recipe_model.dart';

class RecipeDatabase {
  static const String _recipesBox = 'recipes';
  static const String _favoritesBox = 'favorites';

  static Box<Recipe>? _recipes;
  static Box<String>? _favorites;

  static Future<void> init() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);

    // Register adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(RecipeAdapter());
    }

    // Open boxes
    _recipes = await Hive.openBox<Recipe>(_recipesBox);
    _favorites = await Hive.openBox<String>(_favoritesBox);
  }

  // Recipe CRUD operations
  static Future<void> saveRecipe(Recipe recipe) async {
    await _recipes?.put(recipe.id, recipe);
  }

  static Future<void> saveRecipes(List<Recipe> recipes) async {
    final Map<String, Recipe> recipeMap = {
      for (var recipe in recipes) recipe.id: recipe,
    };
    await _recipes?.putAll(recipeMap);
  }

  static Recipe? getRecipe(String id) {
    return _recipes?.get(id);
  }

  static List<Recipe> getAllRecipes() {
    return _recipes?.values.toList() ?? [];
  }

  static Future<void> deleteRecipe(String id) async {
    await _recipes?.delete(id);
  }

  static Future<void> updateRecipe(Recipe recipe) async {
    await _recipes?.put(recipe.id, recipe);
  }

  // Favorite operations
  static Future<void> toggleFavorite(String recipeId) async {
    final recipe = getRecipe(recipeId);
    if (recipe != null) {
      recipe.isFavorite = !recipe.isFavorite;
      await updateRecipe(recipe);

      if (recipe.isFavorite) {
        await _favorites?.put(recipeId, recipeId);
      } else {
        await _favorites?.delete(recipeId);
      }
    }
  }

  static List<Recipe> getFavoriteRecipes() {
    final favoriteIds = _favorites?.values.toList() ?? [];
    return favoriteIds
        .map((id) => getRecipe(id))
        .where((recipe) => recipe != null)
        .cast<Recipe>()
        .toList();
  }

  static bool isFavorite(String recipeId) {
    return _favorites?.containsKey(recipeId) ?? false;
  }

  // Search and filter
  static List<Recipe> searchRecipes(String query) {
    final allRecipes = getAllRecipes();
    final lowerQuery = query.toLowerCase();

    return allRecipes.where((recipe) {
      return recipe.title.toLowerCase().contains(lowerQuery) ||
          recipe.description.toLowerCase().contains(lowerQuery) ||
          recipe.tags.any((tag) => tag.toLowerCase().contains(lowerQuery)) ||
          recipe.ingredients.any(
            (ing) => ing.toLowerCase().contains(lowerQuery),
          );
    }).toList();
  }

  static List<Recipe> getRecipesByCategory(String category) {
    return getAllRecipes()
        .where(
          (recipe) => recipe.category?.toLowerCase() == category.toLowerCase(),
        )
        .toList();
  }

  static List<Recipe> getRecipesByDifficulty(String difficulty) {
    return getAllRecipes()
        .where(
          (recipe) =>
              recipe.difficulty.toLowerCase() == difficulty.toLowerCase(),
        )
        .toList();
  }

  static List<Recipe> getRecipesByTag(String tag) {
    return getAllRecipes()
        .where(
          (recipe) =>
              recipe.tags.any((t) => t.toLowerCase() == tag.toLowerCase()),
        )
        .toList();
  }

  static List<Recipe> getAIGeneratedRecipes() {
    return getAllRecipes().where((recipe) => recipe.isAIGenerated).toList();
  }

  // Statistics
  static int getTotalRecipes() {
    return _recipes?.length ?? 0;
  }

  static int getTotalFavorites() {
    return _favorites?.length ?? 0;
  }

  static List<String> getAllCategories() {
    final categories = getAllRecipes()
        .map((recipe) => recipe.category)
        .where((category) => category != null)
        .cast<String>()
        .toSet()
        .toList();
    categories.sort();
    return categories;
  }

  static List<String> getAllTags() {
    final tags = <String>{};
    for (var recipe in getAllRecipes()) {
      tags.addAll(recipe.tags);
    }
    final tagList = tags.toList();
    tagList.sort();
    return tagList;
  }

  // Clear data
  static Future<void> clearAllRecipes() async {
    await _recipes?.clear();
  }

  static Future<void> clearFavorites() async {
    await _favorites?.clear();
  }

  static Future<void> close() async {
    await _recipes?.close();
    await _favorites?.close();
  }
}
