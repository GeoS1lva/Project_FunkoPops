import 'package:flutter/material.dart';
import '../app_colors.dart';
import '../widgets/custom_search_bar.dart';
import '../widgets/custom_bottom_nav.dart';
import '../widgets/custom_fab_menu.dart';
import '../widgets/funko_list_card.dart';
import '../../models/funko_model.dart';
import '../../services/funko_service.dart';
import '../../../ui/screens/funko_search_screen.dart';

class FunkoListingScreen extends StatefulWidget {
  // NOVO: Parâmetro opcional para filtrar a categoria
  final String? categoryFilter;

  const FunkoListingScreen({Key? key, this.categoryFilter}) : super(key: key);

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
    // Verifica se estamos no modo "Filtro de Categoria"
    final isFiltering = widget.categoryFilter != null;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: CustomSearchBar(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FunkoSearchScreen(),
                    ),
                  );
                },
              ),
            ),

            // CABEÇALHO ATUALIZADO COM BOTÃO DE VOLTAR
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 8.0,
              ),
              child: Row(
                children: [
                  // Se estiver filtrando, mostra o botão de voltar
                  if (isFiltering) ...[
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.searchTeal.withOpacity(
                            0.2,
                          ), // Fundo suave pastel
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
                  // Título dinâmico
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
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.navIconSelected,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Erro: ${snapshot.error}',
                        textAlign: TextAlign.center,
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('Nenhum Funko cadastrado.'),
                    );
                  }

                  // LOGICA DE FILTRO AQUI
                  var funkos = snapshot.data!;

                  if (isFiltering) {
                    // Pega apenas os pops onde o categoryName é igual ao nome da categoria clicada
                    funkos = funkos
                        .where((f) => f.categoryName == widget.categoryFilter)
                        .toList();
                  }

                  // Mensagem caso a categoria esteja vazia
                  if (funkos.isEmpty) {
                    return Center(
                      child: Text(
                        'Nenhum Funko encontrado\nna categoria ${widget.categoryFilter}.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.textLight,
                          fontSize: 16,
                        ),
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
                          print("Editar o Pop: ${funko.name}");
                        },
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
      bottomNavigationBar: CustomBottomNav(
        onTabSelected: (index) {
          print("Navegar para a aba: $index");
        },
      ),
    );
  }
}
