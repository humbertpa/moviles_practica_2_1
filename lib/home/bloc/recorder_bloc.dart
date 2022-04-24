import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:practica_2_1/env.dart';
import 'package:record/record.dart';

part 'recorder_event.dart';
part 'recorder_state.dart';

class RecorderBloc extends Bloc<RecorderEvent, RecorderState> {
  RecorderBloc() : super(RecorderInitialState()) {
    on<RecordEvent>(_buscar);
  }

  FutureOr<void> _buscar(event, emit) async {
    final tmpPath = await _obtenerTempPath();
    print("tmpPath = $tmpPath");
    print("emit = $emit");
    final filePath = await doRecording(tmpPath, emit);
    File file = File(filePath!);
    String fileString = await fileConvert(file);

    var json = await _recieveResponse(fileString);

    if (json == null || json["result"] == null) {
      emit(RecorderErrorState());
    } else {
      try {
        print(json['result']);
        final String songName = json['result']['title'];
        final String artistName = json['result']['artist'];
        final String albumName = json['result']['album'];
        final String releaseDate = json['result']['release_date'];
        final String appleLink = json['result']['apple_music']['url'];
        final String spotifyLink =
            json['result']['spotify']['external_urls']['spotify'];
        final String albumCover =
            json['result']['spotify']['album']['images'][0]['url'];
        final String listenLink = json['result']['song_link'];

        emit(
          RecorderSuccessState(
            myData: {
              'cancion': songName,
              'artista': artistName,
              'album': albumName,
              'lanzamiento': releaseDate,
              'appleLink': appleLink,
              'spotifyLink': spotifyLink,
              'albumCover': albumCover,
              'listenLink': listenLink
            },
          ),
        );
      } catch (e) {
        print("Error: $e");
        emit(RecorderVacioState());
      }
    }
  }

  Future<String> _obtenerTempPath() async {
    Directory tempDir = await getTemporaryDirectory();
    return tempDir.path;
  }

  Future<String?> doRecording(String tmpPath, Emitter<dynamic> emit) async {
    print("=======================Se empezo a ejecutar dorRecording");
    final Record _record = Record();
    print("permission = ${await _record.hasPermission()}");
    try {
      //get permission
      bool permission = await _record.hasPermission();

      if (permission) {
        emit(RecorderListeningState());
        await _record.start(
          path: '${tmpPath}/test.m4a',
          encoder: AudioEncoder.AAC,
          bitRate: 128000,
          samplingRate: 44100,
        );
        await Future.delayed(Duration(seconds: 10));
        return await _record.stop();
      } else {
        emit(RecorderErrorState());
        print("Permission denied");
      }
    } catch (e) {
      //print(e);
    }
    return null;
  }

  Future _recieveResponse(String file) async {
    emit(RecorderFinishState());
    //print("Will start sending");
    http.Response response = await http.post(
      Uri.parse('https://api.audd.io/'),
      headers: {'Content-Type': 'multipart/form-data'},
      body: jsonEncode(
        <String, dynamic>{
          'api_token': Api_key,
          'return': 'apple_music,spotify',
          'audio': file,
          'method': 'recognize',
        },
      ),
    );
    if (response.statusCode == 200) {
      //print("Success");
      print(jsonDecode(response.body));
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load json');
    }
  }
}

Future<String> fileConvert(File file) async {
  List<int> fileBytes = await file.readAsBytes();
  String base64String = base64Encode(fileBytes);
  return base64String;
}
