part of 'listening_bloc.dart';

@immutable
abstract class ListeningState {}

class ListeningInitial extends ListeningState {}

//if i wanna change the ui
class Listening extends ListeningState {
}

class NotListening extends ListeningState {
  final bool gender;
  NotListening({this.gender});
}
