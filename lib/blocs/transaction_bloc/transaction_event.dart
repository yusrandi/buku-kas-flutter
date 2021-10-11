part of 'transaction_bloc.dart';

abstract class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object> get props => [];
}

class TransactionFetchDataEvent extends TransactionEvent {
  final String id;

  const TransactionFetchDataEvent(this.id);
}

class TransactionStoreEvent extends TransactionEvent {
  final Transaction transaction;

  const TransactionStoreEvent(this.transaction);
}

class TransactionUpdateEvent extends TransactionEvent {
  final Transaction transaction;

  const TransactionUpdateEvent(this.transaction);
}

class TransactionDeleteEvent extends TransactionEvent {
  final String id;

  const TransactionDeleteEvent(this.id);
}
