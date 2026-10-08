# Parte C – Implementación de la aplicación en Flutter

## 1. Introducción

En esta parte se implementó una aplicación móvil en Flutter que consume el servicio API REST football-data.org (versión 4) para mostrar información de la Premier League. La aplicación usa el diseño de pantallas y el mapeo de datos definidos en las partes anteriores. Está organizada con una arquitectura Feature First y maneja las respuestas exitosas y los errores de la API.

## 2. Tecnologías y paquetes utilizados

- **Flutter y Dart:** framework y lenguaje de desarrollo de la interfaz.
- **http:** realiza las peticiones GET a la API REST.
- **provider:** gestión de estado mediante controladores `ChangeNotifier`.
- **flutter_svg:** muestra los escudos de los equipos que la API entrega en formato SVG.

## 3. Consumo de la API REST

Todas las peticiones pasan por una clase única, `ApiClient`, ubicada en `core/network`. Esta clase construye la URL a partir de la base `https://api.football-data.org/v4`, envía la petición con el método GET y agrega el encabezado `X-Auth-Token` con la clave personal del usuario. La clave no se escribe en el código: se entrega al ejecutar la aplicación con `--dart-define=FOOTBALL_API_KEY=...`, para que no quede expuesta en el repositorio.

Los endpoints utilizados son:

- `GET /v4/competitions/PL/standings`: tabla de posiciones. También entrega la jornada actual (`currentMatchday`) y las fechas de la temporada.
- `GET /v4/competitions/PL/matches?matchday=N`: partidos de una jornada específica.

Como el plan gratuito permite solo 10 peticiones por minuto, la aplicación guarda en memoria (caché) los partidos de cada jornada ya consultada. La pantalla de inicio y la de calendario comparten esos datos y no repiten llamadas innecesarias.

## 4. Mapeo de JSON a clases Dart

Las respuestas JSON se convierten en objetos Dart mediante constructores de fábrica `fromJson`. Cada campo se convierte con el operador `as` al tipo esperado y se le asigna un valor por defecto con `??`. Así, si la API omite un campo o lo devuelve nulo, la aplicación no falla.

Las clases del modelo son:

- **Team** (`core/models`): `id`, `shortName`, `tla` y `crest`. Es compartida por las funcionalidades de tabla y partidos.
- **StandingItem**: `position`, `team`, `playedGames`, `won`, `draw`, `lost`, `points` y `goalDifference`. Los campos `won`, `draw` y `lost` se agregaron al mapeo inicial porque la interfaz muestra las columnas G, E y P.
- **StandingsResponse**: agrupa la lista de posiciones, la jornada actual y la etiqueta de temporada (por ejemplo, "Temp. 26/27").
- **MatchModel**: `id`, `matchday`, `date`, `status`, equipo local, equipo visitante y goles. La fecha UTC de la API se convierte a la hora local del dispositivo.

## 5. Pantallas implementadas

La aplicación tiene tres vistas, comunicadas por una barra de navegación inferior (Inicio, Tabla y Calendario):

1. **Inicio (resumen):** muestra el saludo al usuario, la tarjeta del próximo partido, los partidos de un solo día y los cinco primeros equipos de la tabla. Cada sección tiene un enlace ("Ver jornada" y "Ver completa") que lleva a su pantalla completa.
2. **Tabla de posiciones:** presenta los 20 equipos con las columnas #, Equipo, PJ, G, E, P, DG y Pts. Permite actualizar los datos deslizando hacia abajo.
3. **Calendario de partidos:** permite navegar entre jornadas con flechas y muestra los partidos agrupados por día, con la hora o el marcador final.

El próximo partido es el primer encuentro sin finalizar de la jornada actual. Los partidos del día destacado son los que se juegan en la misma fecha que ese próximo partido.

## 6. Manejo de respuestas exitosas y errores

Cuando la respuesta es 200 OK, los datos se mapean a los modelos y se muestran en pantalla. Cada pantalla tiene tres estados controlados por `ViewStatus`: cargando (indicador de progreso), listo (datos) y error (mensaje con botón "Reintentar").

`ApiClient` traduce los códigos de error a mensajes claros mediante una excepción propia, `ApiException`:

- **400:** solicitud inválida, con el mensaje que devuelve la API.
- **403:** la clave no tiene permiso para el recurso.
- **404:** el recurso no existe.
- **429:** se superó el límite de peticiones por minuto.
- **Sin internet o tiempo de espera agotado:** mensajes específicos.
- **Falta de API key:** aviso antes de enviar la petición.

## 7. Arquitectura de carpetas (Feature First)

El código se organiza por funcionalidades. Cada una contiene sus propias capas de datos y presentación, y lo compartido va en `core`.

```
lib/
├─ main.dart
├─ core/
│  ├─ config/        (api_config.dart)
│  ├─ network/       (api_client.dart, api_exception.dart)
│  ├─ models/        (team.dart)
│  ├─ theme/         (app_theme.dart)
│  ├─ utils/         (date_format.dart)
│  └─ widgets/       (main_shell, app_header, crest_image, error_view, view_status)
└─ features/
   ├─ home/
   │  └─ presentation/   (home_screen.dart, widgets/next_match_card.dart)
   ├─ standings/
   │  ├─ data/           (models/, standings_repository.dart)
   │  └─ presentation/   (standings_controller, standings_screen, standings_table)
   └─ matches/
      ├─ data/           (models/match_model.dart, matches_repository.dart)
      └─ presentation/   (matches_controller, matches_screen, match_tile)
```

- **core:** componentes reutilizables por toda la aplicación (cliente HTTP, modelo Team, tema y widgets comunes).
- **data:** modelos y repositorios que llaman a la API y devuelven objetos Dart.
- **presentation:** controladores que manejan el estado y las pantallas que lo muestran.

El flujo de datos es: pantalla → controlador → repositorio → ApiClient → API. La respuesta recorre el camino inverso y la pantalla se actualiza mediante `provider`.

## 8. Cómo ejecutar el proyecto

1. Clonar el repositorio e instalar dependencias con `flutter pub get`.
2. Obtener la API key gratuita en football-data.org.
3. Ejecutar en un emulador o dispositivo móvil: `flutter run --dart-define=FOOTBALL_API_KEY=TU_CLAVE`.

## 9. Resultados

La aplicación se ejecutó correctamente. Muestra el próximo partido, el calendario del día y la tabla de posiciones con datos reales del servicio. Se verificó la navegación entre las tres vistas.

## 10. Conclusiones

- Separar el proyecto por funcionalidades facilita mantenerlo y repartir el trabajo entre los integrantes.
- El mapeo a clases Dart con valores por defecto evita errores cuando la API omite campos.
- La caché por jornada permite trabajar dentro del límite de 10 peticiones por minuto del plan gratuito.
- Manejar los códigos de error de forma centralizada da mensajes claros al usuario y evita que la aplicación se detenga ante fallos de red o de la API.

## 11. Entrega

- Repositorio en GitHub: (agregar enlace)
- Video de sustentación en YouTube: (agregar enlace)