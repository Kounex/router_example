import 'package:flutter/material.dart';
import 'package:playground/shared/app_drawer.dart';

class ItemDetailView extends StatelessWidget {
  const ItemDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Detail'),
      ),
      body: const Center(
        child: Text('Detail'),
      ),
    );
  }
}
