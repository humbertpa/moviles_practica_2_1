part of 'song_bloc.dart';

abstract class SongEvent extends Equatable {
  const SongEvent();

  @override
  List<Object> get props => [];
}

class OnLikedSongEvent extends SongEvent {
  final Map<dynamic, dynamic> songData;

  OnLikedSongEvent({required this.songData});
  @override
  List<Object> get props => [songData];
}
