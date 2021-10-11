import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:irza/models/transaction_model.dart';
import 'package:irza/repositories/transaction_repo.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionRepo transactionRepo;

  TransactionBloc(this.transactionRepo) : super(TransactionInitialState());

  @override
  Stream<TransactionState> mapEventToState(TransactionEvent event) async* {
    if (event is TransactionFetchDataEvent) {
      try {
        yield TransactionLoadingState();
        await Future.delayed(const Duration(milliseconds: 30));
        final data = await transactionRepo.transFetchData(event.id);
        yield TransactionLoadedState(data);
      } catch (e) {
        yield TransactionErrorState(e.toString());
      }
    } else if (event is TransactionStoreEvent) {
      try {
        yield TransactionLoadingState();
        await Future.delayed(const Duration(milliseconds: 30));
        final data = await transactionRepo.transStore(event.transaction);

        if (data.responsecode == "1") {
          yield TransactionSuccessState(data.responsemsg);
        } else {
          yield TransactionErrorState(data.responsemsg);
        }
      } catch (e) {
        yield TransactionErrorState(e.toString());
      }
    } else if (event is TransactionUpdateEvent) {
      try {
        yield TransactionLoadingState();
        await Future.delayed(const Duration(milliseconds: 30));
        final data = await transactionRepo.transUpdate(event.transaction);

        if (data.responsecode == "1") {
          yield TransactionSuccessState(data.responsemsg);
        } else {
          yield TransactionErrorState(data.responsemsg);
        }
      } catch (e) {
        yield TransactionErrorState(e.toString());
      }
    } else if (event is TransactionDeleteEvent) {
      try {
        yield TransactionLoadingState();
        await Future.delayed(const Duration(milliseconds: 30));
        final data = await transactionRepo.transDelete(event.id);

        if (data.responsecode == "1") {
          yield TransactionSuccessState(data.responsemsg);
        } else {
          yield TransactionErrorState(data.responsemsg);
        }
      } catch (e) {
        yield TransactionErrorState(e.toString());
      }
    }
  }
}
