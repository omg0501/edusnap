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
    // Session 4 Challenge：可替換為你個人 Logo 提取的 5 個專屬色碼
    const primaryColor = Color(0xFF025928);
    const secondaryColor = Color(0xFFF25D27);
    const accentColor = Color(0xFFD9653B);
    const surfaceColor = Color(0xFFF2B29B);
    const backgroundColor = Color(0xFFF2F2F2);

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
            bottomSheetTheme: const BottomSheetThemeData(
              backgroundColor: surfaceColor,
            ),
          ),
          builder: (context, child) {
            // 監聽折疊狀態：當完全展開 (fullyOpen) 時使用全螢幕布局
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

/// 自動偵測目前是否在子頁面，決定是否顯示右側邊欄的原生返回按鈕
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