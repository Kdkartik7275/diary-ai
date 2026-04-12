import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mindloom/config/routes/app_pages.dart';

import 'package:mindloom/config/routes/app_routes.dart';
import 'package:mindloom/config/theme/theme.dart';
import 'package:mindloom/config/theme/theme_controller.dart';
import 'package:mindloom/core/di/init_dependencies.dart';
import 'package:mindloom/firebase_options.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

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

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await dotenv.load(fileName: '.env');

  DependencyInjection.init();

  // await NotificationService.instance.init();

  // await NotificationService.instance.getFcmToken();

  final initialRoute = await resolveInitialRoute();
  Get.put(ThemeController(), permanent: true);

  runApp(LifelineApp(initialRoute: initialRoute));

  FlutterNativeSplash.remove();
}

class LifelineApp extends StatelessWidget {
  const LifelineApp({super.key, required this.initialRoute});
  final String initialRoute;

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Obx(
      () => GetMaterialApp(
        title: 'Mindloom',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeController.themeMode.value,
        initialRoute: initialRoute,
        getPages: AppPages.routes,
      ),
    );
  }
}
