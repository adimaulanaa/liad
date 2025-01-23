import 'package:alarm/alarm.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:liad/core/config/config_resources.dart';
import 'package:liad/core/config/remote_config_service.dart';
import 'package:liad/core/firebase/firebase_api.dart';
import 'package:liad/core/utils/request_sound_mode.dart';
import 'package:liad/features/data/dashboard_provider.dart';
import 'package:liad/features/data/dashboard_service.dart';
import 'package:liad/features/data/notes/database_service.dart';
import 'package:liad/features/data/notes/notes_provider.dart';
import 'package:liad/features/data/notes/notes_service.dart';
import 'package:liad/features/onboarding.dart';
import 'package:liad/firebase_options.dart';
import 'package:liad/notification_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  await Alarm.init();
  // await AndroidAlarmManager.initialize();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await RemoteConfigService().initConfig();
  await FirebaseApi().initNotifications();
  await FirebaseApi().initProfile();
  await FirebaseApi().initPrays();
  await FirebaseApi().initScheduleSholat();
  final prefs = await SharedPreferences.getInstance();
  // Inisialisasi lainnya
  await requestDoNotDisturbPermission();
  // Inisialisasi NotesDatabaseService
  final notesDatabase = NotesDatabaseService();
  // runApp(const MyApp());
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => DashboardProvider(
            dataService: DashboardService(),
            prefs: prefs,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => NotesProvider(
            dataService: NotesService(),
            prefs: prefs,
            notesDatabase: notesDatabase,
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
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
      navigatorKey: navigatorKey,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: const TextScaler.linear(1),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
      routes: {
        '/onboarding': (context) => const Onboarding(),
        '/notification_screen': (context) => const NotificationScreen(),
        // Definisikan rute lain di sini jika diperlukan
      },
    );
  }
}
