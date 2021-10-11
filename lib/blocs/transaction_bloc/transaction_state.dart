part of 'transaction_bloc.dart';

abstract class TransactionState extends Equatable {
  const TransactionState();

  @override
  List<Object> get props => [];
}

class TransactionInitialState extends TransactionState {}

class TransactionLoadingState extends TransactionState {}

class TransactionSuccessState extends TransactionState {
  final String msg;
  const TransactionSuccessState(this.msg);
}

class TransactionErrorState extends TransactionState {
  final String msg;
  const TransactionErrorState(this.msg);
}

class TransactionLoadedState extends TransactionState {
  final TransactionModel model;
  const TransactionLoadedState(this.model);
}
