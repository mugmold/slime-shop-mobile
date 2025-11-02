import 'package:flutter/material.dart';

void showMySnackbar(BuildContext context, String message) {
  // menghapus snackbar sebelumnya jika ada (biar tidak tumpang tindih)
  ScaffoldMessenger.of(context).hideCurrentSnackBar();

  // menampilkan snackbar baru
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message), duration: Duration(seconds: 2)),
  );
}

class MenuButtons extends StatelessWidget {
  const MenuButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton.icon(
            icon: Icon(Icons.shopping_bag_outlined),
            label: Text("All Products"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              minimumSize: Size(200, 50),
            ),
            onPressed: () {
              showMySnackbar(context, "Kamu telah menekan tombol All Products");
            },
          ),

          SizedBox(height: 16),

          ElevatedButton.icon(
            icon: Icon(Icons.person_pin_outlined),
            label: Text("My Products"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              minimumSize: Size(200, 50),
            ),
            onPressed: () {
              showMySnackbar(context, "Kamu telah menekan tombol My Products");
            },
          ),

          SizedBox(height: 16),

          ElevatedButton.icon(
            icon: Icon(Icons.add_circle_outline),
            label: Text("Create Product"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              minimumSize: Size(200, 50),
            ),
            onPressed: () {
              showMySnackbar(
                context,
                "Kamu telah menekan tombol Create Product",
              );
            },
          ),
        ],
      ),
    );
  }
}
