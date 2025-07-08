import 'dart:async';

import 'package:flutter/material.dart';

class PomodoroScreen extends StatefulWidget {
  const PomodoroScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PomodoroScreenState createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends State<PomodoroScreen> {
  static const int workTime = 25 * 60; // 25 minutos
  static const int shortBreakTime = 5 * 60; // 5 minutos
  static const int longBreakTime = 15 * 60; // 15 minutos
  
  int _currentSeconds = workTime;
  Timer? _timer;
  bool _isRunning = false;
  int _cycles = 0;
  String _currentMode = 'Work';
  
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
  
  void _startTimer() {
    setState(() {
      _isRunning = true;
    });
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_currentSeconds > 0) {
        setState(() {
          _currentSeconds--;
        });
      } else {
        _completePhase();
      }
    });
  }
  
  void _completePhase() {
    _pauseTimer();
    
    // Tocar um som para notificar o final do ciclo
    
    setState(() {
      if (_currentMode == 'Work') {
        _cycles++;
        
        if (_cycles % 4 == 0) {
          // Após 4 ciclos de trabalho, fazer uma pausa longa
          _currentMode = 'Long Break';
          _currentSeconds = longBreakTime;
        } else {
          // Após um ciclo de trabalho normal, fazer uma pausa curta
          _currentMode = 'Short Break';
          _currentSeconds = shortBreakTime;
        }
      } else {
        // Após qualquer tipo de pausa, voltar ao modo trabalho
        _currentMode = 'Work';
        _currentSeconds = workTime;
      }
    });
    
    // Mostrar notificação
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$_currentMode time!'),
        duration: const Duration(seconds: 3),
      ),
    );
  }
  
  void _pauseTimer() {
    setState(() {
      _isRunning = false;
    });
    _timer?.cancel();
  }
  
  void _resetTimer() {
    _pauseTimer();
    
    setState(() {
      _currentMode = 'Work';
      _currentSeconds = workTime;
      _cycles = 0;
    });
  }
  
  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pomodoro Timer'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _timer?.cancel();
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Sair'),
                  content: const Text('Deseja voltar para a tela de login?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // Fecha o diálogo
                        Navigator.pushReplacementNamed(context, '/');
                      },
                      child: const Text('Sim'),
                    ),
                  ],
                ),
              );
            },
            tooltip: 'Voltar para o login',
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _currentMode,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: _currentMode == 'Work' 
                  ? Colors.red 
                  : _currentMode == 'Short Break' 
                      ? Colors.green 
                      : Colors.blue,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _formatTime(_currentSeconds),
              style: const TextStyle(
                fontSize: 80,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            Text(
              'Ciclos Concluídos: $_cycles',
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _isRunning ? _pauseTimer : _startTimer,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                  child: Icon(
                    _isRunning ? Icons.pause : Icons.play_arrow,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _resetTimer,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                  child: const Icon(
                    Icons.refresh,
                    size: 30,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                'A técnica Pomodoro consiste em trabalhar com foco total por 25 minutos e então fazer uma pausa de 5 minutos. A cada 4 ciclos, faça uma pausa maior de 15 minutos.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            )
          ],
        ),
      ),
    );
  }
}
