import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/recipe_provider.dart';
import '../theme/app_theme.dart';
import 'recipe_detail_screen.dart';

class AIGenerateScreen extends StatefulWidget {
  const AIGenerateScreen({super.key});

  @override
  State<AIGenerateScreen> createState() => _AIGenerateScreenState();
}

class _AIGenerateScreenState extends State<AIGenerateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _promptController = TextEditingController();

  String? _selectedCuisine;
  String? _selectedDifficulty;
  int _servings = 4;
  final List<String> _dietaryRestrictions = [];

  final List<String> _cuisines = [
    'Italian',
    'Chinese',
    'Indian',
    'Mexican',
    'Japanese',
    'Thai',
    'French',
    'Mediterranean',
    'American',
    'Korean',
  ];

  final List<String> _difficulties = ['Easy', 'Medium', 'Hard'];

  final List<String> _dietaryOptions = [
    'Vegetarian',
    'Vegan',
    'Gluten-Free',
    'Dairy-Free',
    'Keto',
    'Low-Carb',
    'Paleo',
    'Halal',
  ];

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<RecipeProvider>(
          builder: (context, provider, child) {
            if (provider.isGenerating) {
              return _buildGeneratingView();
            }

            return CustomScrollView(
              slivers: [
                _buildAppBar(context),
                SliverPadding(
                  padding: const EdgeInsets.all(20),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _buildPromptSection(),
                      const SizedBox(height: 24),
                      _buildCuisineSection(),
                      const SizedBox(height: 24),
                      _buildDifficultySection(),
                      const SizedBox(height: 24),
                      _buildServingsSection(),
                      const SizedBox(height: 24),
                      _buildDietarySection(),
                      const SizedBox(height: 32),
                      _buildGenerateButton(context, provider),
                      const SizedBox(height: 16),
                      _buildQuickPrompts(context),
                    ]),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      floating: true,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'AI Recipe Generator',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          Text(
            'Powered by Gemini AI',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildPromptSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.auto_awesome, size: 20),
            ),
            const SizedBox(width: 12),
            Text(
              'What would you like to cook?',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Form(
          key: _formKey,
          child: TextFormField(
            controller: _promptController,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText:
                  'E.g., "A healthy pasta dish with vegetables" or "Spicy chicken curry"',
              prefixIcon: Icon(Icons.edit, color: AppTheme.primaryColor),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please describe what you want to cook';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCuisineSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cuisine Type (Optional)',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _cuisines.map((cuisine) {
            final isSelected = _selectedCuisine == cuisine;
            return FilterChip(
              label: Text(cuisine),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedCuisine = selected ? cuisine : null;
                });
              },
              backgroundColor: AppTheme.surfaceColor,
              selectedColor: AppTheme.primaryColor,
              checkmarkColor: AppTheme.textPrimary,
              labelStyle: TextStyle(
                color: isSelected
                    ? AppTheme.textPrimary
                    : AppTheme.textSecondary,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDifficultySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Difficulty Level',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        Row(
          children: _difficulties.map((difficulty) {
            final isSelected = _selectedDifficulty == difficulty;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDifficulty = difficulty;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      gradient: isSelected ? AppTheme.primaryGradient : null,
                      color: isSelected ? null : AppTheme.surfaceColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? Colors.transparent
                            : AppTheme.surfaceColor,
                      ),
                    ),
                    child: Text(
                      difficulty,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isSelected
                            ? AppTheme.textPrimary
                            : AppTheme.textSecondary,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildServingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Number of Servings',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.surfaceColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  if (_servings > 1) {
                    setState(() => _servings--);
                  }
                },
                icon: const Icon(Icons.remove_circle_outline),
                color: AppTheme.primaryColor,
              ),
              Text(
                '$_servings servings',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              IconButton(
                onPressed: () {
                  if (_servings < 20) {
                    setState(() => _servings++);
                  }
                },
                icon: const Icon(Icons.add_circle_outline),
                color: AppTheme.primaryColor,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDietarySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dietary Restrictions (Optional)',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _dietaryOptions.map((option) {
            final isSelected = _dietaryRestrictions.contains(option);
            return FilterChip(
              label: Text(option),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _dietaryRestrictions.add(option);
                  } else {
                    _dietaryRestrictions.remove(option);
                  }
                });
              },
              backgroundColor: AppTheme.surfaceColor,
              selectedColor: AppTheme.accentColor,
              checkmarkColor: AppTheme.textPrimary,
              labelStyle: TextStyle(
                color: isSelected
                    ? AppTheme.textPrimary
                    : AppTheme.textSecondary,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildGenerateButton(BuildContext context, RecipeProvider provider) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppTheme.glowShadow,
      ),
      child: ElevatedButton(
        onPressed: () => _generateRecipe(context, provider),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          minimumSize: const Size(double.infinity, 56),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.auto_awesome),
            SizedBox(width: 12),
            Text('Generate Recipe', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickPrompts(BuildContext context) {
    final prompts = [
      'Healthy breakfast bowl',
      'Quick dinner recipe',
      'Chocolate dessert',
      'Comfort food',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quick Ideas', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: prompts.map((prompt) {
            return ActionChip(
              label: Text(prompt),
              onPressed: () {
                _promptController.text = prompt;
              },
              backgroundColor: AppTheme.surfaceColor,
              labelStyle: const TextStyle(color: AppTheme.textSecondary),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildGeneratingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              gradient: AppTheme.cardGradient,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: CircularProgressIndicator(
                color: AppTheme.primaryColor,
                strokeWidth: 3,
              ),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Generating your recipe...',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'AI is crafting something delicious',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Future<void> _generateRecipe(
    BuildContext context,
    RecipeProvider provider,
  ) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final recipe = await provider.generateRecipe(
      prompt: _promptController.text,
      cuisine: _selectedCuisine,
      difficulty: _selectedDifficulty,
      servings: _servings,
      dietaryRestrictions: _dietaryRestrictions.isEmpty
          ? null
          : _dietaryRestrictions,
    );

    if (recipe != null && context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => RecipeDetailScreen(recipe: recipe),
        ),
      );
    } else if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to generate recipe. Please try again.'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    }
  }
}
