import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:pomodoro_app/login_event.dart';
import 'package:pomodoro_app/login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://flutter-start-api.onrender.com',
    connectTimeout: const Duration(milliseconds: 10000),
    receiveTimeout: const Duration(milliseconds: 10000),
    contentType: 'application/json',
  ));
  
  LoginBloc() : super(LoginInitial()) {
    on<LoginButtonPressed>(_onLoginButtonPressed);
    on<RegisterButtonPressed>(_onRegisterButtonPressed);
  }

  Future<void> _onLoginButtonPressed(
    LoginButtonPressed event, 
    Emitter<LoginState> emit
  ) async {
    emit(LoginLoading());

    try {
      // Validação de campos vazios
      if (event.email.isEmpty || event.password.isEmpty) {
        emit(const LoginFailure(error: 'Email e senha são obrigatórios'));
        return;
      }

      // Fazendo requisição real para autenticação
      final response = await _dio.post(
        '/Auth/login',
        data: {
          'Email': event.email,
          'Senha': event.password,
        },
      );
      
      if (response.statusCode == 200) {
        // Login bem-sucedido
        emit(LoginSuccess());
      } else {
        // Erro de login
        emit(const LoginFailure(error: 'Falha na autenticação. Verifique suas credenciais.'));
      }
    } catch (error) {
      if (error is DioException) {
        if (error.response?.statusCode == 401) {
          emit(const LoginFailure(error: 'Email ou senha incorretos'));
        } else {
          emit(LoginFailure(error: 'Erro de conexão: ${error.message}'));
        }
      } else {
        emit(LoginFailure(error: 'Erro inesperado: ${error.toString()}'));
      }
    }
  }
  
  Future<void> _onRegisterButtonPressed(
    RegisterButtonPressed event, 
    Emitter<LoginState> emit
  ) async {
    emit(LoginLoading());

    try {
      // Validação de campos vazios
      if (event.name.isEmpty || event.email.isEmpty || event.password.isEmpty) {
        emit(const LoginFailure(error: 'Todos os campos são obrigatórios'));
        return;
      }

      // Fazendo requisição real para registro
      final response = await _dio.post(
        '/Auth/register',
        data: {
          'Nome': event.name,
          'Email': event.email,
          'Senha': event.password,
        },
      );
      
      if (response.statusCode == 200) {
        // Registro bem-sucedido
        emit(RegisterSuccess());
      } else {
        // Erro de registro
        emit(const LoginFailure(error: 'Falha no registro. Tente novamente.'));
      }
    } catch (error) {
      if (error is DioException) {
        if (error.response?.statusCode == 400) {
          emit(const LoginFailure(error: 'Email já cadastrado ou dados inválidos'));
        } else {
          emit(LoginFailure(error: 'Erro de conexão: ${error.message}'));
        }
      } else {
        emit(LoginFailure(error: 'Erro inesperado: ${error.toString()}'));
      }
    }
  }
}