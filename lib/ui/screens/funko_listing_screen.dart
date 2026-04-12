import 'package:flutter/material.dart';
import '../app_colors.dart';
import '../widgets/custom_search_bar.dart';
import '../widgets/custom_bottom_nav.dart';
import '../widgets/funko_list_card.dart';
import '../../models/funko_model.dart';
import '../../services/funko_service.dart';

class FunkoListingScreen extends StatefulWidget {
  const FunkoListingScreen({Key? key}) : super(key: key);

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

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              child: Text(
                'Listagem de Pops',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
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
                        'Erro ao carregar a listagem:\n${snapshot.error}',
                        textAlign: TextAlign.center,
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('Nenhum Funko cadastrado na coleção.'),
                    );
                  }

                  final funkos = snapshot.data!;
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
      bottomNavigationBar: CustomBottomNav(
        onTabSelected: (index) {
          print("Navegar para a aba: $index");
        },
      ),
    );
  }
}
