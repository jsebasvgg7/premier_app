import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/circle_badge.dart';
import '../../../core/widgets/floating_nav_bar.dart';
import '../../standings/presentation/standings_controller.dart';
import '../data/models/profile_model.dart';
import 'profile_controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _name = TextEditingController();
  final _country = TextEditingController();
  final _bio = TextEditingController();
  final _player = TextEditingController();
  final _team = TextEditingController();
  late final ProfileController _controller;
  bool _filled = false;

  @override
  void initState() {
    super.initState();
    _controller = context.read<ProfileController>();
    _controller.addListener(_fill);
    _fill();
  }

  void _fill() {
    if (_filled || !_controller.loaded) return;
    _filled = true;
    final p = _controller.profile;
    _name.text = p.name;
    _country.text = p.country;
    _bio.text = p.bio;
    _player.text = p.favoritePlayer;
    _team.text = p.favoriteTeam;
  }

  @override
  void dispose() {
    _controller.removeListener(_fill);
    _name.dispose();
    _country.dispose();
    _bio.dispose();
    _player.dispose();
    _team.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    FocusScope.of(context).unfocus();
    final messenger = ScaffoldMessenger.of(context);
    await _controller.save(
      ProfileModel(
        name: _name.text.trim(),
        country: _country.text.trim(),
        bio: _bio.text.trim(),
        favoritePlayer: _player.text.trim(),
        favoriteTeam: _team.text.trim(),
      ),
    );
    messenger.showSnackBar(
      const SnackBar(
        content: Text('Perfil guardado'),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.fromLTRB(20, 0, 20, FloatingNavBar.clearance),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final name = context.select<ProfileController, String>((c) => c.profile.displayName);
    final season = context.select<StandingsController, String>((c) => c.seasonLabel);

    return ListView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: EdgeInsets.zero,
      children: [
        SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Perfil', style: TextStyle(fontSize: 18)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    CircleBadge(
                      size: 88,
                      child: Icon(Icons.person, size: 56, color: AppTheme.aubergine),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.plum,
                            ),
                          ),
                          if (season.isNotEmpty)
                            Text(season.replaceFirst('Temp.', 'Temp'), style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, FloatingNavBar.clearance),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _field('Cambiar nombre', 'Ingresar tu nombre', _name, maxLength: 30),
              _field('Ubicación', 'Ingresar tu país', _country, maxLength: 40),
              _field('Descripción', 'Ingresa una biografía', _bio, lines: 3, maxLength: 200),
              _field('Jugador fav. de la PL', 'Ingresar tu jugador fav.', _player, maxLength: 40),
              _field('Equipo fav. de la PL', 'Ingresar tu club fav.', _team, maxLength: 40),
              const SizedBox(height: 8),
              FilledButton(
                onPressed: _save,
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                child: const Text('Guardar'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _field(
    String label,
    String hint,
    TextEditingController controller, {
    int lines = 1,
    int? maxLength,
  }) {
    OutlineInputBorder outline(Color color, double width) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: color, width: width),
        );

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            minLines: lines,
            maxLines: lines == 1 ? 1 : lines + 2,
            maxLength: maxLength,
            textInputAction: lines == 1 ? TextInputAction.next : TextInputAction.newline,
            style: const TextStyle(fontSize: 15),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: AppTheme.plum.withValues(alpha: 0.45)),
              counterText: '',
              filled: true,
              fillColor: AppTheme.card,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              enabledBorder: outline(AppTheme.border, 1.4),
              focusedBorder: outline(AppTheme.magenta, 1.8),
            ),
          ),
        ],
      ),
    );
  }
}
