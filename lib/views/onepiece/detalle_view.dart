import 'package:flutter/material.dart';
import '../../models/character.dart';
import '../../widgets/base_view.dart';

class DetalleView extends StatelessWidget {
  final Character character;
  const DetalleView({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    final c = character;

    return BaseView(
      title: c.englishName,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: c.avatarSrc != null && c.avatarSrc!.isNotEmpty
                    ? NetworkImage(c.avatarSrc!)
                    : null,
                child: (c.avatarSrc == null || c.avatarSrc!.isEmpty)
                    ? const Icon(Icons.person, size: 48)
                    : null,
              ),
            ),
            const SizedBox(height: 24),
            _info('Nombre', c.englishName),
            _info('Edad', c.age?.toString()),
            _info('Cumpleaños', c.birthday),
            _info('Recompensa', c.bounty),
            _info('Fruta del Diablo', c.devilFruitName),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton.icon(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Volver'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _info(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value ?? '—')),
        ],
      ),
    );
  }
}
