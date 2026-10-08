# Premier League App (Flutter)

Consume football-data.org v4 (tabla y partidos de la Premier League).

## Cómo correrla
```bash
flutter create premier_app      # genera android/ios/etc.
# copia aquí lib/ y pubspec.yaml de este proyecto (reemplazando los generados)
flutter pub get
flutter run --dart-define=FOOTBALL_API_KEY=TU_CLAVE
```
> No uses Chrome/web: football-data.org no habilita CORS. Usa emulador Android/iOS o un celular.
> Nunca subas tu API key al repositorio.

## Arquitectura (Feature First)
```
lib/
├─ main.dart                  # providers + MaterialApp
├─ core/                      # lo compartido por todas las features
│  └─ config/ network/ models/ theme/ utils/ widgets/
└─ features/
   ├─ home/presentation/               # resumen (próximo partido, 1 día, top 5)
   ├─ standings/{data,presentation}/   # tabla completa
   └─ matches/{data,presentation}/     # calendario por jornada
```
Dentro de cada feature: `data/` (modelos + repositorio que llama a la API) y `presentation/` (controller ChangeNotifier + pantallas/widgets).
