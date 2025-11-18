import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFF10B981)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Slime Shop',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Padding(padding: EdgeInsets.all(10)),
                Text(
                  "Halo!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ],
            ),
          ),
          // opsi Halaman Utama
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Halaman Utama'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
          // opsi Tambah Produk
          ListTile(
            leading: const Icon(Icons.add_shopping_cart),
            title: const Text('Tambah Produk'),
            onTap: () {
              Navigator.pushNamed(context, '/add-product');
            },
          ),
          // opsi Daftar Produk
          ListTile(
            leading: const Icon(Icons.shopping_bag),
            title: const Text('Daftar Produk'),
            onTap: () {
              Navigator.pushNamed(context, '/list-product');
            },
          ),
          // opsi Logout
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () async {
              final response = await request.logout(
                "https://bermulya-anugrah-slimeshop.pbp.cs.ui.ac.id/auth/logout/",
              );
              String message = response["message"];
              if (context.mounted) {
                if (response['status']) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("$message Sampai jumpa!"),
                      backgroundColor: const Color(0xFF10B981),
                    ),
                  );
                  Navigator.pushReplacementNamed(context, '/login');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(message),
                      backgroundColor: Color.fromARGB(255, 197, 47, 47),
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
