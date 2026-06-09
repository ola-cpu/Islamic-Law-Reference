import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'init/db_stub.dart'
    if (dart.library.js_interop) 'init/db_web.dart'
    if (dart.library.io) 'init/db_native.dart';
import 'theme/app_theme.dart';
import 'providers/user_provider.dart';
import 'l10n/app_localizations.dart';
import 'router/app_router.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDatabaseFactory();
  await NotificationService.instance.init();

  final userProvider = UserProvider();
  await userProvider.init();
  await userProvider.syncDailyReminder();

  final router = createAppRouter(userProvider);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: userProvider),
      ],
      child: MyApp(router: router),
    ),
  );
}

class MyApp extends StatelessWidget {
  final GoRouter router;

  const MyApp({super.key, required this.router});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return MaterialApp.router(
          routerConfig: router,
          locale: userProvider.locale,
          themeMode: userProvider.themeMode,
          onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
          theme: AppThemes.light,
          darkTheme: AppThemes.dark,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
        );
      },
    );
  }
}
