import 'package:flutter/material.dart';
import 'l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'Pages/HomePage/HomePage.dart';
import 'Utils/AppLocaleController.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final localeController = AppLocaleController();
  await localeController.loadLocale();
  runApp(MyApp(localeController: localeController));
}

class MyApp extends StatelessWidget {
  final AppLocaleController localeController;

  const MyApp({super.key, required this.localeController});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: localeController,
      builder: (context, _) {
        return MaterialApp(
          title: 'EduSnap',
          debugShowCheckedModeBanner: false,
          locale: localeController.locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
          ],
          home: HomePage(localeController: localeController),
        );
      },
    );
  }
}