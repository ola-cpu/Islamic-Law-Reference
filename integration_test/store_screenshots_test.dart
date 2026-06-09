import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:integration_test/integration_test.dart';
import 'package:islamic_law_reference/init/db_stub.dart'
    if (dart.library.js_interop) 'package:islamic_law_reference/init/db_web.dart'
    if (dart.library.io) 'package:islamic_law_reference/init/db_native.dart';
import 'package:islamic_law_reference/l10n/app_localizations.dart';
import 'package:islamic_law_reference/providers/user_provider.dart';
import 'package:islamic_law_reference/router/app_router.dart';
import 'package:islamic_law_reference/services/database_helper.dart';
import 'package:islamic_law_reference/services/notification_service.dart';
import 'package:islamic_law_reference/services/preload_service.dart';
import 'package:islamic_law_reference/views/inheritance_calculator_screen.dart';
import 'package:islamic_law_reference/views/zakat_calculator_screen.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<void> capture(String name) async {
    await binding.convertFlutterSurfaceToImage();
    await binding.takeScreenshot(name);
  }

  Future<({WidgetTester tester, GoRouter router, UserProvider user})> boot(WidgetTester tester) async {
    await initializeDatabaseFactory();
    await NotificationService.instance.init();
    DatabaseHelper.setTestDatabaseName('store_screenshots.db');
    final user = UserProvider();
    await user.init();
    await user.completeOnboarding();
    await PreloadService.warmUp(user);
    final router = createAppRouter(user);
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle(const Duration(seconds: 4));
    return (tester: tester, router: router, user: user);
  }

  testWidgets('capture Play Store screenshots', (tester) async {
    final booted = await boot(tester);
    final router = booted.router;
    final l10n = lookupAppLocalizations(const Locale('fr'));

    await capture('01_home');

    await tester.tap(find.byIcon(Icons.school_outlined));
    await tester.pumpAndSettle(const Duration(seconds: 2));
    await capture('02_learn_hub');

    await tester.tap(find.text(l10n.zakatCalculator));
    await tester.pumpAndSettle(const Duration(seconds: 2));
    expect(find.byType(ZakatCalculatorScreen), findsOneWidget);
    await capture('03_zakat_calculator');
    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.tap(find.text(l10n.inheritanceCalculator));
    await tester.pumpAndSettle(const Duration(seconds: 2));
    expect(find.byType(InheritanceCalculatorScreen), findsOneWidget);
    await capture('04_inheritance_calculator');
    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle(const Duration(seconds: 2));
    await capture('05_search');

    router.go(AppRoutes.compare);
    await tester.pumpAndSettle(const Duration(seconds: 3));
    await capture('06_compare');

    router.go(AppRoutes.settings);
    await tester.pumpAndSettle(const Duration(seconds: 2));
    await capture('07_settings');

    final topic = await DatabaseHelper().getDailyTopic();
    if (topic != null) {
      router.go(AppRoutes.topic(topic.id));
      await tester.pumpAndSettle(const Duration(seconds: 3));
      await capture('08_topic_detail');
    }

    await DatabaseHelper().closeForTesting();
    DatabaseHelper.setTestDatabaseName(null);
  });
}
