import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  int _currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    // Se ejecuta UNA SOLA VEZ cuando se crea el widget
    print('TabsScreen: initState() ejecutado');
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging && _tabController.index != _currentTabIndex) {
        setState(() {
          print('TabsScreen: setState() llamado - Tab: ${_currentTabIndex + 1} → ${_tabController.index + 1}');
          _currentTabIndex = _tabController.index;
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Se ejecuta después de initState y cuando cambian las dependencias
    print('TabsScreen: didChangeDependencies() ejecutado');
  }

  @override
  Widget build(BuildContext context) {
    // Se ejecuta CADA VEZ que el widget necesita reconstruirse
    print('TabsScreen: build() ejecutado');
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Pantalla con Tabs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () => context.go('/'),
            tooltip: 'Ir a Home',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.info), text: 'Info'),
            Tab(icon: Icon(Icons.list), text: 'Lista'),
            Tab(icon: Icon(Icons.settings), text: 'Config'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildInfoTab(),
          _buildListTab(),
          _buildConfigTab(),
        ],
      ),
    );
  }

  Widget _buildInfoTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info, color: Colors.blue, size: 32),
                      const SizedBox(width: 12),
                      Text(
                        'Información del Taller',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildInfoRow('Taller:', 'Navegación y Ciclo de Vida'),
                  _buildInfoRow('Framework:', 'Flutter con Dart'),
                  _buildInfoRow('Navegación:', 'go_router'),
                  _buildInfoRow('Tab actual:', 'Tab ${_currentTabIndex + 1} (${_getTabName(_currentTabIndex)})'),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: const Text(
                      '📋 Este tab demuestra el uso de TabBar como widget solicitado en el taller.',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListTab() {
    final List<Map<String, dynamic>> items = [
      {'id': 'tutorial-1', 'title': 'Tutorial de GridView', 'description': 'Aprende a usar GridView en Flutter', 'icon': Icons.grid_view, 'category': 'Widgets'},
      {'id': 'tutorial-2', 'title': 'Navegación con go_router', 'description': 'Implementa navegación avanzada', 'icon': Icons.navigation, 'category': 'Navegación'},
      {'id': 'tutorial-3', 'title': 'Ciclo de Vida', 'description': 'Comprende el lifecycle de widgets', 'icon': Icons.refresh, 'category': 'Conceptos'},
      {'id': 'tutorial-4', 'title': 'TabBar y TabView', 'description': 'Crea interfaces con pestañas', 'icon': Icons.tab, 'category': 'Widgets'},
      {'id': 'tutorial-5', 'title': 'setState y Estado', 'description': 'Manejo de estado en Flutter', 'icon': Icons.settings, 'category': 'Estado'},
      {'id': 'tutorial-6', 'title': 'Cards y Material', 'description': 'Diseña con Material Design', 'icon': Icons.credit_card, 'category': 'UI/UX'},
      {'id': 'tutorial-7', 'title': 'Responsive Design', 'description': 'Adapta tu app a diferentes pantallas', 'icon': Icons.phone_android, 'category': 'Diseño'},
      {'id': 'tutorial-8', 'title': 'Testing en Flutter', 'description': 'Pruebas unitarias y de widgets', 'icon': Icons.bug_report, 'category': 'Testing'},
    ];
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.library_books, color: Colors.green, size: 32),
                      const SizedBox(width: 12),
                      Text(
                        'Lista de Tutoriales Flutter',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Esta lista demuestra el uso de ListView.builder con datos complejos. Cada elemento navega a la pantalla de detalles pasando parámetros específicos.',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.green,
                      child: Icon(item['icon'], color: Colors.white, size: 20),
                    ),
                    title: Text(
                      item['title'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item['description']),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            item['category'],
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.arrow_forward_ios, size: 18),
                      onPressed: () {
                        context.push('/details/${item['id']}?title=${item['title']}&description=${item['description']} - Categoría: ${item['category']}');
                      },
                    ),
                    onTap: () {
                      context.push('/details/${item['id']}?title=${item['title']}&description=${item['description']} - Categoría: ${item['category']}');
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfigTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.settings, color: Colors.orange, size: 32),
                      const SizedBox(width: 12),
                      Text(
                        'Configuración y Navegación',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Opciones de navegación disponibles:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => context.go('/'),
                      icon: const Icon(Icons.home),
                      label: const Text('Ir a Home (GO)'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => context.push('/details/config?title=Desde Config&description=Navegado desde el tab de configuración'),
                      icon: const Icon(Icons.info),
                      label: const Text('Ver Detalles (PUSH)'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => context.pushReplacement('/'),
                      icon: const Icon(Icons.swap_horiz),
                      label: const Text('Reemplazar con Home (REPLACE)'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getTabName(int index) {
    switch (index) {
      case 0:
        return 'Info';
      case 1:
        return 'Lista';
      case 2:
        return 'Config';
      default:
        return 'Info';
    }
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
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
      ),
    );
  }

  @override
  void dispose() {
    // Se ejecuta UNA VEZ cuando el widget se destruye - para limpiar recursos
    print('TabsScreen: dispose() - Widget destruido');
    _tabController.dispose();
    super.dispose();
  }
}
