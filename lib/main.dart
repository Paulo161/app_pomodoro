import 'package:flutter/material.dart';
import 'package:pomodoro_app/login_screen.dart';

void main(){
  runApp(Main());
}


class Main extends StatelessWidget {

  const Main({ super.key });

   @override
   Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        "/": (context) => LoginScreen()
      },
    );
  }
}