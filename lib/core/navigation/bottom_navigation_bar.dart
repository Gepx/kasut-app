import 'package:flutter/material.dart';
import 'package:kasut/core/navigation/screen_data.dart';

/// Custom bottom navigation bar following micro-frontend architecture
class KasutBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<ScreenData> screens;
  
  static const double _bottomNavBarHeight = 70;

  const KasutBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.screens,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _bottomNavBarHeight,
      decoration: const BoxDecoration(color: Colors.white),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        iconSize: 24,
        backgroundColor: Colors.white,
        items: screens
            .map(
              (screen) => BottomNavigationBarItem(
                icon: Icon(
                  currentIndex == screens.indexOf(screen)
                      ? screen.iconData
                      : screen.activeIconData,
                ),
                label: screen.label,
              ),
            )
            .toList(),
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        selectedIconTheme: const IconThemeData(color: Colors.black, size: 26),
        unselectedIconTheme: const IconThemeData(color: Colors.black, size: 24),
        selectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        onTap: onTap,
      ),
    );
  }
} 