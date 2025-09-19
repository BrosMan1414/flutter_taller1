# Flutter Taller 1 - Navegación y Widgets

## Descripción

Este proyecto es una aplicación Flutter que demuestra la navegación entre pantallas usando go_router, implementación de diferentes widgets nativos, y evidencia del ciclo de vida de los widgets con logs detallados en consola.

## Arquitectura y Navegación

### Rutas Definidas

La aplicación utiliza **go_router** como sistema de navegación con las siguientes rutas:

```dart
// Ruta principal
'/' → HomeScreen

// Ruta de detalles con parámetro
'/details/:itemId' → DetailsScreen

// Ruta de tabs
'/tabs' → TabsScreen
```

### Envío de Parámetros

#### 1. Parámetros de Ruta (Path Parameters)
```dart
// Definición en GoRouter
'/details/:itemId'

// Navegación desde código
context.go('/details/1')           // GO - Reemplaza historial
context.push('/details/2')         // PUSH - Mantiene historial
context.pushReplacement('/details/3') // REPLACE - Reemplaza pantalla actual

// Obtención del parámetro
final itemId = GoRouterState.of(context).pathParameters['itemId']!;
```

#### 2. Parámetros de Query (Query Parameters)
```dart
// Navegación con query parameters
context.go('/details/tutorial-1?from=tabs&tutorial=Flutter')

// Obtención de query parameters
final queryParams = GoRouterState.of(context).uri.queryParameters;
final from = queryParams['from'];
final tutorial = queryParams['tutorial'];
```

### Tipos de Navegación

- **GO**: Reemplaza completamente el historial de navegación
- **PUSH**: Agrega una nueva pantalla al stack, manteniendo el historial
- **REPLACE**: Reemplaza la pantalla actual sin afectar el resto del historial

## Widgets Implementados

### 1. GridView.builder

**Ubicación**: `HomeScreen`
**Razón de elección**: 
- Permite crear una cuadrícula eficiente y personalizable
- Ideal para mostrar elementos de manera organizada en 2 columnas
- Construye elementos solo cuando son necesarios (lazy loading)
- Fácil personalización de espaciado y diseño responsivo

```dart
GridView.builder(
  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    childAspectRatio: 1.0,
    crossAxisSpacing: 10.0,
    mainAxisSpacing: 10.0,
  ),
  itemCount: 6,
  itemBuilder: (context, index) => // Widget personalizado
)
```

### 2. TabBar con TabController

**Ubicación**: `TabsScreen`
**Razón de elección**:
- Proporciona navegación por pestañas nativa de Material Design
- Permite organizar contenido relacionado en diferentes secciones
- TabController ofrece control programático sobre las pestañas
- Integración perfecta con el sistema de navegación de Flutter

```dart
TabController _tabController = TabController(length: 3, vsync: this);

TabBar(
  controller: _tabController,
  tabs: [
    Tab(text: 'Info'),
    Tab(text: 'Lista'),
    Tab(text: 'Config'),
  ],
)
```

### 3. Widget Personalizado (LifecycleCard)

**Ubicación**: `lib/widgets/lifecycle_card.dart`
**Razón de elección**:
- Demuestra la creación de widgets reutilizables
- Encapsula funcionalidad específica del ciclo de vida
- Permite mostrar de manera interactiva los métodos del ciclo de vida
- Ejemplo práctico de StatefulWidget con gestión de estado

```dart
class LifecycleCard extends StatefulWidget {
  // Widget personalizado que demuestra el ciclo de vida
  // con botones interactivos y contador de rebuilds
}
```

## Evidencia del Ciclo de Vida

### Métodos Implementados

Todos los StatefulWidgets del proyecto implementan los siguientes métodos con logs detallados:

#### 1. initState()
- Se ejecuta **UNA SOLA VEZ** cuando se crea el widget
- Utilizado para inicialización de controladores y configuración inicial

#### 2. didChangeDependencies()
- Se ejecuta después de initState() y cuando cambian las dependencias del widget
- Útil para configuraciones que dependen del contexto

#### 3. build()
- Se ejecuta **CADA VEZ** que el widget necesita reconstruirse
- Incluye contador de reconstrucciones en LifecycleCard

#### 4. setState()
- Método que fuerza la reconstrucción del widget
- Logs detallados muestran qué cambios provocaron la actualización

#### 5. dispose()
- Se ejecuta **UNA VEZ** cuando el widget se destruye
- Utilizado para liberar recursos y limpiar controladores

### Logs en Consola

Los logs siguen este formato para fácil identificación:
```
WidgetName: methodName() - descripción detallada
```

Ejemplos:
```
HomeScreen: initState() ejecutado
DetailsScreen: setState() llamado - Contador: 1 → 2
TabsScreen: dispose() - Widget destruido
LifecycleCard: build() ejecutado (#3)
```

## Características Adicionales

### Contador Persistente
- Los contadores de visualización se mantienen entre navegaciones
- Implementado usando un Map estático para persistencia de datos
- Cada elemento tiene su propio contador independiente

### Navegación Demostrativa
- Botones específicos para mostrar diferencias entre GO, PUSH y REPLACE
- Nota explicativa con bombillo: 💡 Observa el comportamiento del botón "atrás"

### Interfaz Limpia
- Diseño Material 3 consistente
- Cards con elevación y colores temáticos
- Disposición responsiva y accesible

## Estructura del Proyecto

```
lib/
├── main.dart                 # Configuración de la app y rutas
├── screens/
│   ├── home_screen.dart      # Pantalla principal con GridView
│   ├── details_screen.dart   # Pantalla de detalles con parámetros
│   └── tabs_screen.dart      # Pantalla con TabBar
└── widgets/
    └── lifecycle_card.dart   # Widget personalizado
```

## Dependencias Principales

- **flutter**: Framework principal
- **go_router**: ^16.2.1 - Sistema de navegación declarativo
- **material**: Componentes de Material Design

## Ejecución

```bash
# Instalar dependencias
flutter pub get

# Ejecutar en modo debug
flutter run

# Ejecutar tests
flutter test
```

## Observaciones de Desarrollo

1. **Navegación**: Se eligió go_router por su enfoque declarativo y manejo robusto de parámetros
2. **Widgets**: Cada widget fue seleccionado por su propósito específico y facilidad de uso
3. **Ciclo de Vida**: Los logs proporcionan visibilidad completa del comportamiento interno de Flutter
4. **Arquitectura**: Separación clara entre pantallas y widgets reutilizables
   