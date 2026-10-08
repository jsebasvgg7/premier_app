# Premier App – Parte C: implementación en Flutter

## 1. Introducción

Esta aplicación móvil, desarrollada en Flutter, consume el servicio REST de football-data.org (versión 4) para presentar información de la Premier League: el próximo partido, el calendario por jornadas y la tabla de posiciones. Constituye la tercera parte del proyecto. Las dos anteriores definieron el diseño de las pantallas y el mapeo entre los datos de la API y las clases del modelo, y aquí se llevan a código.

El trabajo se organizó con una arquitectura Feature First, de modo que cada funcionalidad agrupa sus propios datos y su interfaz, y lo que comparten varias de ellas se concentra en una carpeta común.

## 2. Herramientas utilizadas

Se empleó Flutter con Dart como entorno de desarrollo. Los paquetes externos se limitaron a los necesarios:

- `http`, para las peticiones GET a la API.
- `provider`, para la gestión de estado mediante controladores `ChangeNotifier`.
- `flutter_svg`, porque la API entrega parte de los escudos de los equipos en formato SVG.
- `google_fonts` y `lucide_icons_lite`, para la tipografía (Outfit) y los íconos.
- `shared_preferences`, para guardar localmente los datos del perfil del usuario.

## 3. Consumo de la API REST

Todas las peticiones pasan por una única clase, `ApiClient`, ubicada en `core/network`. Esta clase arma la dirección a partir de la base `https://api.football-data.org/v4`, envía la solicitud con el método GET e incluye el encabezado `X-Auth-Token` con la clave del usuario. Concentrar el acceso a la red en un solo punto evita repetir lógica y permite tratar los errores de forma uniforme.

Se utilizan dos recursos:

- `GET /v4/competitions/PL/standings`, que devuelve la tabla de posiciones, la jornada actual (`currentMatchday`) y las fechas de la temporada.
- `GET /v4/competitions/PL/matches?matchday=N`, que devuelve los partidos de una jornada.

El plan gratuito de la API limita las consultas a diez por minuto. Para respetar ese límite, el controlador de partidos guarda en memoria cada jornada ya consultada, de manera que el inicio y el calendario comparten los datos sin repetir peticiones.

La clave personal se almacena en `lib/core/config/api_secrets.dart`, un archivo local excluido del control de versiones. El repositorio incluye `api_secrets.example.dart` como plantilla. Opcionalmente, la clave puede sobrescribirse al ejecutar con `--dart-define=FOOTBALL_API_KEY=...`.

## 4. Mapeo de JSON a clases Dart

Las respuestas se convierten en objetos mediante constructores de fábrica `fromJson`. Cada campo se transforma al tipo esperado con el operador `as` y recibe un valor por defecto con `??`, por lo que la omisión de un campo o un valor nulo no interrumpe la aplicación.

- `Team` (en `core/models`): `id`, `shortName`, `tla` y `crest`. Es compartida por las funcionalidades de tabla y partidos.
- `StandingItem`: posición, equipo, partidos jugados, ganados, empatados, perdidos, goles a favor y en contra, diferencia de goles y puntos. Los campos de ganados, empatados y perdidos se incorporaron al mapeo inicial porque la interfaz muestra las columnas G, E y P.
- `StandingsResponse`: agrupa la tabla, la jornada actual y la etiqueta de temporada (por ejemplo, «Temp. 26/27»).
- `MatchModel`: identificador, jornada, fecha, estado, equipos y goles. La fecha, que la API entrega en UTC, se convierte a la hora local del dispositivo.

El perfil del usuario cuenta con su propio modelo, `ProfileModel`, que se serializa a JSON para guardarse en el dispositivo.

## 5. Pantallas implementadas

La navegación se resuelve con una barra inferior de cuatro destinos: Inicio, Tabla, Calendario y Perfil.

1. **Inicio.** Funciona como un resumen de las demás vistas. Muestra el saludo al usuario, una tarjeta con el próximo partido, los encuentros de un solo día y los cinco primeros equipos de la tabla. Cada sección enlaza con su pantalla completa.
2. **Tabla de posiciones.** Presenta los veinte equipos con las columnas #, Equipo, PJ, G, E, P, +/-, DG y Pts. Admite actualizar los datos deslizando hacia abajo.
3. **Calendario.** Permite recorrer las jornadas con flechas y agrupa los partidos por día, mostrando la hora o el marcador final.
4. **Perfil.** Permite registrar nombre, ubicación, descripción, jugador favorito y equipo favorito. Los datos se conservan en el dispositivo.

