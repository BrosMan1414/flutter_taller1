import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../widgets/base_view.dart';

class FutureView extends StatefulWidget {
  const FutureView({super.key});

  @override
  State<FutureView> createState() => _FutureViewState();
}

class _FutureViewState extends State<FutureView> {
  List<String> _nombres = [];
  bool _cargando = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    obtenerDatos(); // carga al iniciar
  }

  // *Función que simula una carga de datos con posibilidad de error
  Future<List<String>> cargarNombres() async {
    print("- Simulando consulta de datos...");
    await Future.delayed(const Duration(seconds: 3));

    // Simula un error aleatorio (33% de probabilidad)
    if (Random().nextInt(3) == 0) {
      throw Exception(
        "Error al cargar los datos, la posibilidad de que esto pase es de 33%",
      );
    }

    return [
      'Monkey D. Luffy',
      'Roronoa Zoro',
      'Nami',
      'Usopp',
      'Sanji',
      'Tony Tony Chopper',
      'Nico Robin',
      'Franky',
      'Brook',
      'Jinbe',
      'Portgas D. Ace',
      'Gol D. Roger',
      'Shanks',
      'Trafalgar D. Law',
      'Eustass Kid',
      'Boa Hancock',
      'Donquixote Doflamingo',
      'Dracule Mihawk',
      'Kaido',
      'Big Mom',
    ];
  }

  // *Función que obtiene los datos y maneja estados
  Future<void> obtenerDatos() async {
    setState(() {
      _cargando = true;
      _error = null;
    });

    try {
      final datos = await cargarNombres();
      if (!mounted) return;
      setState(() {
        _nombres = datos;
        _cargando = false;
      });
      print("- Datos cargados correctamente");
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _cargando = false;
      });
      print("- Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: 'One Piece - Mugiwara',
      body: _cargando
          ? const Center(
              child: CircularProgressIndicator(), // estado de carga
            )
          : _error != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, color: Colors.red, size: 60),
                  const SizedBox(height: 10),
                  Text(
                    "Ups! Ocurrió un error:\n$_error",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: obtenerDatos,
                    icon: const Icon(Icons.refresh),
                    label: const Text("Reintentar"),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: GridView.builder(
                itemCount: _nombres.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // columnas
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 2.2,
                ),
                itemBuilder: (context, index) {
                  return Card(
                    color: Color(0xFF8B5CF6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 4,
                    child: Center(
                      child: Text(
                        _nombres[index],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
