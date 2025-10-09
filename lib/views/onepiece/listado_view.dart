import 'package:flutter/material.dart';
import '../../models/character.dart';
import 'package:go_router/go_router.dart';
import '../../services/one_piece_service.dart';
import '../../widgets/base_view.dart';

class ListadoView extends StatefulWidget {
  const ListadoView({super.key});

  @override
  State<ListadoView> createState() => _ListadoViewState();
}

class _ListadoViewState extends State<ListadoView> {
  late final OnePieceService _service;
  late Future<List<Character>> _future;

  @override
  void initState() {
    super.initState();
    _service = OnePieceService();
    _future = _service.fetchCharacters();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: 'One Piece - Personajes',
      body: FutureBuilder<List<Character>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Ocurrió un error al cargar los personajes.\n${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _future = _service.fetchCharacters();
                        });
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
            );
          }

          final results = snapshot.data ?? const <Character>[];
          if (results.isEmpty) {
            return const Center(child: Text('No se encontraron personajes.'));
          }

          return ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              final c = results[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage:
                      c.avatarSrc != null && c.avatarSrc!.isNotEmpty
                      ? NetworkImage(c.avatarSrc!)
                      : null,
                  child: (c.avatarSrc == null || c.avatarSrc!.isEmpty)
                      ? const Icon(Icons.person)
                      : null,
                ),
                title: Text(c.englishName),
                subtitle: Text(
                  [
                    if (c.bounty != null) 'Bounty: ${c.bounty}',
                    if (c.devilFruitName != null) 'Fruta: ${c.devilFruitName}',
                  ].join('  •  '),
                ),
                onTap: () {
                  // Navegar a detalle usando go_router y pasando el objeto como extra
                  context.pushNamed('onepiece_detail', extra: c);
                },
              );
            },
          );
        },
      ),
    );
  }
}
