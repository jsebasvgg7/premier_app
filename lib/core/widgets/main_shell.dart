import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../features/home/presentation/home_screen.dart';
import '../../features/matches/presentation/matches_controller.dart';
import '../../features/matches/presentation/matches_screen.dart';
import '../../features/standings/presentation/standings_controller.dart';
import '../../features/standings/presentation/standings_screen.dart';
import 'app_header.dart';
import 'floating_nav_bar.dart';

/// Contenedor con la barra de navegación inferior (Home / Tabla / Calendario).
class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrap());
  }

  /// Primero la tabla (trae currentMatchday), luego los partidos de esa jornada.
  Future<void> _bootstrap() async {
    final standings = context.read<StandingsController>();
    final matches = context.read<MatchesController>();
    await standings.load();
    await matches.init(standings.currentMatchday ?? 1);
  }

  void _go(int i) => setState(() => _index = i);

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(onSeeTable: () => _go(1), onSeeMatches: () => _go(2)),
      const StandingsScreen(),
      const MatchesScreen(),
    ];
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              const AppHeader(),
              Expanded(child: IndexedStack(index: _index, children: pages)),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: FloatingNavBar(index: _index, onTap: _go),
          ),
        ],
      ),
    );
  }
}
