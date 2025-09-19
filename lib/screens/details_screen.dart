import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DetailsScreen extends StatefulWidget {
  final String itemId;
  final String title;
  final String description;

  const DetailsScreen({
    super.key,
    required this.itemId,
    required this.title,
    required this.description,
  });

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  // Mapa estático para mantener los contadores de visualización persistentes
  static final Map<String, int> _viewCounts = <String, int>{};
  
  int get _viewCount => _viewCounts[widget.itemId] ?? 0;

  @override
  void initState() {
    super.initState();
    // Se ejecuta UNA SOLA VEZ cuando se crea el widget
    print('DetailsScreen: initState() ejecutado (item: ${widget.itemId})');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Se ejecuta después de initState y cuando cambian las dependencias
    print('DetailsScreen: didChangeDependencies() ejecutado');
  }

  @override
  Widget build(BuildContext context) {
    // Se ejecuta CADA VEZ que el widget necesita reconstruirse
    print('DetailsScreen: build() ejecutado');
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Detalles - Item ${widget.itemId}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () => context.go('/'),
            tooltip: 'Ir a Home',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card principal con información del parámetro
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Parámetros Recibidos',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildParameterRow('ID del Item:', widget.itemId),
                    const SizedBox(height: 8),
                    _buildParameterRow('Título:', widget.title),
                    const SizedBox(height: 8),
                    _buildParameterRow('Descripción:', widget.description),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Card con contador para demostrar setState
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Contador de Visualizaciones',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Veces visto: $_viewCount',
                          style: const TextStyle(fontSize: 18),
                        ),
                        ElevatedButton(
                          onPressed: _incrementViewCount,
                          child: const Text('Ver más'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Botones de navegación para demostrar diferentes tipos
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Opciones de Navegación',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => context.go('/'),
                          icon: const Icon(Icons.home),
                          label: const Text('GO Home'),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => context.push('/tabs'),
                          icon: const Icon(Icons.tab),
                          label: const Text('PUSH Tabs'),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => context.pushReplacement('/tabs'),
                        icon: const Icon(Icons.swap_horiz),
                        label: const Text('REPLACE con Tabs'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const Spacer(),
            
            // Nota explicativa
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: const Text(
                '💡 Nota: Observa el comportamiento del botón "atrás" con GO (reemplaza historial), PUSH (mantiene historial) y REPLACE (reemplaza pantalla actual).',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParameterRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  void _incrementViewCount() {
    setState(() {
      // setState() causa que build() se ejecute de nuevo
      print('DetailsScreen: setState() llamado - Contador: $_viewCount → ${_viewCount + 1}');
      _viewCounts[widget.itemId] = _viewCount + 1;
    });
  }

  @override
  void dispose() {
    // Se ejecuta UNA VEZ cuando el widget se destruye - para limpiar recursos
    print('DetailsScreen: dispose() - Widget destruido');
    super.dispose();
  }
}
