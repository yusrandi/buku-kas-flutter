part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class UserLoginEvent extends UserEvent {
  final String email;
  final String password;

  const UserLoginEvent({required this.email, required this.password});
}

class UserRegisterEvent extends UserEvent {
  final String name;
  final String email;
  final String password;

  const UserRegisterEvent(
      {required this.name, required this.email, required this.password});
}

class UserUpdateEvent extends UserEvent {
  final String id;
  final String name;
  final String password;
  const UserUpdateEvent(
      {required this.id, required this.name, required this.password});
}

class GetUserEvent extends UserEvent {
  final String id;

  const GetUserEvent({required this.id});
}

class UserLogOutEvent extends UserEvent {}

class UserCheckLoginEvent extends UserEvent {}
