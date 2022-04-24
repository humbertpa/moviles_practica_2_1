part of 'recorder_bloc.dart';

abstract class RecorderState extends Equatable {
  const RecorderState();

  @override
  List<Object> get props => [];
}

class RecorderInitialState extends RecorderState {}

class RecorderListeningState extends RecorderState {}

class RecorderFinishState extends RecorderState {}

class RecorderErrorState extends RecorderState {}

class RecorderVacioState extends RecorderState {}

class RecorderSuccessState extends RecorderState {
  final Map<String, dynamic> myData;

  RecorderSuccessState({required this.myData});

  /*  String cancion;
  String artista;
  String album;
  String lanzamiento;
  String appleLink;
  String spotifyLink;
  String albumCover;
  String listenLink;

  RecorderSuccessState({
    required this.cancion,
    required this.artista,
    required this.album,
    required this.lanzamiento,
    required this.appleLink,
    required this.spotifyLink,
    required this.albumCover,
    required this.listenLink,
  }); */
}
