import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pp/pages/page_main.dart';
import 'package:pp/pages/page_multi_bus_system_designer.dart';
import 'package:pp/pages/page_system_simulator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Parallel Processing',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('fa'), // Persian
      ],
      locale: const Locale('fa'),
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.deepPurple,
        fontFamily: 'IranYekanX',
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        )
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/' : (c) => const MainPage(),
        '/designer' : (c) => const MultiBusSystemDesigner(),
        '/simulation' : (c) => const SystemSimulator(),
      },
    );
  }
}