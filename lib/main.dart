import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomodoro_app/login_bloc.dart';
import 'package:pomodoro_app/login_screen.dart';
import 'package:pomodoro_app/pomodoro_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pomodoro App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => BlocProvider(
          create: (context) => LoginBloc(),
          child: const LoginScreen(),
        ),
        '/pomodoro': (context) => const PomodoroScreen(),
      },
    );
  }
}