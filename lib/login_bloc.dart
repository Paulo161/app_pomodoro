import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:pomodoro_app/login_event.dart';
import 'package:pomodoro_app/login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    final dio = Dio();
    
    if (event is LoginButtonPressed) {
      yield LoginLoading();

      try {
        // Replace this with your own login logic
        await Future.delayed(const Duration(seconds: 2));
        yield LoginSuccess();
      } catch (error) {
        yield LoginFailure(error: error.toString());
      }
    }
  }
}