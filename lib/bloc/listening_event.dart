part of 'listening_bloc.dart';

@immutable
abstract class ListeningEvent {}

class StartListening extends ListeningEvent {
  final double volume;
  final String path;

  StartListening({this.volume, this.path});
}

class StopListening extends ListeningEvent {}
