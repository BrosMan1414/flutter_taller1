import 'dart:async';
import 'package:flutter/material.dart';
import '../../widgets/base_view.dart';

class TimerView extends StatefulWidget {
  const TimerView({super.key});

  @override
  State<TimerView> createState() => _TimerViewState();
}

class _TimerViewState extends State<TimerView> {
  Timer? _timer;
  int _seconds = 0; // tiempo en segundos
  bool _isRunning = false;

  // *Inicia el cronómetro
  void startTimer() {
    if (_isRunning) return;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
    });
    setState(() {
      _isRunning = true;
    });
  }

  // *Pausa el cronómetro
  void pauseTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
    });
  }

  // *Reanuda (igual que iniciar, pero sigue desde donde quedó)
  void resumeTimer() {
    startTimer();
  }

  // *Reinicia el cronómetro
  void resetTimer() {
    _timer?.cancel();
    setState(() {
      _seconds = 0;
      _isRunning = false;
    });
  }

  // *Limpieza de recursos al salir de la vista
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // *Formato mm:ss
  String formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$secs";
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: 'Cronómetro con Timer',
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Texto grande del cronómetro
            Text(
              formatTime(_seconds),
              style: const TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            // Grupo de controles: primera fila (acciones principales)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: startTimer,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text("Iniciar"),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: pauseTimer,
                  icon: const Icon(Icons.pause),
                  label: const Text("Pausar"),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: resumeTimer,
                  icon: const Icon(Icons.play_circle_fill),
                  label: const Text("Reanudar"),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Botón reiniciar centrado con mayor separación
            ElevatedButton.icon(
              onPressed: resetTimer,
              icon: const Icon(Icons.restart_alt),
              label: const Text("Reiniciar"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
