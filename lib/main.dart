import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:playground/states/shared/app.dart';
import 'package:playground/views/about/about.dart';
import 'package:playground/views/home/home.dart';
import 'package:playground/views/items/category/category.dart';
import 'package:playground/views/items/category/detail/detail.dart';
import 'package:playground/views/items/items.dart';
import 'package:playground/views/unknown/unknown.dart';

void main() {
  runApp(const MyApp());
}

enum AppRoute {
  unknown,

  home,

  items,

  ///:cat_name
  itemCategory,

  /// :cat_name / :item_name
  itemDetail,

  about,
}

extension AppRouteFunctions on AppRoute {
  String get title => {
        AppRoute.unknown: 'DS Wiki | Unknown',
        AppRoute.home: 'DS Wiki | Home',
        AppRoute.items: 'DS Wiki | Items',
        AppRoute.itemCategory: 'DS Wiki | %s% ',
        AppRoute.itemDetail: 'DS Wiki | %s%',
        AppRoute.about: 'DS Wiki | About',
      }[this]!;

  String get path => {
        AppRoute.unknown: '/404',
        AppRoute.home: '/',
        AppRoute.items: '/items',
        AppRoute.itemCategory: '/items/:cat_name',
        AppRoute.itemDetail: '/items/:cat_name/:item_name',
        AppRoute.about: '/about',
      }[this]!;

  Widget get view => {
        AppRoute.unknown: const UnknownView(),
        AppRoute.home: const HomeView(),
        AppRoute.items: const ItemsView(),
        AppRoute.itemCategory: const ItemCategoryView(),
        AppRoute.itemDetail: const ItemDetailView(),
        AppRoute.about: const AboutView(),
      }[this]!;
}

class AppRoutePath {
  Uri uri;
  List<AppRoute> routes;

  AppRoutePath(this.uri, this.routes);

  factory AppRoutePath.fromUri(Uri uri) {
    List<AppRoute> routes = [AppRoute.home];

    if (uri.pathSegments.isNotEmpty) {
      routes = AppRoute.values.where(
        (route) {
          List<String> pathSegments = route.path.split('/')..removeAt(0);

          if (pathSegments.length <= uri.pathSegments.length) {
            for (int i = 0; i < pathSegments.length; i++) {
              if (!pathSegments[i].startsWith(':') &&
                  pathSegments[i] != uri.pathSegments[i]) {
                return false;
              }
            }
            return true;
          }
          return false;
        },
      ).toList()
        ..sort(
            (r1, r2) => r1.path.split('/').length - r2.path.split('/').length);
    }

    if (routes.isEmpty) routes = [AppRoute.unknown];

    return AppRoutePath(uri, routes);
  }
}

class AppRouteInformationParser extends RouteInformationParser<AppRoutePath> {
  @override
  Future<AppRoutePath> parseRouteInformation(
      RouteInformation routeInformation) {
    final Uri uri = Uri.parse(routeInformation.location ?? '/');

    print('AppRouteInformationParser.parseRouteInformation - uri.path: ' +
        uri.path);

    return SynchronousFuture(AppRoutePath.fromUri(uri));
  }

  @override
  RouteInformation restoreRouteInformation(AppRoutePath configuration) {
    return RouteInformation(location: configuration.uri.path);
  }
}

