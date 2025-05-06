import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evently_app/auth/login/login_screen.dart';
import 'package:evently_app/auth/regist/register_screen.dart';
import 'package:evently_app/providers/app_language_provider.dart';
import 'package:evently_app/providers/app_theme_provider.dart';
import 'package:evently_app/providers/event_list_providers.dart';
import 'package:evently_app/splash_screen.dart';
import 'package:evently_app/ui/home_screen.dart';
import 'package:evently_app/ui/lets_go_screen.dart';
import 'package:evently_app/ui/onboarding_screen.dart';
import 'package:evently_app/ui/tabs/home_tab/add_event/add_event_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseFirestore.instance.disableNetwork();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => AppThemeProvider()),
      ChangeNotifierProvider(create: (context) => AppLanguageProvider()),
      ChangeNotifierProvider(create: (context) => EventListProvider())
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // var languageProvider = Provider.of<AppLanguageProvider>(context);
    var themeProvider = Provider.of<AppThemeProvider>(context);
    return ChangeNotifierProvider(
      create: (_) => AppLanguageProvider(),
      child: Consumer<AppLanguageProvider>(
        builder: (context, languageProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            initialRoute: HomeScreen.routeName,
            routes: {
              SplashScreen.routeName: (context) => SplashScreen(),
              LetsGoScreen.routeName: (context) => LetsGoScreen(),
              OnboardingScreen.routeName: (context) => OnboardingScreen(),
              LoginScreen.routeName: (context) => LoginScreen(),
              RegisterScreen.routeName: (context) => RegisterScreen(),
              HomeScreen.routeName: (context) => HomeScreen(),
              AddEventScreen.routeName: (context) => AddEventScreen(),
            },
            theme: themeProvider.appTheme,
            locale: Locale(languageProvider.appLanguage),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
          );
        },
      ),
    );
  }
}
