import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taxi_fare/screens/detail_history_screem.dart';
import 'package:taxi_fare/screens/history_screen.dart';
import 'package:taxi_fare/screens/home_screen.dart';
import 'package:taxi_fare/screens/main_wrapper.dart';
import 'package:taxi_fare/screens/profile_screen.dart';
import 'package:taxi_fare/screens/saran_kesan_screen.dart';
import 'package:taxi_fare/screens/sign_in_screen.dart';
import 'package:taxi_fare/screens/sign_up_screen.dart';
import 'package:taxi_fare/screens/splash_screen.dart';

class AppNavigation {
  AppNavigation._();

  static String initial = "/splash";

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorHome = GlobalKey<NavigatorState>(debugLabel: 'shellHome');
  static final _shellNavigatorProfile = GlobalKey<NavigatorState>(debugLabel: 'shellProfile');
  static final _shellNavigatorHistory = GlobalKey<NavigatorState>(debugLabel: 'shellHistory');
  static final _shellNavigatorSaranKesan = GlobalKey<NavigatorState>(debugLabel: 'shellSaranKesan');

  // GoRouter configuration
  static final GoRouter router = GoRouter(
    initialLocation: initial,
    debugLogDiagnostics: true,
    navigatorKey: _rootNavigatorKey,
    routes: [
      /// Splash Screen
      GoRoute(
        path: "/splash",
        name: "splash",
        builder: (BuildContext context, GoRouterState state) => const SplashScreen(),
      ),

      /// SignUp
      GoRoute(
        path: "/signup",
        name: "signup",
        builder: (BuildContext context, GoRouterState state) => const SignUpScreen(),
      ),

      /// SignIn
      GoRoute(
        path: "/signin",
        name: "signin",
        builder: (BuildContext context, GoRouterState state) => const SignInScreen(),
      ),

      /// MainWrapper
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainWrapper(
            navigationShell: navigationShell,
          );
        },
        branches: <StatefulShellBranch>[
          /// Home
          StatefulShellBranch(
            navigatorKey: _shellNavigatorHome,
            routes: <RouteBase>[
              GoRoute(
                path: "/home",
                name: "home",
                builder: (BuildContext context, GoRouterState state) =>
                const HomeScreen(),
              ),
            ],
          ),

          /// History
          StatefulShellBranch(
            navigatorKey: _shellNavigatorHistory,
            routes: <RouteBase>[
              GoRoute(
                path: "/history",
                name: "history",
                builder: (BuildContext context, GoRouterState state) =>
                const HistoryScreen(),
              ),
            ],
          ),

          /// Saran Kesan
          StatefulShellBranch(
            navigatorKey: _shellNavigatorSaranKesan,
            routes: <RouteBase>[
              GoRoute(
                path: "/saran-kesan",
                name: "saran-kesan",
                builder: (BuildContext context, GoRouterState state) =>
                const SaranKesanScreen(),
              ),
            ],
          ),

          /// Profile
          StatefulShellBranch(
            navigatorKey: _shellNavigatorProfile,
            routes: <RouteBase>[
              GoRoute(
                path: "/profile",
                name: "profile",
                builder: (BuildContext context, GoRouterState state) =>
                const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
