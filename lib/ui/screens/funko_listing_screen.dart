import 'package:flutter/material.dart';
import '../app_colors.dart';
import '../widgets/custom_search_bar.dart';
import '../widgets/custom_bottom_nav.dart';
import '../widgets/custom_fab_menu.dart';
import '../widgets/funko_list_card.dart';
import '../widgets/epic_delete_dialog.dart';
import '../../models/funko_model.dart';
import '../../services/funko_service.dart';
import 'funko_search_screen.dart';
import 'update_screen.dart';

class FunkoListingScreen extends StatefulWidget {
  final String? categoryFilter;

  const FunkoListingScreen({super.key, this.categoryFilter});

  @override
  State<FunkoListingScreen> createState() => _FunkoListingScreenState();
}

class _FunkoListingScreenState extends State<FunkoListingScreen> {
  final FunkoService _funkoService = FunkoService();
  late Future<List<FunkoModel>> _allFunkosFuture;

  @override
  void initState() {
    super.initState();
    _allFunkosFuture = _funkoService.fetchAllFunkos();
  }

  void _showDeleteDialog(BuildContext context, FunkoModel funko) {
    EpicDeleteDialog.show(
      context,
      funkoName: funko.name,
      funkoImage: funko.image,
      onCancel: () => Navigator.pop(context),
      onConfirm: () async {
        Navigator.pop(context);
        bool success = await _funkoService.deleteFunko(funko.id);
        if (success && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Pop removido da coleção!'),
              backgroundColor: Colors.green,
            ),
          );
          setState(() {
            _allFunkosFuture = _funkoService.fetchAllFunkos();
          });
        }
      },
    );
  }

  Color _getCycleColor(int index) {
    final colors = [
      AppColors.marvelRed,
      AppColors.starWarsYellow,
      AppColors.dcBlue,
    ];
    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final isFiltering = widget.categoryFilter != null;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: CustomSearchBar(),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 8.0,
              ),
              child: Row(
                children: [
                  if (isFiltering) ...[
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.searchTeal.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.searchTeal,
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: AppColors.textDark,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                  ],
                  Expanded(
                    child: Text(
                      isFiltering
                          ? 'Pops: ${widget.categoryFilter}'
                          : 'Listagem de Pops',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                        height: 1.1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: FutureBuilder<List<FunkoModel>>(
                future: _allFunkosFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Center(child: Text('Erro ao carregar dados.'));
                  }

                  final allFunkos = snapshot.data ?? [];
                  final funkos = widget.categoryFilter != null
                      ? allFunkos
                            .where(
                              (f) => f.categoryName == widget.categoryFilter,
                            )
                            .toList()
                      : allFunkos;

                  if (funkos.isEmpty) {
                    return Center(
                      child: Text(
                        'Nenhum Funko encontrado na categoria ${widget.categoryFilter ?? "Geral"}.',
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.only(bottom: 20),
                    itemCount: funkos.length,
                    itemBuilder: (context, index) {
                      final funko = funkos[index];
                      return FunkoListCard(
                        funko: funko,
                        borderColor: _getCycleColor(index),
                        onEditTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  UpdateScreen(funkoToEdit: funko),
                            ),
                          ).then(
                            (_) => setState(() {
                              _allFunkosFuture = _funkoService.fetchAllFunkos();
                            }),
                          );
                        },
                        onDeleteTap: () => _showDeleteDialog(context, funko),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: const CustomFabMenu(),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 1),
    );
  }
}
