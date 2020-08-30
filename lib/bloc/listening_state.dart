part of 'listening_bloc.dart';

@immutable
abstract class ListeningState {}

class ListeningInitial extends ListeningState {}

class Listening extends ListeningState {}

class NotListening extends ListeningState {
  final bool gender;
  NotListening({this.gender});
}

class UpdatedListening extends ListeningState{
  final double buffer;
  final double data;
  UpdatedListening({this.buffer, this.data});


  List<Object> get props => [buffer, data];
}
