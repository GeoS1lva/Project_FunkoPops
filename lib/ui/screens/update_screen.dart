import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../app_colors.dart';
import '../widgets/custom_bottom_nav.dart';
import '../widgets/custom_input.dart';
import '../widgets/custom_button.dart';

import '../../models/funko_model.dart';
import '../../models/category_model.dart';
import '../../services/category_service.dart';
import '../../services/funko_service.dart';

class UpdateScreen extends StatefulWidget {
  final FunkoModel funkoToEdit;

  const UpdateScreen({super.key, required this.funkoToEdit});

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _imageController;
  late TextEditingController _numberController;

  String? _selectedCategoryName;
  late String _selectedRarity;
  late bool _isGlowInTheDark;
  bool _isLoading = false;

  final CategoryService _categoryService = CategoryService();
  final FunkoService _funkoService = FunkoService();
  late Future<List<CategoryModel>> _categoriesFuture;

  @override
  void initState() {
    super.initState();
    _categoriesFuture = _categoryService.fetchCategories();

    _nameController = TextEditingController(text: widget.funkoToEdit.name);
    _imageController = TextEditingController(text: widget.funkoToEdit.image);
    _numberController = TextEditingController(
      text: widget.funkoToEdit.number.toString(),
    );
    _selectedCategoryName = widget.funkoToEdit.categoryName;
    _selectedRarity = widget.funkoToEdit.rarity;
    _isGlowInTheDark = widget.funkoToEdit.isGlowInTheDark;

    _imageController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _imageController.dispose();
    _nameController.dispose();
    _numberController.dispose();
    super.dispose();
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

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      final success = await _funkoService.updateFunko(
        FunkoModel(
          id: widget.funkoToEdit.id,
          name: _nameController.text,
          categoryName: _selectedCategoryName ?? '',
          number: int.tryParse(_numberController.text) ?? 0,
          rarity: _selectedRarity,
          isGlowInTheDark: _isGlowInTheDark,
          image: _imageController.text,
          createdAt: widget.funkoToEdit.createdAt,
        ),
      );
      setState(() => _isLoading = false);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pop atualizado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    }
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            "Excluir Funko?",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(
            "Tem certeza que deseja remover '${widget.funkoToEdit.name}'?",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentRed,
              ),
              onPressed: () async {
                Navigator.pop(context);
                setState(() => _isLoading = true);
                bool success = await _funkoService.deleteFunko(
                  widget.funkoToEdit.id,
                );
                if (mounted) {
                  setState(() => _isLoading = false);
                  if (success) Navigator.pop(context);
                }
              },
              child: const Text(
                "Sim, Excluir",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Edit Pop',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: AppColors.purpleText,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.delete_outline_rounded,
              color: AppColors.accentRed,
              size: 28,
            ),
            onPressed: _confirmDelete,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.black12, width: 2),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: Image.network(
                            _imageController.text,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(
                                  Icons.broken_image_rounded,
                                  size: 60,
                                  color: Colors.grey,
                                ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -10,
                        right: -10,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.primaryBlue,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 6,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.edit_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                _buildLabel('Nome'),
                CustomInput(
                  hint: 'Ex: Spider-Man',
                  controller: _nameController,
                  fillColor: AppColors.marvelRed,
                ),

                _buildLabel('Alterar Imagem'),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    border: Border.all(color: Colors.black12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      CustomButton(
                        text: 'Buscar no Google',
                        color: AppColors.searchTeal,
                        textColor: Colors.white,
                        onPressed: _searchImageOnGoogle,
                      ),
                      const SizedBox(height: 12),
                      CustomInput(
                        hint: 'Link da Imagem (Ex: https://...)',
                        controller: _imageController,
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
                            text: 'Salvar Alterações',
                            color: AppColors.purpleButton,
                            textColor: Colors.white,
                            onPressed: _submitForm,
                          ),
                          const SizedBox(height: 12),
                          CustomButton(
                            text: 'Voltar',
                            color: Colors.white,
                            textColor: AppColors.purpleText,
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
