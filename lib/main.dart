import 'package:evently_app/providers/app_language_provider.dart';
import 'package:evently_app/providers/app_theme_provider.dart';
import 'package:evently_app/providers/auth_provider.dart';
import 'package:evently_app/providers/event_list_providers.dart';
import 'package:evently_app/providers/user_provider.dart';
import 'package:evently_app/ui/auth/register/register_screen.dart';
import 'package:evently_app/ui/lets_go/settings_view_model.dart';
import 'package:evently_app/ui/splash_screen.dart';
import 'package:evently_app/ui/auth/login/login_screen.dart';
import 'package:evently_app/ui/home_screen.dart';
import 'package:evently_app/ui/lets_go/lets_go_screen.dart';
import 'package:evently_app/ui/Onboarding/onboarding_screen.dart';
import 'package:evently_app/ui/tabs/home_tab/add_event/add_event_screen.dart';
import 'package:evently_app/ui/tabs/home_tab/edit_event/edit_event_screen.dart';
import 'package:evently_app/ui/tabs/home_tab/event_details/event_details_screen.dart';
import 'package:evently_app/ui/tabs/home_tab/location_picker/location_picker_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await NotificationManager.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => AppThemeProvider()),
      ChangeNotifierProvider(create: (context) => AppLanguageProvider()),
      ChangeNotifierProvider(create: (context) => AuthProvider()),
      ChangeNotifierProvider(create: (context) => UserProvider()),
      ChangeNotifierProvider(
        create: (context) => EventListProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => SettingsViewModel.of(context),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var languageProvider = Provider.of<AppLanguageProvider>(context);
    var themeProvider = Provider.of<AppThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: LoginScreen.routeName,
      routes: {
        SplashScreen.routeName: (context) => SplashScreen(),
        LetsGoScreen.routeName: (context) => LetsGoScreen(),
        OnboardingScreen.routeName: (context) => OnboardingScreen(),
        LoginScreen.routeName: (context) => LoginScreen(),
        RegisterScreen.routeName: (context) => RegisterScreen(),
        HomeScreen.routeName: (context) => HomeScreen(),
        AddEventScreen.routeName: (context) => AddEventScreen(),
        LocationPickerScreen.routeName: (context) => LocationPickerScreen(),
        EventDetailsScreen.routeName: (context) => EventDetailsScreen(),
        EditEventScreen.routeName: (context) => EditEventScreen(),
      },
      theme: themeProvider.appTheme,
      themeAnimationCurve: Curves.fastOutSlowIn,
      themeAnimationDuration: const Duration(milliseconds: 1500),
      locale: Locale(languageProvider.appLanguage),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
