import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'screens/login_email_password.dart';
import 'screens/phone_screen.dart';
import 'screens/signup_email_password.dart';
import 'screens/home_screen.dart';
import 'screens/splash_screen.dart';

class AppRouter {
  final goRouter = GoRouter(
      routes: [
        GoRoute(
          path: '/login',
          pageBuilder: (context, state) => MaterialPage(child: LoginScreen()),
        ),
        GoRoute(
          path: '/',
          pageBuilder: (context, state) => MaterialPage(child: SplashScreen()),
        ),
        GoRoute(
          path: '/phone',
          pageBuilder: (context, state) => MaterialPage(child: PhoneLoginScreen()),
        ),
        GoRoute(
          path: '/signin',
          pageBuilder: (context, state) => MaterialPage(child: SignupScreen()),
        ),
        GoRoute(
          path: '/home',
          pageBuilder: (context, state) => MaterialPage(child: HomePage()),
        ),
      ],
      // redirect: (context,state) async {
      //   bool isAuthenticated = false;
      //   if (!isAuthenticated && state == '/'){
      //     return '/login';
      //   }
      //   return null;
      // }
  );
  void navigateWithDelay(BuildContext context, String route, Duration delay) {
    Future.delayed(delay, () => context.go(route));
  }
}