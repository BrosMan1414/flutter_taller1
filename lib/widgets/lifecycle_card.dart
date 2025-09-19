import 'package:flutter/material.dart';

class LifecycleCard extends StatefulWidget {
  const LifecycleCard({super.key});

  @override
  State<LifecycleCard> createState() => _LifecycleCardState();
}

class _LifecycleCardState extends State<LifecycleCard> {
  int _rebuildCount = 0;
  String _lastAction = 'Ninguna';

  @override
  void initState() {
    super.initState();
    // Se ejecuta UNA SOLA VEZ cuando se crea el widget
    print('LifecycleCard: initState() ejecutado');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Se ejecuta después de initState y cuando cambian las dependencias
    print('LifecycleCard: didChangeDependencies() ejecutado');
  }

  @override
  Widget build(BuildContext context) {
    // Se ejecuta CADA VEZ que el widget necesita reconstruirse
    _rebuildCount++;
    print('LifecycleCard: build() ejecutado (#$_rebuildCount)');
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 6,
        color: Colors.purple.shade50,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.refresh, color: Colors.purple, size: 32),
                  const SizedBox(width: 12),
                  Text(
                    'Ciclo de Vida del Widget',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              _buildLifecycleInfo('Builds ejecutados:', '$_rebuildCount'),
              _buildLifecycleInfo('Última acción:', _lastAction),
              
              const SizedBox(height: 20),
              
              // Botones para demostrar diferentes aspectos del ciclo de vida
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _performAction('setState llamado'),
                    icon: const Icon(Icons.refresh, size: 18),
                    label: const Text('Trigger setState'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _performAction('Rebuild forzado'),
                    icon: const Icon(Icons.build, size: 18),
                    label: const Text('Force Rebuild'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple.shade300,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
              
              // Información explicativa
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.purple.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.purple.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '📋 Métodos del Ciclo de Vida:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.purple.shade800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildLifecycleMethod('initState()', 'Inicialización única del widget'),
                    _buildLifecycleMethod('didChangeDependencies()', 'Cambios en dependencias'),
                    _buildLifecycleMethod('build()', 'Construcción/reconstrucción de UI'),
                    _buildLifecycleMethod('setState()', 'Actualización de estado'),
                    _buildLifecycleMethod('dispose()', 'Limpieza antes de destruir'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLifecycleInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          SizedBox(
            width: 140,
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
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLifecycleMethod(String method, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• $method: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.purple.shade700,
              fontSize: 12,
            ),
          ),
          Expanded(
            child: Text(
              description,
              style: TextStyle(
                color: Colors.purple.shade600,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _performAction(String action) {
    setState(() {
      // setState() causa que build() se ejecute de nuevo
      print('LifecycleCard: setState() llamado - $action');
      _lastAction = action;
    });
  }

  @override
  void dispose() {
    // Se ejecuta UNA VEZ cuando el widget se destruye - para limpiar recursos
    print('LifecycleCard: dispose() - Widget destruido');
    super.dispose();
  }
}
