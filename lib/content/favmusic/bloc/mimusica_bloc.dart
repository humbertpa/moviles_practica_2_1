import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'mimusica_event.dart';
part 'mimusica_state.dart';

class MiMusicaBloc extends Bloc<MiMusicaEvent, MiMusicaState> {
  MiMusicaBloc() : super(MiMusicaInitial()) {
    on<MiMusicaEvent>(_getMiMusica);
  }

  FutureOr<void> _getMiMusica(event, emit) async {
    emit(MiMusicaLoadingState());
    try {
      // query para traer el documento con el id del usuario autenticado
      var queryUser = await FirebaseFirestore.instance
          .collection("users")
          .doc("${FirebaseAuth.instance.currentUser!.uid}");

      // query para sacar la data del documento
      var docsRef = await queryUser.get();

      var listaCanciones = docsRef.data()?["user-favourites"];

      var misCanciones = listaCanciones.map((cancion) {
        Map<String, dynamic> mapilla = {};
        jsonDecode(cancion).forEach((k, v) {
          mapilla[k] = v;
        });
        return mapilla;
      }).toList();
      print("=========senalizacion=======================");

      print(misCanciones[0].runtimeType);

      //myContentList.forEach((mapa) => print("${mapa["id"]}\n"));

      // lista de documentos filtrados del usuario con sus datos de fotos en espera
      emit(MiMusicaSuccessState(miMusica: misCanciones));
    } catch (e) {
      print("Error al obtener items en espera: $e");
      emit(MiMusicaErrorState());
      emit(MiMusicaEmptyState());
    }
  }
}
