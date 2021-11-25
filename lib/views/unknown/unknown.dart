import 'package:flutter/material.dart';
import 'package:playground/main.dart';
import 'package:playground/states/shared/app.dart';

class UnknownView extends StatelessWidget {
  const UnknownView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
                'Nothing to find here... either go back or return to home by pressing the button!'),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () => appState.updateRoute(AppRoute.home),
              child: const Text('Home'),
            ),
          ],
        ),
      ),
    );
  }
}
