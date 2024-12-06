import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:liad/core/media/media_res.dart';
import 'package:liad/core/media/media_colors.dart';
import 'package:liad/features/presentation/dashboard_screen.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    Future.delayed(const Duration(seconds: 4), () {
     Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
            builder: (context) => const DashboardScreen(), 
          ),
        );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgMain,
      body: Center(
        child: Image.asset(
          MediaRes.omboarding, // Ganti dengan path gambar Anda
          width: MediaQuery.of(context).size.width * 0.22,
          height: MediaQuery.of(context).size.height * 0.1,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
