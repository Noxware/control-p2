import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'viewer_state.dart';

class ViewerCubit extends Cubit<ViewerState> {
  ViewerCubit() : super(ViewerInitial());
}
