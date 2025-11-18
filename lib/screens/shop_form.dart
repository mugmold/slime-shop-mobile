import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:slime_shop/models/product.dart';

class ShopFormPage extends StatefulWidget {
  final Product? product;

  const ShopFormPage({super.key, this.product});

  @override
  State<ShopFormPage> createState() => _ShopFormPageState();
}

class _ShopFormPageState extends State<ShopFormPage> {
  // buat identifikasi dan validasi form
  final _formKey = GlobalKey<FormState>();

  // controller untuk setiap input field
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _thumbnailController = TextEditingController();
  final _categoryController = TextEditingController();

  // variabel buat nyimpen state Switch (isFeatured)
  bool _isFeatured = false;

  bool _isLoading = false;

  @override
  void dispose() {
    // dispose controller setelah tidak digunakan (atasi memory leaks)
    _nameController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _descriptionController.dispose();
    _thumbnailController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    if (widget.product != null) {
      _nameController.text = widget.product!.fields.name;
      _priceController.text = widget.product!.fields.price.toString();
      _stockController.text = widget.product!.fields.stock.toString();
      _descriptionController.text = widget.product!.fields.description;
      _categoryController.text = widget.product!.fields.category;
      _thumbnailController.text = widget.product!.fields.thumbnail ?? "";
      _isFeatured = widget.product!.fields.isFeatured;
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? 'Create Product' : 'Edit Product'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: "Nama Produk",
                  labelText: "Nama Produk",
                  border: OutlineInputBorder(),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Nama tidak boleh kosong!";
                  }
                  if (value.length > 50) {
                    return "Nama tidak boleh lebih dari 50 karakter!";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  hintText: "Harga",
                  labelText: "Harga",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number, // keyboard khusus angka
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Harga tidak boleh kosong!";
                  }
                  if (int.tryParse(value) == null) {
                    return "Harga harus berupa angka!";
                  }
                  if (int.parse(value) < 0) {
                    return "Harga tidak boleh negatif!";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              TextFormField(
                controller: _stockController,
                decoration: const InputDecoration(
                  hintText: "Stock",
                  labelText: "Stock",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Stock tidak boleh kosong!";
                  }
                  if (int.tryParse(value) == null) {
                    return "Stock harus berupa angka!";
                  }
                  if (int.parse(value) < 0) {
                    return "Stock tidak boleh negatif!";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  hintText: "Deskripsi (Opsional)",
                  labelText: "Deskripsi (Opsional)",
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (String? value) {
                  if (value != null && value.length > 200) {
                    return "Deskripsi tidak boleh lebih dari 200 karakter!";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(
                  hintText: "Kategori",
                  labelText: "Kategori",
                  border: OutlineInputBorder(),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Kategori tidak boleh kosong!";
                  }
                  if (value.length > 30) {
                    return "Kategori tidak boleh lebih dari 30 karakter!";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              TextFormField(
                controller: _thumbnailController,
                decoration: const InputDecoration(
                  hintText: "https://... (Opsional)",
                  labelText: "URL Thumbnail (Opsional)",
                  border: OutlineInputBorder(),
                ),
                validator: (String? value) {
                  if (value != null && value.isNotEmpty) {
                    if (Uri.tryParse(value)?.isAbsolute != true) {
                      return "Format URL tidak valid!";
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              SwitchListTile(
                title: const Text('Featured Product?'),
                value: _isFeatured,
                onChanged: (bool value) {
                  setState(() {
                    _isFeatured = value;
                  });
                },
              ),
              const SizedBox(height: 24.0),

              // tombol Save
              Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed:
                      _isLoading
                          ? null
                          : () async {
                            if (_formKey.currentState!.validate()) {
                              String url;
                              if (widget.product == null) {
                                url =
                                    "https://bermulya-anugrah-slimeshop.pbp.cs.ui.ac.id/create-product-flutter/";
                              } else {
                                url =
                                    "https://bermulya-anugrah-slimeshop.pbp.cs.ui.ac.id/edit-product-flutter/${widget.product!.pk}/";
                              }

                              setState(() {
                                _isLoading = true;
                              });

                              try {
                                final response = await request.postJson(
                                  url,
                                  jsonEncode(<String, dynamic>{
                                    'name': _nameController.text,
                                    'price': int.parse(_priceController.text),
                                    'stock': int.parse(_stockController.text),
                                    'description': _descriptionController.text,
                                    'category': _categoryController.text,
                                    'thumbnail': _thumbnailController.text,
                                    'is_featured': _isFeatured,
                                  }),
                                );

                                if (context.mounted) {
                                  if (response['status'] == 'success') {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Produk berhasil disimpan!",
                                        ),
                                        backgroundColor: Color(0xFF10B981),
                                      ),
                                    );
                                    Navigator.pushReplacementNamed(
                                      context,
                                      '/',
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Terdapat kesalahan, silakan coba lagi.",
                                        ),
                                        backgroundColor: Color.fromARGB(
                                          255,
                                          197,
                                          47,
                                          47,
                                        ),
                                      ),
                                    );
                                  }
                                }
                              } catch (e) {
                                // heh
                              } finally {
                                if (mounted) {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                }
                              }
                            }
                          },
                  child:
                      _isLoading
                          ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                          : const Text("Save", style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
