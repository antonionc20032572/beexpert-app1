// lib/main.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'skills_page.dart';
import 'events_page.dart';
import 'resume_page.dart';
import 'settings_page.dart';

// Brand colors
const kTeal = Color(0xFF01859A);
const kOrange = Color(0xFFF6A737);

// 🔧 Global tab controller so any page can switch tabs.
final ValueNotifier<int> tabIndex = ValueNotifier<int>(0);

void main() => runApp(const BeExpertApp());

class BeExpertApp extends StatelessWidget {
  const BeExpertApp({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = ColorScheme.fromSeed(
      seedColor: kTeal,
      brightness: Brightness.light,
    ).copyWith(primary: kTeal, secondary: kOrange, tertiary: kOrange);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BeExpert',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: scheme,
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: kTeal,
            foregroundColor: Colors.white,
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          ),
        ),
        chipTheme: ChipThemeData(
          labelStyle: const TextStyle(fontWeight: FontWeight.w600),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          selectedColor: kOrange.withOpacity(.14),
        ),
      ),
      home: const _Root(),
    );
  }
}

class _Root extends StatefulWidget {
  const _Root();

  @override
  State<_Root> createState() => _RootState();
}

class _RootState extends State<_Root> {
  final _pages = const [
    HomePage(),
    SkillsPage(),
    EventsPage(),
    ResumePage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: tabIndex,
      builder: (_, idx, __) {
        return Scaffold(
          body: SafeArea(child: _pages[idx]),
          bottomNavigationBar: NavigationBar(
            selectedIndex: idx,
            onDestinationSelected: (i) => tabIndex.value = i,   // 🔧
            destinations: const [
              NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
              NavigationDestination(icon: Icon(Icons.auto_graph_outlined), selectedIcon: Icon(Icons.auto_graph), label: 'Skills'),
              NavigationDestination(icon: Icon(Icons.event_outlined), selectedIcon: Icon(Icons.event), label: 'Events'),
              NavigationDestination(icon: Icon(Icons.picture_as_pdf_outlined), selectedIcon: Icon(Icons.picture_as_pdf), label: 'Resume'),
              NavigationDestination(icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings), label: 'Settings'),
            ],
          ),
        );
      },
    );
  }
}

/// 🔧 Small helper so children can navigate tabs easily.
class AppTabs {
  static void go(int i) => tabIndex.value = i;
  static void goHome() => tabIndex.value = 0;
  static void goSkills() => tabIndex.value = 1;
  static void goEvents() => tabIndex.value = 2;
  static void goResume() => tabIndex.value = 3;
  static void goSettings() => tabIndex.value = 4;
}
