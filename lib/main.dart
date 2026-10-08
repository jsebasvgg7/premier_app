import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/network/api_client.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/main_shell.dart';
import 'features/matches/data/matches_repository.dart';
import 'features/matches/presentation/matches_controller.dart';
import 'features/standings/data/standings_repository.dart';
import 'features/standings/presentation/standings_controller.dart';

void main() => runApp(const PremierApp());

class PremierApp extends StatelessWidget {
  const PremierApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ApiClient>(create: (_) => ApiClient()),
        ChangeNotifierProvider(
          create: (c) => StandingsController(StandingsRepository(c.read<ApiClient>())),
        ),
        ChangeNotifierProvider(
          create: (c) => MatchesController(MatchesRepository(c.read<ApiClient>())),
        ),
      ],
      child: MaterialApp(
        title: 'Premier League',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const MainShell(),
      ),
    );
  }
}
