import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:practica_2_1/content/favmusic/bloc/mimusica_bloc.dart';
import 'package:practica_2_1/content/favmusic/item.dart';

class FavouritePage extends StatefulWidget {
  FavouritePage({Key? key}) : super(key: key);

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Favourite songs',
          style: GoogleFonts.lato(),
        ),
      ),
      body: BlocConsumer<MiMusicaBloc, MiMusicaState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is MiMusicaSuccessState) {
            return ListView.builder(
              itemCount: state.miMusica.length,
              itemBuilder: (BuildContext context, int index) {
                return ItemCargado(
                  Data: state.miMusica[index],
                );
              },
            );
          } else {
            return Text("no hay musica");
          }
        },
      ),
    );
  }
}
