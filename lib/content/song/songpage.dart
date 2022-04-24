import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import 'bloc/song_bloc.dart';

class SongPage extends StatefulWidget {
  final Map datos;
  SongPage({Key? key, required this.datos}) : super(key: key);

  @override
  State<SongPage> createState() => _SongPageState();
}

void _launchURL(_url) async {
  if (!await launch(_url)) throw 'Could not launch $_url';
}

class _SongPageState extends State<SongPage> {
  var _listn = "https://lis.tn/InspireTheLiars";
  var _iconsize = 40.0;

  @override
  Widget build(BuildContext context) {
    //return song page
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              BlocProvider.of<SongBloc>(context)
                  .add(OnLikedSongEvent(songData: widget.datos));
            },
            icon: Icon(Icons.favorite_border),
          ),
        ],
        title: Text(
          "Here you go!",
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.network(widget.datos["albumCover"]),
            SizedBox(height: 20),
            Text(widget.datos["cancion"],
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            Text(widget.datos["artista"], style: TextStyle(fontSize: 18)),
            SizedBox(height: 5),
            Text(widget.datos["album"], style: TextStyle(fontSize: 15)),
            SizedBox(height: 5),
            Text(widget.datos["lanzamiento"], style: TextStyle(fontSize: 15)),
            Divider(
              height: 30,
              thickness: 1,
              indent: 20,
              endIndent: 20,
              color: Colors.black26,
            ),
            Text("Open song in:",
                style: TextStyle(
                  fontSize: 13,
                )),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  iconSize: _iconsize,
                  onPressed: () {
                    _launchURL(widget.datos["appleLink"]);
                  },
                  icon: Icon(Icons.apple),
                ),
                IconButton(
                  iconSize: _iconsize,
                  onPressed: () {
                    _launchURL(widget.datos["spotifyLink"]);
                  },
                  icon: Image.asset(
                    'assets/spotify.png',
                    height: 30,
                  ),
                ),
                IconButton(
                  iconSize: _iconsize,
                  onPressed: () {
                    _launchURL(_listn);
                  },
                  icon: Icon(Icons.podcasts),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
