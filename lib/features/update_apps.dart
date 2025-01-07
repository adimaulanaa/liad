import 'package:flutter/material.dart';
import 'package:liad/core/config/config_service.dart';
import 'package:liad/core/config/remote_config_service.dart';
import 'package:liad/core/media/media_colors.dart';
import 'package:liad/core/media/media_res.dart';
import 'package:liad/core/media/media_text.dart';
import 'package:liad/core/utils/version.dart';
import 'package:liad/features/presentation/dashboard_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateApps extends StatefulWidget {
  const UpdateApps({super.key});

  @override
  State<UpdateApps> createState() => _UpdateAppsState();
}

class _UpdateAppsState extends State<UpdateApps> {
  String remoteVersion = '-';
  String appVersion = '-';
  String link = ConfigService.linkUpdateApp;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    remoteVersion = RemoteConfigService().version;
    appVersion = await getVersion();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      // backgroundColor: AppColors.bgMain,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.bgMain, // Biru (ganti dengan warna biru Anda)
              Colors.white, // Putih
            ],
          ),
        ),
        child: Center(
          child: Column(
            children: [
              SizedBox(height: size.height * 0.3),
              Image.asset(
                MediaRes.omboarding, // Ganti dengan path gambar Anda
                width: size.width * 0.22,
                height: size.height * 0.1,
                fit: BoxFit.contain,
              ),
              SizedBox(height: size.height * 0.1),
              Text(
                ConfigService.titleUpdateApp,
                style: blackTextstyle.copyWith(
                  fontSize: 19,
                  fontWeight: bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '$appVersion to $remoteVersion',
                style: blackTextstyle.copyWith(
                  fontSize: 13,
                  fontWeight: medium,
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: Text(
                  ConfigService.subTitleUpdateApp,
                  textAlign: TextAlign.center,
                  style: blackTextstyle.copyWith(
                    fontSize: 13,
                    fontWeight: medium,
                  ),
                ),
              ),
              const Spacer(),
              InkWell(
                splashFactory: NoSplash.splashFactory,
                highlightColor: Colors.transparent,
                onTap: () {
                  launchURL();
                },
                child: Container(
                  width: MediaQuery.of(context).size.width - 32,
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.primary,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      'Perbarui Sekarang',
                      style: blackTextstyle.copyWith(
                        fontSize: 15,
                        fontWeight: medium,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              InkWell(
                splashFactory: NoSplash.splashFactory,
                highlightColor: Colors.transparent,
                onTap: () {
                  Navigator.pushReplacement(
                    // ignore: use_build_context_synchronously
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DashboardScreen()),
                  );
                },
                child: Container(
                  width: MediaQuery.of(context).size.width - 32,
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.primary,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      'Nanti Saja',
                      style: blackTextstyle.copyWith(
                        fontSize: 15,
                        fontWeight: medium,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.08),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> launchURL() async {
    final Uri url = Uri.parse(link);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw "Tidak dapat membuka tautan: $link";
    }
  }
}
