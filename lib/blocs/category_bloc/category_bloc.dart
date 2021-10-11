import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:irza/models/category_model.dart';
import 'package:irza/repositories/category_repo.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository repository;

  CategoryBloc(this.repository) : super(CategoryInitialState());

  @override
  Stream<CategoryState> mapEventToState(CategoryEvent event) async* {
    if (event is CategoryFetchDataEvent) {
      try {
        yield CategoryLoadingState();
        await Future.delayed(const Duration(milliseconds: 30));
        final data = await repository.categoryFetchData();
        yield CategoryLoadedState(data);
      } catch (e) {}
    }
  }
}
