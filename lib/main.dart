import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:slime_shop/screens/home_page.dart';
import 'package:slime_shop/screens/login.dart';
import 'package:slime_shop/screens/register.dart';
import 'package:slime_shop/screens/shop_form.dart';
import 'package:slime_shop/screens/list_product.dart';
import 'package:slime_shop/providers/user_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF10B981),
      primary: const Color(0xFF10B981),
      secondary: const Color(0xFF059669),
      surface: const Color(0xFFF8FAFC),
    );

    return MultiProvider(
      providers: [
        Provider(
          create: (_) {
            CookieRequest request = CookieRequest();
            return request;
          },
        ),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        title: 'Slime Shop',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: colorScheme,
          scaffoldBackgroundColor: const Color(0xFFF1F5F9),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Color(0xFF1F2937),
            elevation: 0,
            surfaceTintColor: Colors.white,
            centerTitle: true,
            iconTheme: IconThemeData(color: Color(0xFF1F2937)),
            titleTextStyle: TextStyle(
              color: Color(0xFF1F2937),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          cardTheme: CardTheme(
            color: Colors.white,
            surfaceTintColor: Colors.white,
            elevation: 2,
            // ignore: deprecated_member_use
            shadowColor: Colors.black.withOpacity(0.2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.0),
              borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.0),
              borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.0),
              borderSide: const BorderSide(
                color: Color(0xFF10B981),
                width: 2.0,
              ),
            ),
          ),
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: '/login',
        routes: {
          '/': (context) => const HomePage(),
          '/login': (context) => const LoginPage(),
          '/register': (context) => const RegisterPage(),
          '/add-product': (context) => const ShopFormPage(),
          '/list-product':
              (context) =>
                  const ProductListPage(filterUser: false), // all product
          '/list-product-user':
              (context) =>
                  const ProductListPage(filterUser: true), // my product
        },
      ),
    );
  }
}
