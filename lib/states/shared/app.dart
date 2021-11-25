import 'package:flutter/cupertino.dart';
import 'package:playground/main.dart';

class AppState with ChangeNotifier {
  AppRoute? route;
  Uri? appUri;

  Map<String, String>? params;

  void updateRoute(AppRoute route, [Map<String, String>? params]) {
    this.route = route;

    Uri? uri;

    if (route.path.contains(':') && params != null && params.isNotEmpty) {
      String rawPath = route.path;

      params
          .forEach((key, value) => rawPath = rawPath.replaceFirst(key, value));

      uri = Uri.parse(rawPath);
    }

    appUri = uri ?? Uri.parse(route.path);

    notifyListeners();
  }
}

AppState appState = AppState();
