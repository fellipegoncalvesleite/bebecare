import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/app_state.dart';
import 'account_screen.dart';
import 'estimulando_screen.dart';
import 'growth_screen.dart';
import 'home_screen.dart';
import 'vaccine_screen.dart';

/// Root shell: five self-contained sections behind a bottom NavigationBar.
class AppShell extends StatelessWidget {
  const AppShell({super.key});

  static const _pages = <Widget>[
    HomeScreen(),
    GrowthScreen(),
    VaccineScreen(),
    EstimulandoScreen(),
    AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final index = appState.selectedIndex;

    return Scaffold(
      body: IndexedStack(index: index, children: _pages),
      bottomNavigationBar: MediaQuery.withClampedTextScaling(
        // Keep tab labels at their designed size so the five labels never wrap
        // to a second line (which would push the icons out of the bar).
        maxScaleFactor: 1.0,
        child: NavigationBar(
          selectedIndex: index,
          onDestinationSelected: appState.selectTab,
          destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Início',
          ),
          NavigationDestination(
            icon: Icon(Icons.monitor_weight_outlined),
            selectedIcon: Icon(Icons.monitor_weight),
            label: 'Crescimento',
          ),
          NavigationDestination(
            icon: Icon(Icons.vaccines_outlined),
            selectedIcon: Icon(Icons.vaccines),
            label: 'Vacinas',
          ),
          NavigationDestination(
            icon: Icon(Icons.music_note_outlined),
            selectedIcon: Icon(Icons.music_note),
            label: 'Estímulos',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Conta',
          ),
          ],
        ),
      ),
    );
  }
}
