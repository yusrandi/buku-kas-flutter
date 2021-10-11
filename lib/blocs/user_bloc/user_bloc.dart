import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:irza/models/user_model.dart';
import 'package:irza/repositories/user_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserRepository repository;
  late SharedPreferences sharedpref;
  UserBloc(this.repository) : super(UserInitial());
  UserState get initialState => UserInitial();

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    if (event is UserCheckLoginEvent) {
      sharedpref = await SharedPreferences.getInstance();
      var data = sharedpref.get("name");
      var userId = sharedpref.get("id");
      if (data != null) {
        yield UserLoggedInState(
            userId: int.parse(userId.toString()), userEmail: data.toString());
      } else {
        yield UserLoggedOutState();
      }
    } else if (event is UserLogOutEvent) {
      sharedpref = await SharedPreferences.getInstance();
      await sharedpref.clear();
      yield UserLoggedOutState();
    } else if (event is UserLoginEvent) {
      try {
        yield UserLoadingState();
        await Future.delayed(const Duration(milliseconds: 30));
        final data = await repository.userLogin(event.email, event.password);
        yield UserGetSuccess(user: data);
      } catch (e) {
        yield UserGetError(error: e.toString());
      }
    } else if (event is UserRegisterEvent) {
      try {
        yield UserLoadingState();
        await Future.delayed(const Duration(milliseconds: 30));
        final data = await repository.userRegister(
            event.name, event.email, event.password);
        yield UserGetSuccess(user: data);
      } catch (e) {
        yield UserGetError(error: e.toString());
      }
    } else if (event is UserUpdateEvent) {
      try {
        yield UserLoadingState();
        await Future.delayed(const Duration(milliseconds: 30));
        final data =
            await repository.userUpdate(event.id, event.name, event.password);
        yield UserGetSuccess(user: data);
      } catch (e) {
        yield UserGetError(error: e.toString());
      }
    } else if (event is GetUserEvent) {
      yield UserLoadingState();
      await Future.delayed(const Duration(milliseconds: 30));
      final data = await repository.getUser(event.id);
      yield UserGetSuccess(user: data);
    }
  }
}
