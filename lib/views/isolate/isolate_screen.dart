import 'dart:async';
import 'dart:isolate';
import 'package:flutter/material.dart';
import '../../widgets/base_view.dart';

class IsolateView extends StatefulWidget {
  const IsolateView({super.key});

  @override
  State<IsolateView> createState() => _IsolateViewState();
}

class _IsolateViewState extends State<IsolateView> {
  int? _resultado;
  bool _isLoading = false;

  // *Función que lanza un Isolate
  Future<void> calcularFibonacci(int n) async {
    setState(() {
      _isLoading = true;
      _resultado = null;
    });

    // Canal de comunicación para recibir mensajes desde el isolate
    final receivePort = ReceivePort();

    // Creamos un isolate y le enviamos: el número + el puerto para responder
    await Isolate.spawn(_fibonacciIsolate, [n, receivePort.sendPort]);

    // Esperamos el primer mensaje del isolate
    final resultado = await receivePort.first as int;

    setState(() {
      _resultado = resultado;
      _isLoading = false;
    });
  }

  // *Función que se ejecuta dentro del Isolate
  static void _fibonacciIsolate(List<dynamic> args) {
    final int n = args[0];
    final SendPort sendPort = args[1];

    // Función recursiva para calcular fibonacci
    int fibonacci(int n) {
      if (n <= 1) return n;
      return fibonacci(n - 1) + fibonacci(n - 2);
    }

    final result = fibonacci(n);

    // Enviamos el resultado de vuelta al hilo principal
    sendPort.send(result);
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: "Isolate - Fibonacci",
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isLoading)
              const CircularProgressIndicator()
            else if (_resultado != null)
              Text(
                "Resultado: $_resultado",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              )
            else
              const Text(
                "Pulsa un botón para calcular",
                style: TextStyle(fontSize: 18),
              ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => calcularFibonacci(20),
              child: const Text("Calcular Fibonacci(20)"),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () => calcularFibonacci(40),
              child: const Text("Calcular Fibonacci(40)"),
            ),
          ],
        ),
      ),
    );
  }
}
