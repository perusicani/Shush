part of 'listening_bloc.dart';

@immutable
abstract class ListeningEvent {}

class StartListening extends ListeningEvent {
  final double volume;

  StartListening({this.volume});
}

class StopListening extends ListeningEvent {}

class UpdateListening extends ListeningEvent {}
