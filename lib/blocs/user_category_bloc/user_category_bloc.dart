import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:irza/models/user_category_model.dart';
import 'package:irza/repositories/user_category_repo.dart';

part 'user_category_event.dart';
part 'user_category_state.dart';

class UserCategoryBloc extends Bloc<UserCategoryEvent, UserCategoryState> {
  final UserCategoryRepository usercategoryRepo;

  UserCategoryBloc(this.usercategoryRepo) : super(UserCategoryInitialState());

  @override
  Stream<UserCategoryState> mapEventToState(UserCategoryEvent event) async* {
    if (event is UserCategoryStoreEvent) {
      try {
        yield UserCategoryLoadingState();
        await Future.delayed(const Duration(milliseconds: 30));
        final data = await usercategoryRepo.userCategoryStore(
            event.userId, event.categories);

        if (data.responsecode == "1") {
          yield UserCategorySuccessState(data.responsemsg);
        } else {
          yield UserCategoryErrorState(data.responsemsg);
        }
      } catch (e) {
        yield UserCategoryErrorState(e.toString());
      }
    } else if (event is UserCategoryFecthEvent) {
      try {
        yield UserCategoryLoadingState();
        await Future.delayed(const Duration(milliseconds: 30));
        final data = await usercategoryRepo.userCategoryFetchData(event.id);
        yield UserCategoryLoadedState(data);
      } catch (e) {
        yield UserCategoryErrorState(e.toString());
      }
    }
  }
}
