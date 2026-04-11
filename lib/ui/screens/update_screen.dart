import 'package:flutter/material.dart';
import '../../models/funko_pop.dart';
import '../app_colors.dart';
import '../widgets/custom_input.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_label.dart';

class UpdateScreen extends StatefulWidget {
  final FunkoPop funkoToEdit;
  const UpdateScreen({super.key, required this.funkoToEdit});

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  late TextEditingController _nameController;
  late TextEditingController _categoryController;
  late TextEditingController _priceController;
  late TextEditingController _quantityController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.funkoToEdit.name);
    _categoryController = TextEditingController(
      text: widget.funkoToEdit.category,
    );
    _priceController = TextEditingController(
      text: widget.funkoToEdit.price.toStringAsFixed(2),
    );
    _quantityController = TextEditingController(
      text: widget.funkoToEdit.quantity.toString(),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    super.dispose();
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
            fontWeight: FontWeight.w900,
            color: Colors.black,
            fontSize: 26,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Icon(
              Icons.notifications_none_rounded,
              color: AppColors.notifPurple,
              size: 28,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 10),

              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 220,
                      height: 220,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.black, width: 2),
                        image: const DecorationImage(
                          image: NetworkImage(
                            'https://m.media-amazon.com/images/I/71uBfD1pS0L._AC_SL1500_.jpg',
                          ),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () => print("Upload clicado"),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.uploadButtonDarkGreen,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                            boxShadow: [
                              BoxShadow(color: Colors.black26, blurRadius: 10),
                            ],
                          ),
                          child: const Icon(
                            Icons.camera_alt_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              const CustomLabel(text: "Nome do Personagem"),
              CustomInput(
                hint: "Nome",
                controller: _nameController,
                fillColor: AppColors.tealInputBg,
              ),

              const SizedBox(height: 16),

              const CustomLabel(text: "Categoria"),
              CustomInput(
                hint: "Categoria",
                controller: _categoryController,
                fillColor: AppColors.accentYellow,
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomLabel(text: "Preço"),
                        CustomInput(
                          hint: "0.00",
                          controller: _priceController,
                          fillColor: AppColors.priceInputBg,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomLabel(text: "Estoque"),
                        CustomInput(
                          hint: "0",
                          controller: _quantityController,
                          fillColor: AppColors.tealInputBg,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              CustomButton(
                text: 'SALVAR ALTERAÇÕES',
                color: AppColors.saveButtonPurple,
                textColor: Colors.white,
                onPressed: () => print("Salvo!"),
              ),

              const SizedBox(height: 12),

              TextButton.icon(
                onPressed: () => print("Coletado!"),
                icon: const Icon(
                  Icons.auto_awesome_rounded,
                  color: AppColors.coletarButtonGreen,
                ),
                label: const Text(
                  "Adicionar à Coleção Rápida",
                  style: TextStyle(
                    color: AppColors.coletarButtonGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
