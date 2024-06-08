import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'countdown_home_page.dart';

void main() {
WidgetsFlutterBinding.ensureInitialized();
 MobileAds.instance.initialize();  
  runApp(const CountDownApp());
}

class CountDownApp extends StatelessWidget {
  const CountDownApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
        scaffoldBackgroundColor: const Color(0xFF2B2B2B),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 10,
          ),
        ),
      ),
      home: const CountDownHomePage(),
    );
  }
}
