part of 'currentnoiselvl_bloc.dart';

abstract class CurrentnoiselvlState extends Equatable {
  const CurrentnoiselvlState();
  
  @override
  List<Object> get props => [];
}

class CurrentnoiselvlInitial extends CurrentnoiselvlState {}

class ListeningCurrentNoiseLvl extends CurrentnoiselvlState {
  final double data;
  ListeningCurrentNoiseLvl({this.data});

  @override
  List<Object> get props => [data];
}
