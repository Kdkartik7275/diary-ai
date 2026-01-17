import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:lifeline/config/routes/app_routes.dart';
import 'package:lifeline/config/theme/theme.dart';
import 'package:lifeline/core/di/init_dependencies.dart';
import 'package:lifeline/firebase_options.dart';
import 'config/routes/app_pages.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    await dotenv.load(fileName: ".env");

  DependencyInjection.init();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  runApp(const LifelineApp());
}

class LifelineApp extends StatefulWidget {
  const LifelineApp({super.key});

  @override
  State<LifelineApp> createState() => _LifelineAppState();
}

class _LifelineAppState extends State<LifelineApp> {
  bool _ranOnce = false;
  final storage = FlutterSecureStorage();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_ranOnce) {
      _ranOnce = true;

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final hasCompletedOnboarding = await storage.read(
          key: 'hasCompletedOnboarding',
        );

        // 1. First time user → onboarding
        if (hasCompletedOnboarding != 'true') {
          Get.offAllNamed(Routes.onboarding);
          FlutterNativeSplash.remove();
          return;
        }

        // 2. Onboarding done → check login
        final user = FirebaseAuth.instance.currentUser;

        if (user != null) {
          // Already logged in
          Get.offAllNamed(Routes.tabs);
        } else {
          // Not logged in
          Get.offAllNamed(Routes.login);
        }

        FlutterNativeSplash.remove();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Lifeline",
      debugShowCheckedModeBanner: false,

      theme: AppTheme.lightTheme,

      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
    );
  }
}
