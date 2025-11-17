import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:slime_shop/models/product.dart';
import 'package:slime_shop/screens/detail_product.dart';
import 'package:slime_shop/widgets/left_drawer.dart';
import 'package:slime_shop/providers/user_provider.dart';
import 'package:slime_shop/screens/shop_form.dart';

class ProductListPage extends StatefulWidget {
  final bool filterUser;
  const ProductListPage({super.key, this.filterUser = false});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  Future<List<Product>> fetchProduct(CookieRequest request) async {
    String url = 'https://bermulya-anugrah-slimeshop.pbp.cs.ui.ac.id/json/';

    if (widget.filterUser) {
      url += '?filter=my';
    }

    final response = await request.get(url);

    List<Product> listProduct = [];
    for (var d in response) {
      if (d != null) {
        listProduct.add(Product.fromJson(d));
      }
    }
    return listProduct;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.filterUser ? 'My Products' : 'All Products'),
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder(
        future: fetchProduct(request),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  "Belum ada produk.",
                  style: TextStyle(color: Color(0xff59A5D8), fontSize: 20),
                ),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (_, index) {
                  final product = snapshot.data![index];
                  final currentUserId =
                      context
                          .watch<UserProvider>()
                          .userId; // ambil current user id yang sdng login
                  final isOwner =
                      product.fields.user ==
                      currentUserId; // cek apakah pemilik product
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    DetailProductPage(product: product),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (product.fields.thumbnail != null &&
                                product.fields.thumbnail!.isNotEmpty)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  product.fields.thumbnail!,
                                  height: 150,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (ctx, err, stack) => const SizedBox(),
                                ),
                              ),
                            const SizedBox(height: 10),
                            Text(
                              product.fields.name,
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text("Rp${product.fields.price}"),
                            const SizedBox(height: 10),
                            Text(product.fields.description),
                            const SizedBox(height: 10),
                            if (product.fields.isFeatured)
                              Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Colors.yellow[700],
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: const Text(
                                  "Featured!",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),

                            if (isOwner)
                              Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.orange,
                                      ),
                                      onPressed: () {
                                        // navigasi ke Form dengan membawa data product
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) => ShopFormPage(
                                                  product: product,
                                                ),
                                          ),
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () async {
                                        // panggil endpoint delete
                                        final response = await request.postJson(
                                          "https://bermulya-anugrah-slimeshop.pbp.cs.ui.ac.id/delete-product-flutter/${product.pk}/",
                                          jsonEncode(
                                            <String, String>{},
                                          ), // Body kosong gpp
                                        );

                                        if (context.mounted) {
                                          if (response['status'] == 'success') {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  "Produk dihapus!",
                                                ),
                                              ),
                                            );
                                            setState(() {}); // refresh list
                                          }
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          }
        },
      ),
    );
  }
}
