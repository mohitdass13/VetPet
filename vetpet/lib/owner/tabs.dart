import 'package:flutter/material.dart';
import 'package:vetpet/common/tabbed_layout.dart';
import 'package:vetpet/owner/chat.dart';
import 'package:vetpet/owner/home.dart';
import 'package:vetpet/owner/notifications.dart';
import 'package:vetpet/owner/profile.dart';

class OwnerTabs extends StatelessWidget {
  const OwnerTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return const TabbedLayout(
      tabs: [
        TabData(
          body: OwnerHome(),
          tabTitle: "Home",
          inactiveIcon: Icons.home_outlined,
          activeIcon: Icons.home,
        ),
        TabData(
          body: OwnerChat(),
          tabTitle: "Vets",
          inactiveIcon: Icons.local_hospital_outlined,
          activeIcon: Icons.local_hospital,
        ),
        TabData(
          body: OwnerNotifications(),
          tabTitle: "Notifications",
          inactiveIcon: Icons.notifications_outlined,
          activeIcon: Icons.notifications,
        ),
        TabData(
          body: OwnerProfile(),
          tabTitle: "Profile",
          inactiveIcon: Icons.person_outline,
          activeIcon: Icons.person,
        ),
      ],
    );
  }
}
