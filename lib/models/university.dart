class University {
  final String id;
  final String nit;
  final String nombre;
  final String direccion;
  final String telefono;
  final String paginaWeb;

  University({
    required this.id,
    required this.nit,
    required this.nombre,
    required this.direccion,
    required this.telefono,
    required this.paginaWeb,
  });

  factory University.fromMap(String id, Map<String, dynamic> m) => University(
    id: id,
    nit: m['nit'] ?? '',
    nombre: m['nombre'] ?? '',
    direccion: m['direccion'] ?? '',
    telefono: m['telefono'] ?? '',
    paginaWeb: m['pagina_web'] ?? '',
  );

  Map<String, dynamic> toMap() => {
    'nit': nit,
    'nombre': nombre,
    'direccion': direccion,
    'telefono': telefono,
    'pagina_web': paginaWeb,
  };
}
