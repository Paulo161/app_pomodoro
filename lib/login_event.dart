import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginButtonPressed extends LoginEvent {
  final String email;
  final String password;

  const LoginButtonPressed({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];

  @override
  String toString() => 'LoginButtonPressed { email: $email, password: $password }';
}

class RegisterButtonPressed extends LoginEvent {
  final String name;
  final String email;
  final String password;

  const RegisterButtonPressed({
    required this.name,
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [name, email, password];

  @override
  String toString() => 'RegisterButtonPressed { name: $name, email: $email }';
}