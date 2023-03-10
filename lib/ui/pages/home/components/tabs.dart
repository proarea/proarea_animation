import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../../l10n/localization_helper.dart';
import '../../../../models/tab_item/tab_item.dart';
import '../../../../routes/router.dart';

class HomeTabs {
  static List<TabItem> get tabs {
    return [
      TabItem(
        (context) => context.strings.posts,
        Icons.article,
        const PostsRoute(),
      ),
      TabItem(
        (context) => context.strings.userList,
        Icons.account_circle,
        const UsersRoute(),
      ),
      TabItem(
        (context) => context.strings.liquidSwipe,
        Icons.swipe,
        const LiquidSwipeRoute(),
      ),
      TabItem(
        (context) => context.strings.shatteringPage,
        Icons.deselect_outlined,
        const ShatterRoute(),
      ),
      TabItem(
        (context) => context.strings.textAnimations,
        Icons.smart_toy_outlined,
        const AnimatedTextRoute(),
      ),
      TabItem(
        (context) => context.strings.textActivity,
        Icons.local_activity,
        const CylinderLogoRoute(),
      ),
      TabItem(
        (context) => context.strings.settings,
        Icons.settings_suggest_outlined,
        const SettingsRoute(),
      ),
      TabItem(
        (context) => context.strings.signOut,
        Icons.exit_to_app,
        const SignOutRoute(),
      ),
    ];
  }

  static List<PageRouteInfo<dynamic>> get routes {
    return tabs.map((tab) => tab.rout).toList();
  }
}
