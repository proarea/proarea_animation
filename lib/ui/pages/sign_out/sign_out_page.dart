import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../l10n/localization_helper.dart';
import '../../../themes/theme_app.dart';
import 'components/animated_button.dart';

class SignOutPage extends StatefulWidget with AutoRouteWrapper {
  const SignOutPage({super.key});

  @override
  State<SignOutPage> createState() => _SignOutPageState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return Theme(
      data: ThemeType.light.themeData,
      child: this,
    );
  }
}

class _SignOutPageState extends State<SignOutPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 10000),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _playAnimation() {
    if (_controller.isAnimating) return;

    _controller.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          context.strings.signOut,
          style: context.textTheme.bodyText1,
        ),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _playAnimation,
        child: AnimatedButton(controller: _controller.view),
      ),
    );
  }
}