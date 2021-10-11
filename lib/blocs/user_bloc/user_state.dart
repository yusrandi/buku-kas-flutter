part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}

class UserGetError extends UserState {
  final String error;
  const UserGetError({required this.error});
}

class UserGetSuccess extends UserState {
  final UserModel user;
  const UserGetSuccess({required this.user});
}

class UserLoggedInState extends UserState {
  final String userEmail;
  final int userId;

  const UserLoggedInState({required this.userId, required this.userEmail});
}

class UserLoggedOutState extends UserState {}

class UserLoadingState extends UserState {}
