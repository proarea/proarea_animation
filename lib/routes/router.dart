import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../ui/pages/about_app/about_app_page.dart';
import '../ui/pages/animated_text/animated_text_page.dart';
import '../ui/pages/cylinder_logo/cylinder_logo_page.dart';
import '../ui/pages/home/home_page.dart';
import '../ui/pages/liquid_swipe/liquid_swipe_page.dart';
import '../ui/pages/posts/posts_page.dart';
import '../ui/pages/settings/settings_page.dart';
import '../ui/pages/shatter/shatter_page.dart';
import '../ui/pages/sign_out/sign_out_page.dart';
import '../ui/pages/splash/splash_page.dart';
import '../ui/pages/users/users_page.dart';

part 'router.gr.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(
      path: 'splash',
      page: SplashPage,
      initial: true,
    ),
    AutoRoute(
      path: 'home',
      page: HomePage,
      children: [
        AutoRoute(
          path: 'posts',
          page: PostsPage,
          initial: true,
        ),
        AutoRoute(
          path: 'users',
          page: UsersPage,
        ),
        AutoRoute(
          path: 'liquidSwipe',
          page: LiquidSwipePage,
        ),
        AutoRoute(
          path: 'shatter',
          page: ShatterPage,
        ),
        AutoRoute(
          path: 'animatedText',
          page: AnimatedTextPage,
        ),
        AutoRoute(
          path: 'cylinderLogo',
          page: CylinderLogoPage,
        ),
        AutoRoute(
          path: 'settings',
          page: SettingsPage,
        ),
        AutoRoute(
          path: 'signOut',
          page: SignOutPage,
        ),
      ],
    ),
    AutoRoute(
      path: 'aboutApp',
      page: AboutAppPage,
    ),
  ],
)
class AppRouter extends _$AppRouter {}
