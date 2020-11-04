import 'package:Shush/bloc/shush_bloc.dart';
import 'package:Shush/pages/listening_page.dart';
import 'package:Shush/pages/not_listening_page.dart';
import 'package:Shush/pages/settings_page.dart';
import 'package:Shush/provider/theme_provider.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (_) {
      runApp(
        EasyLocalization(
          child: MyApp(),
          path: "lib/assets/localization",
          saveLocale: true,
          supportedLocales: [
            Locale('hr', 'HR'),
            Locale('en', 'GB'),
            Locale('it', 'IT'),
            Locale('es', 'ES'),
            Locale('fr', 'FR'),
            Locale('de', 'DE'),
          ],
        ),
      );
    },
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ShushBloc _shushBloc = ShushBloc();

  @override
  void initState() {
    super.initState();
    _shushBloc.init();
    _shushBloc.add(ShushStartListening());
  }

  @override
  void dispose() {
    _shushBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: Consumer<ThemeNotifier>(
        builder: (context, ThemeNotifier notifier, child) {
          return BlocProvider(
            create: (context) => _shushBloc,
            child: MaterialApp(
              title: 'Shush',
              theme: notifier.darkTheme ? dark : light,
              initialRoute: '/',
              routes: {
                '/': (context) => NotListeningPage(),
                '/second': (context) => ListeningPage(),
                '/settings': (context) => SettingsPage(),
              },
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
            ),
          );
        },
      ),
    );
  }
}
