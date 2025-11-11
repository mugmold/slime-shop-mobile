import 'package:flutter/material.dart';
import 'package:slime_shop/widgets/left_drawer.dart';
import 'package:slime_shop/widgets/menu_buttons.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Slime Shop")),
      drawer: const LeftDrawer(),
      body: MenuButtons(),
    );
  }
}
