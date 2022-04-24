import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:practica_2_1/home/bloc/recorder_bloc.dart';
import 'package:practica_2_1/login/login.dart';
import '../auth/bloc/auth_bloc.dart';
import '../content/favmusic/bloc/mimusica_bloc.dart';
import '../content/favmusic/favmusic.dart';
import '../content/song/songpage.dart';
import 'package:practica_2_1/env.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  var _cancion;
  var _artista;
  var _album;
  var _lanzamiento;
  var _appleLink;
  var _spotifyLink;
  var _abumCover;
  var _listenLink;

  late AnimationController _controller;
  late Animation<double> _animation;
  bool _presionado = false;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 3));

    _animation = CurvedAnimation(parent: _controller, curve: Curves.linear);

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  ///////////////////////////////////////////////////////////////
  ///
  ///
  Container _avatarInmovil() {
    return Container(
      height: MediaQuery.of(context).size.width,
      width: 200,
      child: Material(
        elevation: 8.0,
        shape: CircleBorder(),
        child: Image.asset(
            //icon obtained from https://www.flaticon.com/free-icons/music
            'assets/musical-note.png'),
      ),
    );
  }

  AvatarGlow _avatarMovimiento() {
    return AvatarGlow(
      glowColor: Color.fromARGB(255, 110, 57, 255),
      endRadius: 200.0,
      child: Material(
        elevation: 8.0,
        shape: CircleBorder(),
        child: RotationTransition(
          turns: _animation,
          child: Image.asset(
            //icon obtained from https://www.flaticon.com/free-icons/music
            'assets/musical-note.png',
            height: 200,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Toque para escuchar",
              style: GoogleFonts.lato(
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 50),
            BlocConsumer<RecorderBloc, RecorderState>(
              builder: (context, state) {
                print(state);
                if (state is RecorderListeningState) {
                  print("el estado es $state");
                  return _avatarMovimiento();
                } else {
                  print("el estado es $state");
                  return GestureDetector(
                    onTap: () => BlocProvider.of<RecorderBloc>(context)
                        .add(RecordEvent()),
                    child: _avatarInmovil(),
                  );
                }
              },
              listener: (context, state) {
                if (state is RecorderSuccessState) {
                  print("el estado es $state");
                  print(state.myData);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SongPage(datos: state.myData)));
                }
              },
            ),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: Icon(
                      Icons.favorite,
                    ),
                    onPressed: () {
                      BlocProvider.of<MiMusicaBloc>(context)
                          .add(GetMySongsEvent());

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FavouritePage()));
                    },
                  ),
                ),
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: Icon(Icons.power_settings_new),
                    onPressed: () {
                      BlocProvider.of<AuthBloc>(context).add(SignOutEvent());
                      // Navigator.of(context).pushAndRemoveUntil(
                      //     new MaterialPageRoute(
                      //         builder: (context) => new LoginPage()),
                      //     (route) => false);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
