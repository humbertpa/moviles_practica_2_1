import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class ItemCargado extends StatefulWidget {
  final Map<String, dynamic> Data;
  ItemCargado({Key? key, required this.Data}) : super(key: key);

  @override
  State<ItemCargado> createState() => _ItemCargadoState();
}

class _ItemCargadoState extends State<ItemCargado> {
  @override
  Widget build(BuildContext context) {
    print(widget.Data);
    return Card(
      child: Stack(
        children: [
          //a sample view of an album cover
          Image.network(widget.Data["albumCover"]),

          Positioned(
            top: 10,
            left: 10,
            child: Icon(
              Icons.favorite,
              color: Colors.red,
              size: 30,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              //height is 20% of the card
              height: MediaQuery.of(context).size.height * 0.1,

              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.8),
                    Colors.black.withOpacity(0.0),
                  ],
                ),
              ),
              child: Column(
                children: [
                  Center(
                    child: Text(
                      widget.Data['cancion'],
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      widget.Data["artista"],
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
