import 'package:flutter/material.dart';
import '../app_colors.dart';
import 'custom_button.dart';

class EpicDeleteDialog extends StatelessWidget {
  final String funkoName;
  final String funkoImage;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const EpicDeleteDialog({
    super.key,
    required this.funkoName,
    required this.funkoImage,
    required this.onConfirm,
    required this.onCancel,
  });

  static void show(
    BuildContext context, {
    required String funkoName,
    required String funkoImage,
    required VoidCallback onConfirm,
    required VoidCallback onCancel,
  }) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black87,
      transitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (context, anim1, anim2) => const SizedBox.shrink(),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.7, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
            ),
            child: EpicDeleteDialog(
              funkoName: funkoName,
              funkoImage: funkoImage,
              onConfirm: onConfirm,
              onCancel: onCancel,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
        decoration: BoxDecoration(
          color: AppColors.accentRed,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.black, width: 3),
          boxShadow: const [
            BoxShadow(color: Colors.black, offset: Offset(4, 6), blurRadius: 0),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'EXCLUIR POP?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: AppColors.starWarsYellow,
                letterSpacing: 1.5,
                shadows: [Shadow(color: Colors.black, offset: Offset(2, 2))],
              ),
            ),
            const SizedBox(height: 24),

            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black, width: 3),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 4),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(70),
                child: Image.network(
                  funkoImage,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stack) => const Icon(
                    Icons.broken_image,
                    size: 50,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  height: 1.3,
                  fontWeight: FontWeight.w500,
                ),
                children: [
                  const TextSpan(text: 'Você está prestes a remover\n'),
                  TextSpan(
                    text: '"${funkoName.toUpperCase()}"\n',
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 22,
                      color: AppColors.starWarsYellow,
                    ),
                  ),
                  const TextSpan(text: 'Esta ação não pode ser desfeita.'),
                ],
              ),
            ),
            const SizedBox(height: 32),

            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'CANCELAR',
                    color: Colors.white,
                    textColor: AppColors.textDark,
                    onPressed: onCancel,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomButton(
                    text: 'EXCLUIR',
                    color: AppColors.textDark,
                    textColor: Colors.white,
                    onPressed: onConfirm,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
