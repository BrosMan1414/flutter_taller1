import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/lifecycle_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Lista de elementos ficticios para el GridView
  final List<Map<String, dynamic>> _items = [
    {'id': '1', 'title': 'Elemento 1', 'description': 'Descripción del elemento 1', 'color': Colors.red},
    {'id': '2', 'title': 'Elemento 2', 'description': 'Descripción del elemento 2', 'color': Colors.blue},
    {'id': '3', 'title': 'Elemento 3', 'description': 'Descripción del elemento 3', 'color': Colors.green},
    {'id': '4', 'title': 'Elemento 4', 'description': 'Descripción del elemento 4', 'color': Colors.orange},
    {'id': '5', 'title': 'Elemento 5', 'description': 'Descripción del elemento 5', 'color': Colors.purple},
    {'id': '6', 'title': 'Elemento 6', 'description': 'Descripción del elemento 6', 'color': Colors.teal},
  ];

  @override
  void initState() {
    super.initState();
    // Se ejecuta UNA SOLA VEZ cuando se crea el widget
    print('HomeScreen: initState() ejecutado');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Se ejecuta después de initState y cuando cambian las dependencias
    print('HomeScreen: didChangeDependencies() ejecutado');
  }

  @override
  Widget build(BuildContext context) {
    // Se ejecuta CADA VEZ que el widget necesita reconstruirse
    print('HomeScreen: build() ejecutado');
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Taller 1 - Navegación'),
        actions: [
          IconButton(
            icon: const Icon(Icons.tab),
            onPressed: () => context.go('/tabs'),
            tooltip: 'Ir a Tabs',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Card con información del ciclo de vida
            const LifecycleCard(),

          // Botones de navegación para demostrar go, push, replace
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => context.go('/details/demo?title=Go Navigation&description=Usado con context.go()'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text('GO'),
                ),
                ElevatedButton(
                  onPressed: () => context.push('/details/demo?title=Push Navigation&description=Usado con context.push()'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: const Text('PUSH'),
                ),
                ElevatedButton(
                  onPressed: () => context.pushReplacement('/details/demo?title=Replace Navigation&description=Usado con context.pushReplacement()'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('REPLACE'),
                ),
              ],
            ),
          ),

          // GridView con elementos
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              height: 400, // Fixed height instead of Expanded
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.0,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  final item = _items[index];
                  return GestureDetector(
                    onTap: () {
                      // Navegación con parámetros usando push
                      context.push(
                        '/details/${item['id']}?title=${item['title']}&description=${item['description']}'
                      );
                    },
                    child: Card(
                      elevation: 4,
                      child: Container(
                        decoration: BoxDecoration(
                          color: item['color'].withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: item['color'], width: 2),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.apps,
                              size: 40,
                              color: item['color'],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              item['title'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: item['color'],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'ID: ${item['id']}',
                              style: TextStyle(
                                fontSize: 12,
                                color: item['color'].withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Se ejecuta UNA VEZ cuando el widget se destruye - para limpiar recursos
    print('HomeScreen: dispose() - Widget destruido');
    super.dispose();
  }
}
