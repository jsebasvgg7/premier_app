import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../features/home/presentation/home_screen.dart';
import '../../features/matches/presentation/matches_controller.dart';
import '../../features/matches/presentation/matches_screen.dart';
import '../../features/profile/presentation/profile_controller.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/standings/presentation/standings_controller.dart';
import '../../features/standings/presentation/standings_screen.dart';
import 'app_header.dart';
import 'diagonal_backdrop.dart';
import 'floating_nav_bar.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  static const _profileIndex = 3;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrap());
  }

  Future<void> _bootstrap() async {
    final standings = context.read<StandingsController>();
    final matches = context.read<MatchesController>();
    await standings.load();
    await matches.init(standings.currentMatchday ?? 1);
  }

  void _go(int i) {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() => _index = i);
  }

  @override
  Widget build(BuildContext context) {
    final keyboardOpen = MediaQuery.viewInsetsOf(context).bottom > 0;
    final name = context.select<ProfileController, String>((c) => c.profile.displayName);
    final pages = [
      HomeScreen(onSeeTable: () => _go(1), onSeeMatches: () => _go(2)),
      const StandingsScreen(),
      const MatchesScreen(),
      const ProfileScreen(),
    ];
    return Scaffold(
      body: Stack(
        children: [
          const DiagonalBackdrop(),
          Column(
            children: [
              Offstage(
                offstage: _index == _profileIndex,
                child: AppHeader(name: name, onProfileTap: () => _go(_profileIndex)),
              ),
              Expanded(child: IndexedStack(index: _index, children: pages)),
            ],
          ),
          if (!keyboardOpen)
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
