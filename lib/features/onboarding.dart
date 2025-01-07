import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:liad/core/config/remote_config_service.dart';
import 'package:liad/core/media/media_res.dart';
import 'package:liad/core/media/media_colors.dart';
import 'package:liad/core/utils/version.dart';
import 'package:liad/features/presentation/dashboard_screen.dart';
import 'package:liad/features/update_apps.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  /// Initializes the app by checking the version and navigating to the appropriate screen.
  Future<void> _initializeApp() async {
    // Fetch remote and local app versions
    final String remoteVersion = RemoteConfigService().version;
    final String appVersion = await getVersion();

    // Check if an update is needed
    final bool isUpdateRequired = appVersion != remoteVersion;

    // Set immersive mode for the app
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    // Navigate to the appropriate screen after a delay
    await Future.delayed(const Duration(seconds: 4));

    final Widget targetScreen =
        isUpdateRequired ? const UpdateApps() : const DashboardScreen();

    if (context.mounted) {
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => targetScreen),
      );
    }
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
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
