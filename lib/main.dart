
import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/pag_filtros.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _toggleTheme() {
    setState(() {
      // alterna entre claro e escuro 
      _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData light = ThemeData(
      brightness: Brightness.light,
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFFFF8C00), brightness: Brightness.light),
      appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF1E88E5), foregroundColor: Colors.white, elevation: 1),
    );

    final ThemeData dark = ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF1E88E5), brightness: Brightness.dark),
      appBarTheme: const AppBarTheme(elevation: 1),
    );

    return MaterialApp(
      title: 'api_app',
      debugShowCheckedModeBanner: false,
      theme: light,
      darkTheme: dark,
      themeMode: _themeMode, 
     
      home: HomePage(onToggleTheme: _toggleTheme, isDarkMode: _themeMode == ThemeMode.dark),
      routes: {
        '/filters': (context) => const FilterPage(),
      },
    );
  }
}
