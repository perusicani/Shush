import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'listening_event.dart';
part 'listening_state.dart';

class ListeningBloc extends Bloc<ListeningEvent, ListeningState> {
  ListeningBloc() : super(ListeningInitial());

  @override
  Stream<ListeningState> mapEventToState(
    ListeningEvent event,
  ) async* {
    
  }
}
