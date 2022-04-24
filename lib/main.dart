import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practica_2_1/auth/bloc/auth_bloc.dart';
import 'package:practica_2_1/content/song/bloc/song_bloc.dart';
import 'package:practica_2_1/home/homepage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'content/favmusic/favmusic.dart';
import 'home/bloc/recorder_bloc.dart';
import 'login/login.dart';
import '../content/song/songpage.dart';

Future main() async {
  //await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (context) => AuthBloc()..add(VerifyAuthEvent())),
      BlocProvider(create: (context) => RecorderBloc()),
      BlocProvider(create: (context) => SongBloc()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Music App',
      home: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          print("Listener has been called");
          if (state is AuthSuccessState) {
            print("AuthSuccessState");
          } else if (state is AuthErrorState) {
            print("AuthErrorState");
          } else {
            print("Other state: $state");
          }
        },
        builder: (context, state) {
          if (state is AuthSuccessState) {
            return HomePage();
          } else if (state is AuthErrorState || state is SignOutSuccessState) {
            return LoginPage();
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
      theme: ThemeData.dark(),
    );
  }
}
