import 'package:flutter/material.dart';

class TabData {
  final Widget body;
  final String tabTitle;
  final IconData inactiveIcon;
  final IconData activeIcon;

  const TabData({
    required this.body,
    required this.tabTitle,
    required this.inactiveIcon,
    required this.activeIcon,
  });
}

class TabbedLayout extends StatefulWidget {
  const TabbedLayout({super.key, required this.tabs});
  final List<TabData> tabs;

  @override
  State<TabbedLayout> createState() => _TabbedLayoutState();
}

class _TabbedLayoutState extends State<TabbedLayout> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  late final List<BottomNavigationBarItem> items = widget.tabs
      .map<BottomNavigationBarItem>(
        (e) => BottomNavigationBarItem(
          icon: Icon(e.inactiveIcon),
          activeIcon: Icon(e.activeIcon),
          label: e.tabTitle,
          tooltip: e.tabTitle,
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      )
      .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: widget.tabs[_selectedIndex].body,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: items,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
