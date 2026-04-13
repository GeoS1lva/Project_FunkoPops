import 'package:flutter/material.dart';
import '../app_colors.dart';
import '../widgets/funko_list_card.dart';
import '../widgets/epic_delete_dialog.dart';
import '../../models/funko_model.dart';
import '../../services/funko_service.dart';
import 'update_screen.dart';

class FunkoSearchScreen extends StatefulWidget {
  const FunkoSearchScreen({super.key});

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
    setState(() {
      _filteredFunkos = _allFunkos
          .where((f) => f.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
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
              content: Text('Excluído com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
          _loadAllFunkos();
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
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: AppColors.textDark,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: AppColors.textDark, width: 2),
                        color: Colors.white,
                      ),
                      child: TextField(
                        controller: _searchController,
                        autofocus: true,
                        onChanged: _filterFunkos,
                        decoration: const InputDecoration(
                          hintText: 'Buscar Pop...',
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.search,
                            color: AppColors.textLight,
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
                  ? const Center(child: Text('Nenhum Funko encontrado.'))
                  : ListView.builder(
                      padding: const EdgeInsets.only(bottom: 20),
                      itemCount: _filteredFunkos.length,
                      itemBuilder: (context, index) {
                        final funko = _filteredFunkos[index];
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
                            ).then((_) => _loadAllFunkos());
                          },
                          onDeleteTap: () => _showDeleteDialog(context, funko),
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
