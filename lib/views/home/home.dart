import 'package:flutter/material.dart';
import 'package:playground/shared/app_drawer.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Text('Home'),
      ),
    );
  }
}
