// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class MenuButtons extends StatelessWidget {
  const MenuButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MenuCard(
              title: "All Products",
              icon: Icons.shopping_bag_outlined,
              color: const Color(0xFF10B981),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/list-product');
              },
            ),

            const SizedBox(height: 16),

            MenuCard(
              title: "My Products",
              icon: Icons.person_pin_outlined,
              color: const Color(0xFF10B981),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/list-product-user');
              },
            ),

            const SizedBox(height: 16),

            MenuCard(
              title: "Create Product",
              icon: Icons.add_circle_outline,
              color: const Color(0xFF10B981),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/add-product');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MenuCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const MenuCard({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: Ink(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: InkWell(
          onTap: onTap,
          splashColor: Colors.white.withOpacity(0.3),
          highlightColor: Colors.white.withOpacity(0.1),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 40.0),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
