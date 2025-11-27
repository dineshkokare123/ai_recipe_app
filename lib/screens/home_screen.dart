import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../providers/recipe_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/recipe_card.dart';
import '../widgets/category_chip.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/stats_card.dart';
import '../widgets/glass_widgets.dart';
import 'recipe_detail_screen.dart';
import 'ai_generate_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            _buildAppBar(context),
            _buildSearchBar(context),
            _buildStats(context),
            _buildCategories(context),
            _buildTabBar(context),
            _buildRecipeGrid(context),
          ],
        ),
      ),
      floatingActionButton: _buildFAB(context),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI Recipe',
                      style: Theme.of(context).textTheme.displayMedium
                          ?.copyWith(
                            foreground: Paint()
                              ..shader = AppTheme.primaryGradient.createShader(
                                const Rect.fromLTWH(0, 0, 200, 70),
                              ),
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Discover & Create Amazing Recipes',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: AppTheme.cardGradient,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: AppTheme.softShadow,
                  ),
                  child: const Icon(
                    Icons.restaurant_menu,
                    color: AppTheme.primaryColor,
                    size: 28,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SearchBarWidget(
          onSearch: (query) {
            context.read<RecipeProvider>().search(query);
          },
          onClear: () {
            context.read<RecipeProvider>().clearSearch();
          },
        ),
      ),
    );
  }

  Widget _buildStats(BuildContext context) {
    return SliverToBoxAdapter(
      child: Consumer<RecipeProvider>(
        builder: (context, provider, child) {
          final stats = provider.getRecipeStats();
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: StatsCard(
                    title: 'Total',
                    value: stats['total'].toString(),
                    icon: Icons.restaurant,
                    gradient: AppTheme.primaryGradient,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatsCard(
                    title: 'Favorites',
                    value: stats['favorites'].toString(),
                    icon: Icons.favorite,
                    gradient: AppTheme.secondaryGradient,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatsCard(
                    title: 'AI Made',
                    value: stats['aiGenerated'].toString(),
                    icon: Icons.auto_awesome,
                    gradient: AppTheme.accentGradient,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategories(BuildContext context) {
    return SliverToBoxAdapter(
      child: Consumer<RecipeProvider>(
        builder: (context, provider, child) {
          final categories = ['All', ...provider.categories];

          return SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = category == 'All'
                    ? provider.selectedCategory == null
                    : provider.selectedCategory == category;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: CategoryChip(
                    label: category,
                    isSelected: isSelected,
                    onTap: () {
                      provider.setCategory(category == 'All' ? null : category);
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.surfaceColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: TabBar(
            controller: _tabController,
            indicator: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            labelColor: AppTheme.textPrimary,
            unselectedLabelColor: AppTheme.textTertiary,
            tabs: const [
              Tab(text: 'All Recipes'),
              Tab(text: 'Favorites'),
              Tab(text: 'AI Generated'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecipeGrid(BuildContext context) {
    return Consumer<RecipeProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const SliverFillRemaining(
            child: Center(
              child: CircularProgressIndicator(color: AppTheme.primaryColor),
            ),
          );
        }

        List<dynamic> recipes;
        switch (_tabController.index) {
          case 1:
            recipes = provider.favoriteRecipes;
            break;
          case 2:
            recipes = provider.displayedRecipes
                .where((r) => r.isAIGenerated)
                .toList();
            break;
          default:
            recipes = provider.displayedRecipes;
        }

        if (recipes.isEmpty) {
          return SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: AppTheme.cardGradient,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.restaurant_menu,
                      size: 64,
                      color: AppTheme.textTertiary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'No recipes yet',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Start by generating recipes with AI',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          );
        }

        return SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            delegate: SliverChildBuilderDelegate((context, index) {
              return AnimationConfiguration.staggeredGrid(
                position: index,
                duration: const Duration(milliseconds: 375),
                columnCount: 2,
                child: ScaleAnimation(
                  child: FadeInAnimation(
                    child: RecipeCard(
                      recipe: recipes[index],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                RecipeDetailScreen(recipe: recipes[index]),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            }, childCount: recipes.length),
          ),
        );
      },
    );
  }

  Widget _buildFAB(BuildContext context) {
    return GlassButton(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      borderRadius: BorderRadius.circular(30),
      gradient: LinearGradient(
        colors: [
          AppTheme.primaryGradient.colors.first.withOpacity(0.4),
          AppTheme.primaryGradient.colors.last.withOpacity(0.3),
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AIGenerateScreen()),
        );
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.auto_awesome, size: 20),
          ),
          const SizedBox(width: 12),
          const Text(
            'Generate with AI',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
