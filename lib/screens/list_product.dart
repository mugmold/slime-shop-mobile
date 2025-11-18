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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.inbox_outlined, size: 60, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      "Belum ada produk.",
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ],
                ),
              );
            } else {
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: snapshot.data!.length,
                itemBuilder: (_, index) {
                  final product = snapshot.data![index];
                  final currentUserId = context.watch<UserProvider>().userId;
                  final isOwner = product.fields.user == currentUserId;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    clipBehavior: Clip.antiAlias,
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AspectRatio(
                            aspectRatio: 16 / 9,
                            child:
                                (product.fields.thumbnail != null &&
                                        product.fields.thumbnail!.isNotEmpty)
                                    ? Image.network(
                                      product.fields.thumbnail!,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (ctx, err, stack) => Container(
                                            color: Colors.grey[200],
                                            child: const Icon(
                                              Icons.broken_image,
                                              color: Colors.grey,
                                            ),
                                          ),
                                    )
                                    : Container(
                                      color: Colors.grey[200],
                                      child: const Icon(
                                        Icons.image_not_supported,
                                        size: 50,
                                        color: Colors.grey,
                                      ),
                                    ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        product.fields.category,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    if (product.fields.isFeatured) ...[
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.yellow[100],
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Text(
                                          "Featured!",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.yellow[800],
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 8),

                                Text(
                                  product.fields.name,
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1F2937),
                                  ),
                                ),

                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Rp${product.fields.price}",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF10B981),
                                      ),
                                    ),
                                    Text(
                                      "Stock: ${product.fields.stock}",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 8),
                                Text(
                                  product.fields.description,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),

                                if (isOwner)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 16.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                              backgroundColor: const Color(
                                                0xFFE0E7FF,
                                              ),
                                              side: BorderSide.none,
                                            ),
                                            onPressed: () {
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
                                            child: const Text(
                                              "Edit",
                                              style: TextStyle(
                                                color: Color(0xFF4338CA),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                              backgroundColor: const Color(
                                                0xFFFEE2E2,
                                              ),
                                              side: BorderSide.none,
                                            ),
                                            onPressed: () async {
                                              final response = await request
                                                  .postJson(
                                                    "https://bermulya-anugrah-slimeshop.pbp.cs.ui.ac.id/delete-product-flutter/${product.pk}/",
                                                    jsonEncode(
                                                      <String, String>{},
                                                    ),
                                                  );
                                              if (context.mounted &&
                                                  response['status'] ==
                                                      'success') {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                      "Produk dihapus!",
                                                    ),
                                                    backgroundColor: Color(
                                                      0xFF10B981,
                                                    ),
                                                  ),
                                                );
                                                setState(() {});
                                              }
                                            },
                                            child: const Text(
                                              "Delete",
                                              style: TextStyle(
                                                color: Color(0xFFB91C1C),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
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
