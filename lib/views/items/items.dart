import 'package:flutter/material.dart';
import 'package:playground/main.dart';
import 'package:playground/shared/app_drawer.dart';
import 'package:playground/states/shared/app.dart';

class ItemsView extends StatelessWidget {
  const ItemsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Items'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => appState.updateRoute(
            AppRoute.itemCategory,
            {':cat_name': 'greatswords'},
          ),
          child: const Text('Category'),
        ),
      ),
    );
  }
}
