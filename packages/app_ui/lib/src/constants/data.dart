// ignore_for_file: public_member_api_docs
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// Navigation bar items
List<NavBarItem> mainNavigationBarItems({
  required String homeLabel,
  required String historyLabel,
  required String liveChatLabel,
  required String userProfileLabel,
}) =>
    <NavBarItem>[
      NavBarItem(
        child: Assets.icons.home.svg(width: 24, height: 24),
        label: homeLabel,
        activeChild: Assets.icons.homeActive.svg(width: 24, height: 24),
      ),
      NavBarItem(
        child: Assets.icons.history.svg(width: 24, height: 24),
        label: historyLabel,
      ),
      NavBarItem(
        child: Assets.icons.liveChat.svg(width: 24, height: 24),
        label: liveChatLabel,
      ),
      NavBarItem(
        child: Assets.icons.account.svg(width: 24, height: 24),
        label: userProfileLabel,
        activeChild: Assets.icons.profileActiive.svg(width: 24, height: 24),
      ),
    ];



class NavBarItem {
  const NavBarItem({
    this.icon,
    this.label,
    this.child,
    this.activeChild,
    this.actveIcon,
    this.activeIcon,
  });

  final String? label;
  final Widget? child;
  final IconData? icon;
  final IconData? activeIcon;
  final Widget? activeChild;
  final IconData? actveIcon;

  String? get tooltip => label;
}
