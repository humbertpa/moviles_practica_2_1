part of 'song_bloc.dart';

abstract class SongState extends Equatable {
  const SongState();

  @override
  List<Object> get props => [];
}

class SongInitial extends SongState {}

class LikeSuccessState extends SongState {}

class LikeErrorState extends SongState {}

class LikeLoadingState extends SongState {}
