import 'package:hive/hive.dart';

part 'recipe_model.g.dart';

@HiveType(typeId: 0)
class Recipe extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String description;

  @HiveField(3)
  List<String> ingredients;

  @HiveField(4)
  List<String> instructions;

  @HiveField(5)
  String? imageUrl;

  @HiveField(6)
  String? videoUrl;

  @HiveField(7)
  int prepTime; // in minutes

  @HiveField(8)
  int cookTime; // in minutes

  @HiveField(9)
  int servings;

  @HiveField(10)
  String difficulty; // Easy, Medium, Hard

  @HiveField(11)
  List<String> tags;

  @HiveField(12)
  double rating;

  @HiveField(13)
  bool isFavorite;

  @HiveField(14)
  DateTime createdAt;

  @HiveField(15)
  String? category;

  @HiveField(16)
  int? calories;

  @HiveField(17)
  bool isAIGenerated;

  Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.ingredients,
    required this.instructions,
    this.imageUrl,
    this.videoUrl,
    required this.prepTime,
    required this.cookTime,
    required this.servings,
    required this.difficulty,
    required this.tags,
    this.rating = 0.0,
    this.isFavorite = false,
    required this.createdAt,
    this.category,
    this.calories,
    this.isAIGenerated = false,
  });

  int get totalTime => prepTime + cookTime;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'ingredients': ingredients,
      'instructions': instructions,
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
      'prepTime': prepTime,
      'cookTime': cookTime,
      'servings': servings,
      'difficulty': difficulty,
      'tags': tags,
      'rating': rating,
      'isFavorite': isFavorite,
      'createdAt': createdAt.toIso8601String(),
      'category': category,
      'calories': calories,
      'isAIGenerated': isAIGenerated,
    };
  }

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      ingredients: List<String>.from(json['ingredients'] as List),
      instructions: List<String>.from(json['instructions'] as List),
      imageUrl: json['imageUrl'] as String?,
      videoUrl: json['videoUrl'] as String?,
      prepTime: json['prepTime'] as int,
      cookTime: json['cookTime'] as int,
      servings: json['servings'] as int,
      difficulty: json['difficulty'] as String,
      tags: List<String>.from(json['tags'] as List),
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      isFavorite: json['isFavorite'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      category: json['category'] as String?,
      calories: json['calories'] as int?,
      isAIGenerated: json['isAIGenerated'] as bool? ?? false,
    );
  }

  Recipe copyWith({
    String? id,
    String? title,
    String? description,
    List<String>? ingredients,
    List<String>? instructions,
    String? imageUrl,
    String? videoUrl,
    int? prepTime,
    int? cookTime,
    int? servings,
    String? difficulty,
    List<String>? tags,
    double? rating,
    bool? isFavorite,
    DateTime? createdAt,
    String? category,
    int? calories,
    bool? isAIGenerated,
  }) {
    return Recipe(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      ingredients: ingredients ?? this.ingredients,
      instructions: instructions ?? this.instructions,
      imageUrl: imageUrl ?? this.imageUrl,
      videoUrl: videoUrl ?? this.videoUrl,
      prepTime: prepTime ?? this.prepTime,
      cookTime: cookTime ?? this.cookTime,
      servings: servings ?? this.servings,
      difficulty: difficulty ?? this.difficulty,
      tags: tags ?? this.tags,
      rating: rating ?? this.rating,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt ?? this.createdAt,
      category: category ?? this.category,
      calories: calories ?? this.calories,
      isAIGenerated: isAIGenerated ?? this.isAIGenerated,
    );
  }
}
