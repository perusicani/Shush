part of 'listening_bloc.dart';

@immutable
abstract class ListeningEvent {}

class StartListening extends ListeningEvent {}

class StopListening extends ListeningEvent {}
