import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'student_results_state.dart';
part 'student_results_cubit.freezed.dart';

class StudentResultsCubit extends Cubit<StudentResultsState> {
  StudentResultsCubit() : super(StudentResultsState.initial());
}
