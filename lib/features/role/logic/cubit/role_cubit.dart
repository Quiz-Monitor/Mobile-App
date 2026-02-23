import 'package:examify/features/role/domain/user_role.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class RoleCubit extends Cubit<UserRole> {
  RoleCubit() : super(UserRole.student);

  void selectRole(UserRole role) => emit(role);
}