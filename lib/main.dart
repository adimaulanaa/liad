import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:liad/core/config/config_resources.dart';
import 'package:liad/features/onboarding.dart';
import 'package:liad/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    theme: ThemeData(
          fontFamily: 'Josefin Sans', // Mengatur font default untuk aplikasi
        ),
        title: StringResources.nameApp,
        initialRoute: '/onboarding',
        // getPages: AppPages.routes,
        // unknownRoute: AppPages.routes.first,
        debugShowCheckedModeBanner: false, // Menyembunyikan banner debug
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: const TextScaler.linear(1),
            ),
            child: child ?? const SizedBox.shrink(),
          );
        },
        routes: {
          '/onboarding': (context) =>
              const Onboarding(), // Ganti dengan widget Onboarding
          // Definisikan rute lain di sini jika diperlukan
        },
      );
  }
}

