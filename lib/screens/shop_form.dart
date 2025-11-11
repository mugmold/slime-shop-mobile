import 'package:flutter/material.dart';

class ShopFormPage extends StatefulWidget {
  const ShopFormPage({super.key});

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

  void _showDataDialog(Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Data Produk Tersimpan"),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Nama: ${data['name']}"),
                Text("Harga: ${data['price']}"),
                Text("Stock: ${data['stock']}"),
                Text("Deskripsi: ${data['description']}"),
                Text("Kategori: ${data['category']}"),
                Text("URL Thumbnail: ${data['thumbnail']}"),
                Text("Is Featured: ${data['isFeatured']}"),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Produk Baru')),
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
                  onPressed: () {
                    // cek apakah form sudah valid
                    if (_formKey.currentState!.validate()) {
                      // tangkep data dlu biar ga ke update tiba tiba pas di show
                      final Map<String, dynamic> data = {
                        'name': _nameController.text,
                        'price': _priceController.text,
                        'stock': _stockController.text,
                        'description': _descriptionController.text,
                        'category': _categoryController.text,
                        'thumbnail': _thumbnailController.text,
                        'isFeatured': _isFeatured,
                      };

                      // jika valid, tampilkan dialog
                      _showDataDialog(data);

                      // reset form
                      _formKey.currentState!.reset();
                      _nameController.clear();
                      _priceController.clear();
                      _descriptionController.clear();
                      _thumbnailController.clear();
                      _categoryController.clear();
                      setState(() {
                        _isFeatured = false;
                      });
                    }
                  },
                  child: const Text("Save", style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