class AppRouterDelegate extends RouterDelegate<AppRoutePath>
    with ChangeNotifier, NavigatorObserver, PopNavigatorRouterDelegateMixin {
  /// Attached to the [Navigator] returned by the build function and
  /// needed by the [PopNavigatorRouterDelegateMixin] to access the
  /// [Navigator] and report a pop when the Android back button is pressed
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  final List<MaterialPage> _pages = [];

  AppRoutePath? _path;

  List<MaterialPage> get pages => List.unmodifiable(_pages);

  AppRouterDelegate() {
    appState.addListener(
      () {
        print('appState changed - call listener in router');
        _updatePages(AppRoutePath.fromUri(appState.appUri!));
      },
    );
  }

  void _updatePages(AppRoutePath path) {
    _path = path;

    _pages.clear();
    _pages.addAll(
      path.routes.map(
        (route) => MaterialPage(
          key: ValueKey(route),
          name: route.path,
          child: route.view,
        ),
      ),
    );

    _safeNotifyListeners();
  }

  @override
  AppRoutePath? get currentConfiguration => _path;

  @override
  GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;

  @override
  Future<void> setNewRoutePath(AppRoutePath path) {
    print('setNewRoutePath called');

    _updatePages(path);

    return SynchronousFuture(null);
  }

  @override
  Future<bool> popRoute() {
    print('popRoute called');
    if (_pages.length > 1) {
      _pages.removeLast();
      return SynchronousFuture(true);
    }
    return SynchronousFuture(false);
  }

  /// The [Navigator] pushed `route`.
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      _safeNotifyListeners();

  /// The [Navigator] popped `route`.
  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      _safeNotifyListeners();

  /// The [Navigator] removed `route`.
  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      _safeNotifyListeners();

  /// The [Navigator] replaced `oldRoute` with `newRoute`.
  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) =>
      _safeNotifyListeners();

  void _safeNotifyListeners() {
    // this is a hack to fix the following error:
    // The following assertion was thrown while dispatching notifications for
    // GoRouterDelegate: setState() or markNeedsBuild() called during build.
    WidgetsBinding.instance == null
        ? notifyListeners()
        : scheduleMicrotask(notifyListeners);
  }

  @override
  Widget build(BuildContext context) {
    print('build: ' + _pages.toString());
    return Navigator(
      key: _navigatorKey,
      observers: [this],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }

        if (_pages.length > 1) {
          _pages.removeLast();

          _safeNotifyListeners();

          return true;
        }
        return false;
      },
      pages: pages,
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppRouteInformationParser _appRouteInformationParser =
      AppRouteInformationParser();
  final AppRouterDelegate _appRouterDelegate = AppRouterDelegate();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      // title: 'Dark Souls Wiki',
      theme: ThemeData.dark().copyWith(
        colorScheme: const ColorScheme.dark(),
      ),
      routeInformationParser: _appRouteInformationParser,
      routerDelegate: _appRouterDelegate,
    );
  }
}

class GoRouterApp extends StatefulWidget {
  const GoRouterApp({Key? key}) : super(key: key);

  @override
  State<GoRouterApp> createState() => _GoRouterAppState();
}

class _GoRouterAppState extends State<GoRouterApp> {
  final _router = GoRouter(
    routes: [
      GoRoute(
        path: AppRoute.home.path,
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: AppRoute.home.view,
        ),
      ),
      GoRoute(
        path: AppRoute.items.path,
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: AppRoute.items.view,
        ),
        routes: [
          GoRoute(
            path: AppRoute.itemCategory.path.split('/').skip(2).join('/'),
            pageBuilder: (context, state) => MaterialPage<void>(
              key: state.pageKey,
              child: AppRoute.itemCategory.view,
            ),
            routes: [
              GoRoute(
                path: AppRoute.itemDetail.path.split('/').skip(3).join('/'),
                pageBuilder: (context, state) => MaterialPage<void>(
                  key: state.pageKey,
                  child: AppRoute.itemDetail.view,
                ),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: AppRoute.about.path,
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: AppRoute.about.view,
        ),
      ),
    ],
    errorPageBuilder: (context, state) => MaterialPage<void>(
      key: state.pageKey,
      child: AppRoute.unknown.view,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      // title: 'Dark Souls Wiki',
      theme: ThemeData.dark().copyWith(
        colorScheme: const ColorScheme.dark(),
      ),
      routeInformationParser: _router.routeInformationParser,
      routerDelegate: _router.routerDelegate,
    );
  }
}
