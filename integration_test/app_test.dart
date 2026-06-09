import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:islamic_law_reference/init/db_stub.dart'
    if (dart.library.js_interop) 'package:islamic_law_reference/init/db_web.dart'
    if (dart.library.io) 'package:islamic_law_reference/init/db_native.dart';
import 'package:islamic_law_reference/services/database_helper.dart';
import 'package:islamic_law_reference/services/notification_service.dart';
import 'package:islamic_law_reference/providers/user_provider.dart';
import 'package:islamic_law_reference/router/app_router.dart';
import 'package:islamic_law_reference/services/preload_service.dart';
import 'package:flutter/material.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('App launches with navigation shell', (tester) async {
    await initializeDatabaseFactory();
    await NotificationService.instance.init();
    DatabaseHelper.setTestDatabaseName('integration_test.db');
    final userProvider = UserProvider();
    await userProvider.init();
    await PreloadService.warmUp(userProvider);
    final router = createAppRouter(userProvider);

    await tester.pumpWidget(
      MaterialApp.router(routerConfig: router),
    );
    await tester.pumpAndSettle(const Duration(seconds: 3));

    expect(find.byType(NavigationBar), findsOneWidget);
    await DatabaseHelper().closeForTesting();
  });
}
