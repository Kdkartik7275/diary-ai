import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:lifeline/config/routes/app_routes.dart';
import 'package:lifeline/config/theme/theme.dart';
import 'package:lifeline/core/di/init_dependencies.dart';
import 'package:lifeline/firebase_options.dart';
import 'config/routes/app_pages.dart';

Future<String> resolveInitialRoute() async {
  const storage = FlutterSecureStorage();
  final user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    return Routes.tabs;
  }

  final hasCompletedOnboarding = await storage.read(
    key: 'hasCompletedOnboarding',
  );

  if (hasCompletedOnboarding != 'true') {
    return Routes.onboarding;
  }

  return Routes.login;
}

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await dotenv.load(fileName: ".env");

  DependencyInjection.init();

  final initialRoute = await resolveInitialRoute();

  runApp(LifelineApp(initialRoute: initialRoute));

  FlutterNativeSplash.remove();
}

class LifelineApp extends StatelessWidget {
  final String initialRoute;

  const LifelineApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Lifeline",
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: initialRoute,
      getPages: AppPages.routes,
    );
  }
}
