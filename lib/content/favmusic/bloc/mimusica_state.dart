part of 'mimusica_bloc.dart';

abstract class MiMusicaState extends Equatable {
  const MiMusicaState();

  @override
  List<Object> get props => [];
}

class MiMusicaInitial extends MiMusicaState {}

class MiMusicaSuccessState extends MiMusicaState {
  // lista de elementos de firebase "fshare collection"
  final List<dynamic> miMusica;

  MiMusicaSuccessState({required this.miMusica});

  @override
  List<Object> get props => [miMusica];
}

class MiMusicaErrorState extends MiMusicaState {}

class MiMusicaEmptyState extends MiMusicaState {}

class MiMusicaLoadingState extends MiMusicaState {}

class UpdateLoadingState extends MiMusicaState {}

class UpdateSuccessState extends MiMusicaState {}

class UpdateErrorState extends MiMusicaState {}