Se define como próximo partido el primer encuentro sin finalizar de la jornada actual. Los partidos del día destacado son los que se juegan en la misma fecha que ese encuentro.

## 6. Diseño visual

Se buscó una identidad coherente entre pantallas. La interfaz usa un fondo con degradado suave, tarjetas de bordes redondeados con sombras ligeras y una única tarjeta oscura de contraste para el próximo partido. La paleta parte de los colores de la liga: berenjena como color principal, magenta para el marcador y las acciones, y verde como acento sobre fondos oscuros. Las tarjetas de la tabla incluyen una pestaña recortada en la esquina superior con la temporada, y el líder se resalta con el mismo tratamiento oscuro del próximo partido.

## 7. Manejo de respuestas exitosas y errores

Cuando la API responde con código 200, los datos se mapean a los modelos y se muestran. Cada pantalla distingue tres estados, controlados por `ViewStatus`: cargando, con un indicador de progreso; listo, con los datos; y error, con un mensaje y un botón «Reintentar».

`ApiClient` traduce las fallas en una excepción propia, `ApiException`, con mensajes comprensibles para el usuario:

- 400: solicitud inválida, acompañada del mensaje de la API.
- 403: la clave no tiene permiso para el recurso.
- 404: el recurso no existe.
- 429: se superó el límite de peticiones por minuto.
- Falta de conexión o tiempo de espera agotado, con mensajes específicos.
- Ausencia de clave, que se detecta antes de enviar la petición.

Los controladores capturan además cualquier otro fallo inesperado al leer los datos, para que la pantalla nunca quede cargando indefinidamente.

## 8. Arquitectura de carpetas

```
lib/
├─ main.dart
├─ core/
│  ├─ config/        api_config, api_secrets
│  ├─ network/       api_client, api_exception
│  ├─ models/        team
│  ├─ theme/         app_theme
│  ├─ utils/         date_format
│  └─ widgets/       componentes compartidos
└─ features/
   ├─ home/
   │  └─ presentation/
   ├─ standings/
   │  ├─ data/
   │  └─ presentation/
   ├─ matches/
   │  ├─ data/
   │  └─ presentation/
   └─ profile/
      ├─ data/
      └─ presentation/
```

La carpeta `core` reúne lo reutilizable: cliente HTTP, modelo `Team`, tema y widgets comunes. Dentro de cada funcionalidad, `data` contiene los modelos y repositorios que consultan la API y devuelven objetos Dart, mientras que `presentation` contiene los controladores que gestionan el estado y las pantallas que lo muestran.

El flujo de datos es el siguiente: la pantalla solicita información al controlador, este la pide al repositorio y el repositorio la obtiene mediante `ApiClient`. La respuesta recorre el camino inverso y la pantalla se actualiza gracias a `provider`.

## 9. Ejecución del proyecto

1. Clonar el repositorio e instalar las dependencias con `flutter pub get`.
2. Obtener una clave gratuita en football-data.org.
3. Copiar `lib/core/config/api_secrets.example.dart` como `lib/core/config/api_secrets.dart` y pegar la clave.
4. Ejecutar en un emulador o dispositivo con `flutter run`.

## 10. Resultados

La aplicación se ejecutó correctamente en un dispositivo y muestra datos reales del servicio: el próximo partido, los encuentros del día, el calendario por jornadas y la tabla de posiciones. También se comprobó la navegación entre las cuatro vistas y el comportamiento ante errores de red.

## 11. Conclusiones

La organización por funcionalidades facilita el mantenimiento del código y permite repartir el trabajo entre los integrantes sin que se interfieran. El mapeo con valores por defecto aporta tolerancia ante respuestas incompletas de la API. El almacenamiento temporal de las jornadas consultadas hizo posible trabajar dentro del límite del plan gratuito, y el tratamiento centralizado de los errores permite informar al usuario de manera clara sin interrumpir la aplicación.
