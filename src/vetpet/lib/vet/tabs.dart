import 'package:flutter/material.dart';
import 'package:vetpet/common/tabbed_layout.dart';
import 'package:vetpet/vet/chat.dart';
import 'package:vetpet/vet/home.dart';
import 'package:vetpet/vet/notifications.dart';
import 'package:vetpet/vet/profile.dart';

class VetTabs extends StatelessWidget {
  const VetTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return const TabbedLayout(
      tabs: [
        TabData(
          body: VetHome(),
          tabTitle: "Home",
          inactiveIcon: Icons.home_outlined,
          activeIcon: Icons.home,
        ),
        TabData(
          body: VetChat(),
          tabTitle: "Chat",
          inactiveIcon: Icons.chat_outlined,
          activeIcon: Icons.chat_bubble,
        ),
        TabData(
          body: VetNotifications(),
          tabTitle: "Notifications",
          inactiveIcon: Icons.notifications_outlined,
          activeIcon: Icons.notifications,
        ),
        TabData(
          body: VetProfile(),
          tabTitle: "Profile",
          inactiveIcon: Icons.person_outline,
          activeIcon: Icons.person,
        ),
      ],
    );
  }
}
