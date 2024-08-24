import 'package:avahan/core/providers/lang_provider.dart';
import 'package:avahan/core/providers/messaging_provider.dart';
import 'package:avahan/features/dashboard/providers/app_session_provider.dart';
import 'package:avahan/features/profile/providers/your_profile_provider.dart';
import 'package:avahan/features/providers/navigator_provider.dart';
import 'package:avahan/themes/theme.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:avahan/admin/root.dart';
import 'package:avahan/admin/routes.dart';
import 'package:avahan/config.dart';

import 'package:avahan/features/root.dart';
import 'package:avahan/features/router.dart';

// import 'package:avahan/themes/color_schemes.g.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:avahan/utils/extensions.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MyApp extends HookConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final base = ThemeData.light().textTheme;
    final provider = ref.read(appSessionProvider);

    void checkMessagingPermission() async {
      final messaging = ref.read(messagingProvider);
      NotificationSettings value = await messaging.getNotificationSettings();
      if ([AuthorizationStatus.denied, AuthorizationStatus.notDetermined]
          .contains(value.authorizationStatus)) {
        value = await messaging.requestPermission();
      }
    }

    useEffect(() {
     if(ref.read(yourProfileProvider).asData?.value == null){
       checkMessagingPermission();
     }
     return (){};
    }, []);

    final textTheme = base
        .copyWith(
          displayMedium: const TextStyle(fontWeight: FontWeight.bold),
          headlineSmall: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
          bodyMedium: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
          headlineMedium: const TextStyle(
            fontWeight: FontWeight.w900,
          ),
          titleLarge: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
          titleMedium: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
          titleSmall: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
          bodyLarge: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
          bodySmall: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
          labelLarge: const TextStyle(
            fontWeight: FontWeight.w700,
          ),
          labelMedium: const TextStyle(
            fontWeight: FontWeight.w700,
          ),
          labelSmall: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        )
        .apply(fontFamily: kIsWeb ? null : "Satoshi");

    final lang = ref.watch(langProvider);

    useOnAppLifecycleStateChange(
      (previous, current) {
        if (!kIsWeb) {
          print("${previous?.name} => ${current.name}");
          if (previous == AppLifecycleState.resumed &&
              [
                AppLifecycleState.paused,
                AppLifecycleState.detached,
                AppLifecycleState.hidden,
                AppLifecycleState.inactive
              ].contains(current)) {
            provider.endSession();
          } else if (current == AppLifecycleState.resumed &&
              [
                AppLifecycleState.paused,
                AppLifecycleState.detached,
                AppLifecycleState.hidden,
                AppLifecycleState.inactive
              ].contains(previous)) {
            provider.newSession();
          }
        }
      },
    );

    final lightColorScheme = MaterialTheme.lightScheme().toColorScheme();

    return MaterialApp(
      title: 'Avahan${Config.env == Env.prod ? "" : " (${Config.env})"}',
      debugShowCheckedModeBanner: false,
      // darkTheme: ThemeData.dark(),
      theme: ThemeData(
        colorScheme:  lightColorScheme,
        extensions: [],
        cupertinoOverrideTheme: CupertinoThemeData(
          primaryColor: lightColorScheme.primary,
        ),
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          centerTitle: true,
          surfaceTintColor: Colors.transparent,
          titleTextStyle: TextStyle(
            color: context.scheme.onSurface,
            fontSize: 18,
            fontFamily: kIsWeb ? null : "Satoshi",
            fontWeight: FontWeight.w700,
          ),
        ),
        searchBarTheme: SearchBarThemeData(
          backgroundColor: WidgetStatePropertyAll(lightColorScheme.surfaceContainerLow)
        ),
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: lightColorScheme.surface,
          surfaceTintColor: lightColorScheme.surface,
        ),
        textTheme: textTheme,
        inputDecorationTheme: InputDecorationTheme(
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.all(16),
          fillColor: const Color(
            0xFFF9F9FB,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: lightColorScheme.outline.withOpacity(0.65),
            ),
          ),
        ),
        dataTableTheme: DataTableThemeData(
          dividerThickness: 0,
          headingTextStyle: textTheme.bodySmall?.copyWith(
            fontSize: 12,
          ),
          checkboxHorizontalMargin: 8,
          headingRowHeight: 32,
          headingRowColor: MaterialStatePropertyAll(
              lightColorScheme.surfaceTint.withOpacity(0.05)),
        ),
        listTileTheme: ListTileThemeData(
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: lightColorScheme.onSurface,
            fontSize: 16,
          ),
          subtitleTextStyle: TextStyle(
              color: lightColorScheme.outline,
              fontWeight: FontWeight.w500,
              fontSize: 13),
        ),
        // outlinedButtonTheme: OutlinedButtonThemeData(
        //   style: ButtonStyle(),
        // ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(lightColorScheme.primary),
            foregroundColor:
                MaterialStatePropertyAll(lightColorScheme.onPrimary),
            shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        dialogTheme: DialogTheme(
          backgroundColor: lightColorScheme.surface,
          surfaceTintColor: lightColorScheme.surface,
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: ButtonStyle(
            // shape: MaterialStatePropertyAll(
            //   RoundedRectangleBorder(
            //     borderRadius: BorderRadius.circular(6),
            //   ),
            // ),
            padding: MaterialStatePropertyAll(
              EdgeInsets.symmetric(
                  horizontal: 16, vertical: context.large ? 16 : 12),
            ),
            textStyle: const MaterialStatePropertyAll(
              TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      navigatorKey: ref.read(navigatorProvider),
      locale: Locale(lang.name),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      onGenerateRoute: Config.isAdmin ? AdminRouter.on : AppRouter.on,
      initialRoute: Config.isAdmin ? AdminRoot.route : Root.route,
    );
  }
}


/// manage ledger
/// nearby default loan requests
/// area wise loans