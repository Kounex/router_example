import 'package:flutter/material.dart';
import 'package:playground/shared/app_drawer.dart';
import 'package:playground/states/shared/app.dart';

import '../../../main.dart';

class ItemCategoryView extends StatelessWidget {
  const ItemCategoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Category'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => appState.updateRoute(
            AppRoute.itemDetail,
            {
              ':cat_name': 'greatswords',
              ':item_name': 'astorias-greatsword',
            },
          ),
          child: const Text('Detail'),
        ),
      ),
    );
  }
}
