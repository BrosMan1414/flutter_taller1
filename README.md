# Flutter - OnePieceQL + Asincronía, Timer e Isolates

Este proyecto demuestra el uso de las principales herramientas de Flutter para manejar procesos asíncronos y tareas pesadas sin bloquear la interfaz de usuario (UI).

Además, integra un ejemplo de consumo GraphQL con la API pública OnePieceQL para listar personajes y ver su detalle.

---

## 1. Future / async / await

- **Cuándo usarlo**:  
  Cuando se necesita ejecutar una operación asíncrona que puede tardar, como una consulta a una API, lectura de base de datos o simulación de carga de datos.

- **Cómo funciona**:  
  - `Future` representa una operación que se completará en el futuro.  
  - `async/await` permite escribir código asíncrono de manera más legible.  
  - Mientras la operación se completa, la UI no se bloquea.  

- **Ejemplo en el proyecto**:  
  Simulación de consulta de datos con `Future.delayed`.  
  La pantalla muestra estados: **Cargando... / Éxito / Error**.

---

## 2. Timer

- **Cuándo usarlo**:  
  Cuando se necesita ejecutar algo repetidamente en intervalos de tiempo (cronómetro, cuenta regresiva) o retrasar una acción.

- **Cómo funciona**:  
  - `Timer` ejecuta una acción después de un tiempo.  
  - `Timer.periodic` ejecuta acciones repetidas cada cierto intervalo.  
  - Se debe cancelar con `.cancel()` para liberar recursos.  

- **Ejemplo en el proyecto**:  
  Un cronómetro con botones de **Iniciar, Pausar, Reanudar y Reiniciar**, actualizando la UI cada segundo.

---

## 3. Isolate

- **Cuándo usarlo**:  
  Cuando se requiere ejecutar una tarea **CPU-bound** (intensiva en procesamiento) como cálculos matemáticos complejos, generación de datos grandes o compresión.

- **Cómo funciona**:  
  - Flutter corre en un solo hilo principal que maneja la UI.  
  - Los **Isolates** permiten ejecutar tareas pesadas en un hilo separado.  
  - La comunicación entre isolates se hace por **mensajes** con `SendPort` y `ReceivePort`.  

- **Ejemplo en el proyecto**:  
  Cálculo de Fibonacci con `Isolate.spawn`.  
  El resultado se envía como mensaje de regreso al hilo principal y se muestra en la UI.

---

## 4. Pantallas y flujos implementados

### Lista de pantallas
- **HomeScreen**: pantalla inicial con navegación hacia los ejemplos.
- **FutureView**: demostración de carga de datos simulada con `Future` y `async/await`.
- **TimerView**: cronómetro con control mediante `Timer`.
- **IsolateView**: cálculo de Fibonacci en un isolate para evitar bloquear la UI.
 - **Listado One Piece**: consume OnePieceQL y lista personajes (avatar + datos).
 - **Detalle One Piece**: muestra la información ampliada del personaje seleccionado.

---

## 5. Diagramas de flujos

### Flujo del Timer

```mermaid
flowchart TD
    A[Usuario abre TimerView] --> B[Pulsa Iniciar]
    B --> C[Timer.periodic cada 1s]
    C --> D[Actualiza contador en la UI]
    D -->|Pausa| E[Cancelar Timer]
    D -->|Reanudar| C
    D -->|Reiniciar| F[Contador = 0]
    F --> B
```

---

### Flujo de Isolate

```mermaid
flowchart TD
  A[Usuario abre IsolateView] --> B[Pulsa Calcular Fibonacci]
  B --> C[Crear ReceivePort]
  C --> D[Lanzar Isolate con Isolate.spawn]
  D --> E[Isolate ejecuta calculo de Fibonacci]
  E --> F[Isolate envia resultado con SendPort]
  F --> G[ReceivePort recibe mensaje]
  G --> H[UI actualiza con setState]
```

---

### Flujo Asincronía con Future / async / await

```mermaid
flowchart TD
  A[initState] --> B[Llamar obtenerDatos]
  B --> C[setState cargando=true, error=null]
  C --> D[cargarNombres con Future delayed 3s]
  D -->|Error 33pc| E[lanza Exception]
  D -->|Exito| F[Retorna lista de nombres]
  E --> G[setState error=mensaje, cargando=false]
  F --> H[setState nombres=lista, cargando=false]
  G --> I[UI: mostrar error + boton Reintentar]
  H --> J[UI: mostrar GridView con personajes]
  C --> K[UI: CircularProgressIndicator]
  I -->|Reintentar| B
```

---

## 6. OnePieceQL (GraphQL)

