import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hikkoshi_cost_manager/screen/main_page.dart';
import 'package:hooks_riverpod/all.dart';

void main() {
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {

  Widget build(BuildContext context) {
    const locale = Locale("ja", "JP");
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Colors.blueAccent,
        scaffoldBackgroundColor: Color.fromRGBO(220, 220, 220, 1.0),
        backgroundColor: Color.fromRGBO(220, 220, 220, 1.0),
      ),
      darkTheme: ThemeData.dark(),
      home: MainPage(),
      locale: locale,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        locale,
      ],
    );
  }
}