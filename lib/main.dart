import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:handvibe/view/page/login_pages/splashscreen.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'model_view/provider/category_provider.dart';
import 'model_view/provider/chat_provider.dart';
import 'model_view/provider/language_provider.dart';
import 'model_view/provider/product_provider.dart';
import 'model_view/provider/user_provider.dart';
import 'model_view/services/language_localizations.dart';
import 'model_view/services/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (Platform.isIOS) {
    await AppTrackingTransparency.requestTrackingAuthorization();
  }

  String langCode = await SharedPreferencesMethods().getSelectedLanguage();
  runApp(
    MyApp(
      langCode: langCode,
    ),
  );
}

class MyApp extends StatelessWidget {
  final String langCode;

  const MyApp({super.key, required this.langCode});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LanguageProvider>(create: (context) => LanguageProvider()),
        ChangeNotifierProvider<UserProvider>(create: (context) => UserProvider()),
        ChangeNotifierProvider<CategoryProvider>(create: (context) => CategoryProvider()),
        ChangeNotifierProvider<ProductProvider>(create: (context) => ProductProvider()),
        ChangeNotifierProvider<ChatProvider>(create: (context) => ChatProvider()),
      ],
      child: Consumer<LanguageProvider>(builder: (context, langProvider, widgets) {
        return MaterialApp(
          title: 'Handvibe',
          debugShowCheckedModeBanner: false,
          supportedLocales: const [
            Locale('en'),
            Locale('tr'),
          ],
          localeResolutionCallback: (locale, supportedLocales) {
            String selectedLang;
            if (langProvider.langCode != "") {
              selectedLang = langProvider.langCode;
            } else {
              selectedLang = langCode;
            }
            for (var supportedLocaleLanguage in supportedLocales) {
              if (supportedLocaleLanguage.languageCode == selectedLang) {
                return supportedLocaleLanguage;
              }
            }
            if (supportedLocales.contains(Locale(locale!.languageCode))) {
              return Locale(locale.languageCode);
            }
            return supportedLocales.first;
          },
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: SplashScreen(),
        );
      }),
    );
  }
}
