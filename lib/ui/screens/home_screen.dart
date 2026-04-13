import 'package:flutter/material.dart';
import '../app_colors.dart';
import '../widgets/category_card.dart';
import '../widgets/funko_card.dart';
import '../widgets/custom_bottom_nav.dart';
import '../widgets/custom_fab_menu.dart';
import '../widgets/custom_search_bar.dart';
import '../../models/category_model.dart';
import '../../models/funko_model.dart';
import '../../services/category_service.dart';
import '../../services/funko_service.dart';
import '../../../ui/screens/funko_listing_screen.dart';
import '../../../ui/screens/funko_search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CategoryService _categoryService = CategoryService();
  final FunkoService _funkoService = FunkoService();

  late Future<List<CategoryModel>> _categoriesFuture;
  late Future<List<FunkoModel>> _funkosFuture;

  @override
  void initState() {
    super.initState();
    _categoriesFuture = _categoryService.fetchCategories();
    _funkosFuture = _funkoService.fetchLatestFunkos();
  }

  Color _getCycleColor(int index) {
    final colors = [
      AppColors.marvelRed,
      AppColors.starWarsYellow,
      AppColors.dcBlue,
    ];
    return colors[index % colors.length];
  }

  String _getRelativeTimeText(int createdAt) {
    final now = DateTime.now();
    final date = DateTime.fromMillisecondsSinceEpoch(createdAt * 1000);

    final difference = now.difference(date).inDays;

    if (difference <= 0) return 'Novo';
    if (difference == 1) return 'Ontem';
    if (difference < 7) return '$difference dias atrás';
    return 'Esta semana';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomSearchBar(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FunkoSearchScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),

              const Text(
                'Categorias',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 16),

              FutureBuilder<List<CategoryModel>>(
                future: _categoriesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.marvelRed,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text(
                      'Erro ao carregar: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text(
                      'Nenhuma categoria cadastrada.',
                      style: TextStyle(color: AppColors.textLight),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final category = snapshot.data![index];
                      return CategoryCard(
                        category: category,
                        backgroundColor: _getCycleColor(index),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FunkoListingScreen(
                                categoryFilter: category.name,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),

              const SizedBox(height: 24),
              const Text(
                'Últimos Adicionados',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 24),

              FutureBuilder<List<FunkoModel>>(
                future: _funkosFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.marvelRed,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text(
                      'Erro ao carregar: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text(
                      'Nenhum Funko adicionado recentemente.',
                      style: TextStyle(color: AppColors.textLight),
                    );
                  }

                  final funkos = snapshot.data!;

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 30,
                          childAspectRatio: 0.75,
                        ),
                    itemCount: funkos.length,
                    itemBuilder: (context, index) {
                      final funko = funkos[index];
                      final color = _getCycleColor(index);
                      final timeText = _getRelativeTimeText(funko.createdAt);

                      return FunkoCard(
                        funko: funko,
                        borderColor: color,
                        badgeText: timeText,
                        badgeColor: color,
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),

      floatingActionButton: const CustomFabMenu(),

      bottomNavigationBar: CustomBottomNav(
        onTabSelected: (index) {
          print("Navegar para a aba: $index");
        },
      ),
    );
  }
}
