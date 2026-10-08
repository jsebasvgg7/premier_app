import 'package:flutter_test/flutter_test.dart';
import 'package:premier_app/features/profile/data/models/profile_model.dart';
import 'package:premier_app/features/profile/data/profile_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('ProfileModel usa valores por defecto y nombre de invitado', () {
    final p = ProfileModel.fromJson({});
    expect(p.name, '');
    expect(p.displayName, 'Invitado');
    expect(const ProfileModel(name: ' Ana ').displayName, 'Ana');
  });

  test('ProfileRepository guarda y recupera el perfil en local', () async {
    SharedPreferences.setMockInitialValues({});
    final repo = ProfileRepository();
    expect((await repo.load()).name, '');

    await repo.save(const ProfileModel(name: 'Ana', country: 'Colombia', favoriteTeam: 'Arsenal'));
    final loaded = await repo.load();
    expect(loaded.name, 'Ana');
    expect(loaded.country, 'Colombia');
    expect(loaded.favoriteTeam, 'Arsenal');
  });
}
