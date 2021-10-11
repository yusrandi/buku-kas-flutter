part of 'user_category_bloc.dart';

abstract class UserCategoryEvent extends Equatable {
  const UserCategoryEvent();

  @override
  List<Object> get props => [];
}

class UserCategoryStoreEvent extends UserCategoryEvent {
  final String userId;
  final String categories;

  const UserCategoryStoreEvent(this.userId, this.categories);
}

class UserCategoryFecthEvent extends UserCategoryEvent {
  final String id;

  const UserCategoryFecthEvent(this.id);
}
