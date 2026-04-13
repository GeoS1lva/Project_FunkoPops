import 'package:flutter/material.dart';
import '../app_colors.dart';
import '../../../ui/widgets/funko_list_card.dart';
import '../../models/funko_model.dart';
import '../../services/funko_service.dart';

class FunkoSearchScreen extends StatefulWidget {
  const FunkoSearchScreen({Key? key}) : super(key: key);

  @override
  State<FunkoSearchScreen> createState() => _FunkoSearchScreenState();
}

class _FunkoSearchScreenState extends State<FunkoSearchScreen> {
  final FunkoService _funkoService = FunkoService();
  final TextEditingController _searchController = TextEditingController();

  List<FunkoModel> _allFunkos = [];
  List<FunkoModel> _filteredFunkos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAllFunkos();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadAllFunkos() async {
    try {
      final funkos = await _funkoService.fetchAllFunkos();
      setState(() {
        _allFunkos = funkos;
        _filteredFunkos = funkos;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _filterFunkos(String query) {
    if (query.isEmpty) {
      setState(() => _filteredFunkos = _allFunkos);
      return;
    }

    final lowerCaseQuery = query.toLowerCase();
    setState(() {
      _filteredFunkos = _allFunkos.where((funko) {
        return funko.name.toLowerCase().contains(lowerCaseQuery) ||
            funko.categoryName.toLowerCase().contains(lowerCaseQuery);
      }).toList();
    });
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
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
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

                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: AppColors.navIconUnselected,
                          width: 2,
                        ),
                        gradient: const LinearGradient(
                          stops: [0.0, 0.25, 0.25, 0.50, 0.50, 0.75, 0.75, 1.0],
                          colors: [
                            AppColors.searchPurple,
                            AppColors.searchPurple,
                            AppColors.searchRed,
                            AppColors.searchRed,
                            AppColors.searchYellow,
                            AppColors.searchYellow,
                            AppColors.searchTeal,
                            AppColors.searchTeal,
                          ],
                        ),
                      ),
                      child: TextField(
                        controller: _searchController,
                        autofocus: true,
                        onChanged: _filterFunkos,
                        style: const TextStyle(
                          fontSize: 18,
                          color: AppColors.textDark,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Buscar...',
                          hintStyle: TextStyle(
                            color: AppColors.navIconUnselected,
                          ),
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.search,
                            color: AppColors.navIconUnselected,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 12.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.marvelRed,
                      ),
                    )
                  : _filteredFunkos.isEmpty
                  ? const Center(
                      child: Text(
                        'Nenhum Funko encontrado.',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textLight,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.only(bottom: 20),
                      itemCount: _filteredFunkos.length,
                      itemBuilder: (context, index) {
                        final funko = _filteredFunkos[index];
                        return FunkoListCard(
                          funko: funko,
                          borderColor: _getCycleColor(index),
                          onEditTap: () {
                            print("Editar o Pop: ${funko.name}");
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
