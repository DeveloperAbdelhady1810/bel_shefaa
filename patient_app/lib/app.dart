import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/services/notification_service.dart';
import 'core/theme/app_theme.dart';

class BelShefaaPatientApp extends ConsumerWidget {
  const BelShefaaPatientApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    // Handle terminated-app notification tap after first frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      NotificationService.checkInitialMessage();
    });

    // Navigate when a notification tap fires while app is running.
    ref.listen(notificationPendingRouteProvider, (_, route) {
      if (route != null) {
        router.go(route);
        ref.read(notificationPendingRouteProvider.notifier).state = null;
      }
    });

    return MaterialApp.router(
      title: 'Quota',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar'), Locale('en')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: router,
    );
  }
}
