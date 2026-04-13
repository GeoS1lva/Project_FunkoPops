import 'package:flutter/material.dart';
import '../app_colors.dart';
import '../widgets/custom_search_bar.dart';
import '../widgets/custom_bottom_nav.dart';
import '../widgets/custom_input.dart';
import '../widgets/custom_button.dart';

import '../../models/category_model.dart';
import '../../services/category_service.dart';
import '../../services/funko_service.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../ui/screens/funko_search_screen.dart';

class AddFunkoScreen extends StatefulWidget {
  const AddFunkoScreen({super.key});

  @override
  State<AddFunkoScreen> createState() => _AddFunkoScreenState();
}

class _AddFunkoScreenState extends State<AddFunkoScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();

  String? _selectedCategoryName;
  String _selectedRarity = "1";
  bool _isGlowInTheDark = false;
  bool _isLoading = false;

  final CategoryService _categoryService = CategoryService();
  final FunkoService _funkoService = FunkoService();
  late Future<List<CategoryModel>> _categoriesFuture;

  @override
  void initState() {
    super.initState();
    _categoriesFuture = _categoryService.fetchCategories();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _imageUrlController.dispose();
    _numberController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedCategoryName == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, selecione uma categoria.')),
        );
        return;
      }
      setState(() => _isLoading = true);
      final success = await _funkoService.createFunko({
        "name": _nameController.text,
        "categoryName": _selectedCategoryName,
        "number": int.tryParse(_numberController.text) ?? 0,
        "rarity": _selectedRarity,
        "isGlowInTheDark": _isGlowInTheDark,
        "image": _imageUrlController.text,
      });
      setState(() => _isLoading = false);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Funko cadastrado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao cadastrar Funko.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _searchImageOnGoogle() async {
    final funkoName = _nameController.text.trim();
    final query = funkoName.isNotEmpty ? '$funkoName funko pop' : 'funko pop';
    final url = Uri.parse(
      'https://www.google.com/search?tbm=isch&q=${Uri.encodeComponent(query)}',
    );
    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication))
        throw Exception('Não foi possível abrir o link');
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao abrir o navegador.'),
            backgroundColor: Colors.red,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomSearchBar(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 250),
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const FunkoSearchScreen(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                              const curve = Curves.easeOutCubic;

                              var fadeTween = Tween<double>(
                                begin: 0.0,
                                end: 1.0,
                              ).chain(CurveTween(curve: curve));
                              var scaleTween = Tween<double>(
                                begin: 0.96,
                                end: 1.0,
                              ).chain(CurveTween(curve: curve));

                              return FadeTransition(
                                opacity: animation.drive(fadeTween),
                                child: ScaleTransition(
                                  scale: animation.drive(scaleTween),
                                  child: child,
                                ),
                              );
                            },
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  'Novo Pop',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.purpleText,
                  ),
                ),
                const SizedBox(height: 16),

                _buildLabel('Nome'),
                CustomInput(
                  hint: 'Ex: Spider-Man',
                  controller: _nameController,
                  fillColor: AppColors.marvelRed,
                ),

                _buildLabel('Adicionar Imagem *'),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    border: Border.all(color: Colors.black12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.person_outline,
                        size: 80,
                        color: Colors.black26,
                      ),
                      const SizedBox(height: 12),
                      CustomButton(
                        text: 'Buscar no Google',
                        color: AppColors.searchTeal,
                        textColor: Colors.white,
                        onPressed: _searchImageOnGoogle,
                      ),
                      const SizedBox(height: 12),
                      CustomInput(
                        hint: 'Link da Imagem (Ex: https://...)',
                        controller: _imageUrlController,
                        fillColor: AppColors.searchTeal,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                _buildLabel('Categoria *'),
                FutureBuilder<List<CategoryModel>>(
                  future: _categoriesFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting)
                      return const Center(child: CircularProgressIndicator());
                    final categories = snapshot.data ?? [];
                    return DropdownButtonFormField<String>(
                      isExpanded: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.starWarsYellow,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.zero,
                      ),
                      dropdownColor: AppColors.starWarsYellow,
                      borderRadius: BorderRadius.circular(12),
                      elevation: 2,
                      icon: const Padding(
                        padding: EdgeInsets.only(right: 16.0),
                        child: Icon(
                          Icons.arrow_drop_down,
                          color: AppColors.textDark,
                          size: 28,
                        ),
                      ),
                      style: const TextStyle(
                        color: AppColors.textDark,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      hint: const Padding(
                        padding: EdgeInsets.only(left: 16.0),
                        child: Text(
                          'Selecione uma Categoria',
                          style: TextStyle(color: AppColors.textLight),
                        ),
                      ),
                      value: _selectedCategoryName,
                      items: categories
                          .map(
                            (c) => DropdownMenuItem(
                              value: c.name,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: Text(
                                  c.name,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) =>
                          setState(() => _selectedCategoryName = value),
                    );
                  },
                ),
                const SizedBox(height: 16),

                _buildLabel('Número *'),
                CustomInput(
                  hint: 'Ex: 50',
                  controller: _numberController,
                  fillColor: AppColors.tealInput,
                ),

                _buildLabel('Raridade'),
                Row(
                  children: [
                    _buildRarityButton('1'),
                    _buildRarityButton('2'),
                    _buildRarityButton('3'),
                  ],
                ),
                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Brilha no Escuro (Glow)?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.purpleText,
                      ),
                    ),
                    Switch(
                      value: _isGlowInTheDark,
                      activeThumbColor: Colors.white,
                      activeTrackColor: AppColors.navIconSelected,
                      inactiveThumbColor: Colors.white,
                      inactiveTrackColor: Colors.grey,
                      onChanged: (val) =>
                          setState(() => _isGlowInTheDark = val),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                        children: [
                          CustomButton(
                            text: 'Salvar',
                            color: AppColors.purpleButton,
                            textColor: Colors.white,
                            onPressed: _submitForm,
                          ),
                          const SizedBox(height: 12),
                          CustomButton(
                            text: 'Voltar',
                            color: AppColors.purpleButton,
                            textColor: Colors.white,
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 1),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.purpleText,
        ),
      ),
    );
  }

  Widget _buildRarityButton(String value) {
    final isSelected = _selectedRarity == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedRarity = value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.marvelRed
                : AppColors.marvelRed.withOpacity(0.5),
            border: Border.all(color: Colors.black26),
          ),
          child: Center(
            child: Text(
              '[$value]',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
