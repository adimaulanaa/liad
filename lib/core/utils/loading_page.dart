import 'package:flutter/material.dart';
import 'package:liad/core/media/media_colors.dart';
import 'package:liad/core/media/media_res.dart';

class UIDialogLoading extends StatefulWidget {
  const UIDialogLoading({required this.text, super.key});

  final String text;

  @override
  UIDialogLoadingState createState() => UIDialogLoadingState();
}

class UIDialogLoadingState extends State<UIDialogLoading>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  late List<String> dots;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true); // Animasi berulang

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    dots = ['.', '..', '...', '....', '.....']; // Titik yang akan muncul untuk loading
  }

  @override
  void dispose() {
    _controller.dispose(); // Pastikan controller dihancurkan
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColors.primary,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Gambar tetap di atas
            Image.asset(
              MediaRes.omboarding, // Ganti dengan path gambar Anda
              width: MediaQuery.of(context).size.width * 0.22,
              height: MediaQuery.of(context).size.height * 0.1,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 8),
            // Animasi titik di bawah gambar
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                int index =
                    (_animation.value * dots.length).toInt() % dots.length;
                return Text(
                  dots[index],
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none, // Hapus underline
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
