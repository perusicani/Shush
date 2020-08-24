part of 'listening_bloc.dart';

@immutable
abstract class ListeningState {}

class ListeningInitial extends ListeningState {}

//if i wanna change the ui
class Listening extends ListeningState {}

class NotListening extends ListeningState {
  final bool gender;
  NotListening({this.gender});
}

class UpdatedListening extends ListeningState{
  final double buffer;
  UpdatedListening({this.buffer});


  List<Object> get props => [buffer];
}
