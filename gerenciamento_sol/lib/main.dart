import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gerenciamento_sol/presentation/home/home_screen.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  initializeDateFormatting('pt_BR', null);
  
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gerenciamento Sol',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8F9FA), // Um branco levemente acinzentado
        fontFamily: 'Inter', // Uma fonte comum em designs modernos, o Flutter buscará uma parecida

      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF5A67D8), // Um roxo/azulado sutil para gerar a paleta
        background: const Color(0xFFF8F9FA),
        surface: Colors.white, // Cor dos cards
        primary: const Color(0xFF1A202C), // Cor dos botões e textos principais (cinza bem escuro)
        secondary: const Color(0xFF4A5568), // Cor de textos secundários
        error: const Color(0xFFE53E3E), // Vermelho para gastos (ex: text-red-600)
      ),

      cardTheme: CardTheme(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFFF8F9FA),
        elevation: 0,
        titleTextStyle: const TextStyle(
          color: Color(0xFF1A202C),
          fontSize: 22,
          fontWeight: FontWeight.bold,
          fontFamily: 'Inter',
        ),
        iconTheme: const IconThemeData(color: Color(0xFF1A202C)),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFEDF2F7),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        labelStyle: const TextStyle(color: Color(0xFF4A5568)),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1A202C),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Inter',
          ),
        ),
      ),
    ),
      home: const HomePage(),
    );
  }
}