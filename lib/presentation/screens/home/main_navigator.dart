import 'package:flutter/material.dart';
import 'package:sa7eb_alquran/presentation/screens/profile/profile_screen.dart';
import 'home_screen.dart';
import 'settings_screen_placeholder.dart';

/// Main tab navigator with bottom navigation.
class MainNavigator extends StatefulWidget {
  const MainNavigator({super.key});

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          HomeScreen(),
          ProfileScreen(),
          SettingsScreenPlaceholder(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        backgroundColor: colorScheme.surface,
        indicatorColor: colorScheme.primaryContainer,
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.home_outlined, color: colorScheme.onSurfaceVariant),
            selectedIcon:
                Icon(Icons.home, color: colorScheme.onPrimaryContainer),
            label: 'الرئيسية',
          ),
          NavigationDestination(
            icon:
                Icon(Icons.person_outline, color: colorScheme.onSurfaceVariant),
            selectedIcon:
                Icon(Icons.person, color: colorScheme.onPrimaryContainer),
            label: 'الملف الشخصي',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined,
                color: colorScheme.onSurfaceVariant),
            selectedIcon:
                Icon(Icons.settings, color: colorScheme.onPrimaryContainer),
            label: 'الإعدادات',
          ),
        ],
      ),
    );
  }
}
