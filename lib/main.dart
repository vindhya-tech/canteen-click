import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'screens/splash_screen.dart';
import './screens/cart_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  final cartProvider = CartProvider();
  await cartProvider.loadCart();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('hi'), Locale('te')],
      path: 'assets/lang',
      fallbackLocale: const Locale('en'),
      child: ChangeNotifierProvider(
        create: (_) => cartProvider,
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Canteen Click',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: const SplashScreen(),
    );
  }
}