- Endpoint usado: https://onepieceql.up.railway.app/graphql (método POST)
- Query utilizada para el listado:

```
query Characters {
  characters {
    results {
      englishName
      age
      birthday
      bounty
      devilFruitName
      avatarSrc
    }
  }
}
```

- Fragmento de respuesta JSON esperado:

```
{
  "data": {
    "characters": {
      "results": [
        {
          "englishName": "Monkey D. Luffy",
          "age": 19,
          "birthday": "May 5",
          "bounty": "3,000,000,000",
          "devilFruitName": "Gomu Gomu no Mi",
          "avatarSrc": "https://.../luffy.jpg"
        }
      ]
    }
  }
}
```

### Arquitectura

- `lib/models/character.dart`: modelo de datos con `fromMap`.
- `lib/services/one_piece_service.dart`: servicio HTTP que envía la query GraphQL.
- `lib/views/onepiece/listado_view.dart`: pantalla con `FutureBuilder` y estados de carga/éxito/error.
- `lib/views/onepiece/detalle_view.dart`: recibe el `Character` por navegación y muestra el detalle.
- `lib/routes/app_router.dart`: rutas con `go_router` (onepiece_list, onepiece_detail).
- `lib/widgets/drawer.dart`: acceso al listado.

---

## Publicación y distribución (Firebase App Distribution)

Breve explicación del flujo

Generar APK → App Distribution → Testers → Instalación → Actualización

Sección "Publicación" (pasos resumidos)

- Generar el artefacto de release:
  - APK: `flutter build apk --release` → `build/app/outputs/flutter-apk/app-release.apk`
  - AAB: `flutter build appbundle --release` → `build/app/outputs/bundle/release/app-release.aab`
- Subir a App Distribution (opciones):
  - Consola: Firebase Console → App Distribution → Distribuir nueva versión → subir APK/AAB → seleccionar testers/grupos → publicar.
  - CLI: con `firebase-tools` ejecutar (ejemplo):

```powershell
firebase appdistribution:distribute build\app\outputs\flutter-apk\app-release.apk --app YOUR_FIREBASE_APP_ID --project YOUR_PROJECT_ID --groups "QA_Clase" --release-notes "Notas de la release"
```

- Notificar a los testers y verificar la instalación en dispositivos.

Cómo replicar el proceso en el equipo

1. Compartir el `App ID` y permisos de Firebase (o `--project` alias) con el equipo.
2. Cada desarrollador puede generar el APK/AAB con `flutter build` y usar la consola o CLI para subir.
3. En CI (opcional) crear un Service Account con permisos de App Distribution y usar su key JSON en el pipeline para ejecutar el mismo comando CLI.

Notas sobre versionado

- Formato en Flutter (pubspec.yaml): `version: <versionName>+<versionCode>` por ejemplo `version: 1.0.1+2`.
- Buenas prácticas:
  - Incrementar `versionCode` en cada build que publiques para evitar conflictos.
  - Mantener `versionName` legible (semver o similar).

Formato sugerido de Release Notes

- Título breve (línea 1)
- Lista corta de cambios (bullets): características, correcciones, bloqueos conocidos.
- Instrucciones de prueba (pasos rápidos para el tester).
- Referencias a issues o tickets (ej: #1234).

Ejemplo:

```
Versión 1.0.1+2
- Corrección: carga de perfil en background.
- Mejora: reducción del tiempo de inicialización.
- Nota: desactivar modo depuración antes de instalar.

Pasos de prueba:
1. Abrir la app.
2. Ir a Perfil → Actualizar.

Issue relacionado: #42
```

Capturas / GIFs

- Puedes añadir capturas o GIFs breves del panel de App Distribution o del proceso de instalación. Si prefieres, agrégalos en un PDF y enlázalos aquí en el README (p. ej. `docs/releases/release_1_0_1.pdf`).

---

Si necesitas, genero un script PowerShell que automatice "build + upload" usando `--app` y `--project`, o preparo un ejemplo de pipeline (GitHub Actions) para que el equipo lo replique.

### Navegación con go_router

- A detalle desde el listado:
  - `context.pushNamed('onepiece_detail', extra: character)`
- En la ruta de detalle se recibe el objeto desde `state.extra` y se construye `DetalleView(character: ...)`.

### Estados y manejo de errores

- `FutureBuilder` en Listado: muestra `CircularProgressIndicator` mientras carga, lista en éxito, y mensaje con botón “Reintentar” en error.
- El servicio valida `statusCode` y errores de GraphQL (clave `errors`).
- No se realizan llamadas HTTP dentro de `build()`; se disparan en `initState()` o a través del `Future` almacenado.
