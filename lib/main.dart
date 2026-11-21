import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:itchi_flutter_duo_layout/itchi_flutter_duo_layout.dart';
import 'Pages/HomePage/HomePage.dart';
import 'Utils/AppLocaleController.dart';
import 'Utils/DuoLayoutController.dart';
import 'l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final localeController = AppLocaleController();
  await localeController.loadLocale();
  runApp(MyApp(localeController: localeController));
}

class MyApp extends StatefulWidget {
  final AppLocaleController localeController;

  const MyApp({super.key, required this.localeController});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  final DuoLayoutController _duoController = DuoLayoutController();
  StreamSubscription<void>? _backSub;

  @override
  void initState() {
    super.initState();
    _duoController.init();
    _backSub = ItchiDuoSideBack.onBack.listen((_) {
      _navigatorKey.currentState?.maybePop();
    });
  }

  @override
  void dispose() {
    _backSub?.cancel();
    _duoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Session 4 Challenge：從 EduSnap 專屬 Logo 提取的 5 組主題色碼
    const primaryColor = Color(0xFF27397F); // 深靛藍（學士帽與背景主調）
    const secondaryColor = Color(0xFF1E88C9); // 天空藍（相機機身與漸層）
    const accentColor = Color(0xFFF5B027); // 暖金黃（Snap 字樣與流蘇）
    const surfaceColor = Color(0xFFDCEAF7); // 淺冰藍（卡片與底部選單底色）
    const backgroundColor = Color(0xFFF3F7FC); // 柔霧藍白（全局背景）

    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryColor,
      primary: primaryColor,
      secondary: secondaryColor,
      tertiary: accentColor,
      surface: surfaceColor,
    );

    return AnimatedBuilder(
      animation: Listenable.merge([widget.localeController, _duoController]),
      builder: (context, _) {
        return MaterialApp(
          navigatorKey: _navigatorKey,
          navigatorObservers: [_DuoRouteObserver(_duoController)],
          title: 'EduSnap',
          debugShowCheckedModeBanner: false,
          locale: widget.localeController.locale,
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
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: colorScheme,
            scaffoldBackgroundColor: backgroundColor,
            appBarTheme: const AppBarTheme(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              centerTitle: true,
            ),
            cardTheme: const CardThemeData(
              color: surfaceColor,
              elevation: 1,
            ),
            filledButtonTheme: FilledButtonThemeData(
              style: FilledButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
              ),
            ),
            outlinedButtonTheme: OutlinedButtonThemeData(
              style: OutlinedButton.styleFrom(
                foregroundColor: primaryColor,
                side: const BorderSide(color: secondaryColor),
              ),
            ),
            bottomSheetTheme: const BottomSheetThemeData(
              backgroundColor: surfaceColor,
            ),
          ),
          builder: (context, child) {
            return Container(
              width: double.infinity,
              height: double.infinity,
              padding: _duoController.isFullyOpen
                  ? EdgeInsets.zero
                  : const EdgeInsets.symmetric(horizontal: 4),
              child: child ?? const SizedBox.shrink(),
            );
          },
          home: HomePage(
            localeController: widget.localeController,
            duoController: _duoController,
          ),
        );
      },
    );
  }
}

class _DuoRouteObserver extends NavigatorObserver {
  final DuoLayoutController duoController;
  _DuoRouteObserver(this.duoController);

  void _sync(Route<dynamic>? route) {
    final canPop = route?.navigator?.canPop() ?? false;
    unawaited(duoController.updateSideBackVisibility(canPop));
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      _sync(route);

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      _sync(previousRoute);
}