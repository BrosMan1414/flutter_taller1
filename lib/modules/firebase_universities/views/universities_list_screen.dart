import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../models/university.dart';
import '../university_service.dart';

class UniversitiesListScreen extends StatefulWidget {
  final UniversityService service;

  UniversitiesListScreen({Key? key, required this.service}) : super(key: key);

  @override
  _UniversitiesListScreenState createState() => _UniversitiesListScreenState();
}

class _UniversitiesListScreenState extends State<UniversitiesListScreen> {
  UniversityService get service => widget.service;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Universidades')),
      body: StreamBuilder<List<University>>(
        stream: service.streamUniversities(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            final err = snapshot.error;
            // Improve error message for permission denied
            if (err is FirebaseException && err.code == 'permission-denied') {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Error: permisos denegados en Firestore',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'La aplicación no tiene permiso para leer la colección `universidades`.\n'
                      'Para desarrollo puedes cambiar las reglas de Firestore en la consola de Firebase (Firestore -> Rules) o habilitar acceso público temporalmente.',
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => setState(() {}),
                      child: const Text('Reintentar'),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        showDialog<void>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Cómo arreglar reglas Firestore'),
                            content: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    '1. Abre Firebase Console -> Firestore -> Rules',
                                  ),
                                  SizedBox(height: 8),
                                  Text('2. Para desarrollo temporal pega:'),
                                  SizedBox(height: 8),
                                  Text(
                                    "rules_version = '2';\nservice cloud.firestore {\n  match /databases/{database}/documents {\n    match /{document=**} {\n      allow read, write: if true;\n    }\n  }\n}",
                                    style: TextStyle(fontFamily: 'monospace'),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    '3. Pulsa Publish. Luego prueba la app otra vez.',
                                  ),
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(ctx).pop(),
                                child: const Text('Cerrar'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: const Text('Cómo arreglar'),
                    ),
                  ],
                ),
              );
            }

            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final list = snapshot.data ?? [];
          if (list.isEmpty) {
            return const Center(child: Text('No hay universidades aún.'));
          }
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, i) {
              final u = list[i];
              return ListTile(
                title: Text(u.nombre),
                subtitle: Text(u.direccion),
                trailing: PopupMenuButton<String>(
                  onSelected: (v) async {
                    if (v == 'edit') {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => NewUniversityScreen(
                            service: service,
                            university: u,
                          ),
                        ),
                      );
                    } else if (v == 'delete') {
                      await service.deleteUniversity(u.id);
                    }
                  },
                  itemBuilder: (_) => [
                    const PopupMenuItem(value: 'edit', child: Text('Editar')),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Text('Eliminar'),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => NewUniversityScreen(service: service),
            ),
          );
        },
      ),
    );
  }
}

class NewUniversityScreen extends StatefulWidget {
  final UniversityService service;
  final University? university;

  NewUniversityScreen({Key? key, required this.service, this.university})
    : super(key: key);

  @override
  _NewUniversityScreenState createState() => _NewUniversityScreenState();
}

class _NewUniversityScreenState extends State<NewUniversityScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nitC;
  late TextEditingController nombreC;
  late TextEditingController direccionC;
  late TextEditingController telefonoC;
  late TextEditingController paginaC;

  @override
  void initState() {
    super.initState();
    nitC = TextEditingController(text: widget.university?.nit ?? '');
    nombreC = TextEditingController(text: widget.university?.nombre ?? '');
    direccionC = TextEditingController(
      text: widget.university?.direccion ?? '',
    );
    telefonoC = TextEditingController(text: widget.university?.telefono ?? '');
    paginaC = TextEditingController(text: widget.university?.paginaWeb ?? '');
  }

  @override
  void dispose() {
    nitC.dispose();
    nombreC.dispose();
    direccionC.dispose();
    telefonoC.dispose();
    paginaC.dispose();
    super.dispose();
  }

  bool isValidUrl(String s) {
    final uri = Uri.tryParse(s);
    return uri != null &&
        (uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https'));
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final u = University(
      id: widget.university?.id ?? '',
      nit: nitC.text.trim(),
      nombre: nombreC.text.trim(),
      direccion: direccionC.text.trim(),
      telefono: telefonoC.text.trim(),
      paginaWeb: paginaC.text.trim(),
    );
    if (widget.university == null) {
      await widget.service.createUniversity(u);
    } else {
      await widget.service.updateUniversity(widget.university!.id, u.toMap());
    }
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.university != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(editing ? 'Editar Universidad' : 'Nueva Universidad'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nitC,
                decoration: const InputDecoration(labelText: 'NIT'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'NIT es requerido' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: nombreC,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Nombre es requerido'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: direccionC,
                decoration: const InputDecoration(labelText: 'Dirección'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: telefonoC,
                decoration: const InputDecoration(labelText: 'Teléfono'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: paginaC,
                decoration: const InputDecoration(labelText: 'Página web'),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return null;
                  return isValidUrl(v.trim()) ? null : 'URL inválida';
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _save,
                  child: const Text('Guardar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
