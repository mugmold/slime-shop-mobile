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
        theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
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
