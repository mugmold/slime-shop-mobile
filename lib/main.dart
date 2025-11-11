import 'package:flutter/material.dart';
import 'package:slime_shop/screens/home_page.dart';
import 'package:slime_shop/screens/shop_form.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Slime Shop',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,

      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/add-product': (context) => const ShopFormPage(),
      },
    );
  }
}
