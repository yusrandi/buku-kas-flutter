part of 'user_category_bloc.dart';

abstract class UserCategoryState extends Equatable {
  const UserCategoryState();

  @override
  List<Object> get props => [];
}

class UserCategoryInitialState extends UserCategoryState {}

class UserCategoryLoadingState extends UserCategoryState {}

class UserCategorySuccessState extends UserCategoryState {
  final String msg;
  const UserCategorySuccessState(this.msg);
}

class UserCategoryErrorState extends UserCategoryState {
  final String msg;
  const UserCategoryErrorState(this.msg);
}

class UserCategoryLoadedState extends UserCategoryState {
  final UserCategoryModel model;
  const UserCategoryLoadedState(this.model);
}
