part of 'currentnoiselvl_bloc.dart';

abstract class CurrentnoiselvlEvent extends Equatable {
  const CurrentnoiselvlEvent();

  @override
  List<Object> get props => [];
}

class StartListeningCurrentNoiseLvl extends CurrentnoiselvlEvent {} 

class StopListeningCurrentNoiseLvl extends CurrentnoiselvlEvent {} 

class UpdateCurrentNoiseLvl extends CurrentnoiselvlEvent {}
