part of 'mimusica_bloc.dart';

abstract class MiMusicaEvent extends Equatable {
  const MiMusicaEvent();

  @override
  List<Object> get props => [];
}

class GetMySongsEvent extends MiMusicaEvent {}
