import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'song_event.dart';
part 'song_state.dart';

class SongBloc extends Bloc<SongEvent, SongState> {
  SongBloc() : super(SongInitial()) {
    on<OnLikedSongEvent>(_likeSong);
  }

  FutureOr<void> _likeSong(event, emit) async {
    emit(LikeLoadingState());
    bool liked = await _saveSong(event.songData);
    emit(liked ? LikeSuccessState() : LikeErrorState());
  }

  Future<bool> _saveSong(Map<dynamic, dynamic> dataToSave) async {
    try {
      String str = json.encode(dataToSave);
      print(str);

      var queryUser = await FirebaseFirestore.instance
          .collection("users")
          .doc("${FirebaseAuth.instance.currentUser!.uid}");

      var docsRef = await queryUser.get();
      List<dynamic> jsons = docsRef.data()?["user-favourites"];
      jsons.add(str);
      await queryUser.update({"user-favourites": jsons});
      return true;
    } catch (e) {
      print("Error al actualizar users collection: $e");
      return false;
    }
  }
}
