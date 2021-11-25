import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:playground/main.dart';
import 'package:playground/states/shared/app.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          SizedBox(
            height: 175.0,
            child: Image.asset(
              'assets/images/app_drawer.jpeg',
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ListTile(
                    title: const Text('Home'),
                    onTap: () {
                      Navigator.of(context).pop();
                      appState.updateRoute(AppRoute.home);
                      try {
                        GoRouter.of(context).go(AppRoute.home.path);
                      } catch (e) {}
                    },
                  ),
                  ListTile(
                    title: const Text('Items'),
                    onTap: () {
                      Navigator.of(context).pop();
                      appState.updateRoute(AppRoute.items);
                      try {
                        GoRouter.of(context).go(AppRoute.items.path);
                      } catch (e) {}
                    },
                  ),
                  ListTile(
                    title: const Text('About'),
                    onTap: () {
                      Navigator.of(context).pop();
                      appState.updateRoute(AppRoute.about);
                      try {
                        GoRouter.of(context).go(AppRoute.about.path);
                      } catch (e) {}
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
