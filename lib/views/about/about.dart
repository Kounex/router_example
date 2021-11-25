import 'package:flutter/material.dart';
import 'package:playground/shared/app_drawer.dart';

class AboutView extends StatelessWidget {
  const AboutView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('About'),
      ),
      body: Center(
        child: Text('About'),
      ),
    );
  }
}
