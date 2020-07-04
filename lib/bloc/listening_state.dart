part of 'listening_bloc.dart';

@immutable
abstract class ListeningState {}

class ListeningInitial extends ListeningState {}

class Listening extends ListeningState {}

class NotListening extends ListeningState {}
