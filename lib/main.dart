import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

import 'list.dart';
import 'player.dart';
import 'state.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => PlayState()),
    ],
    child: const App(),
  ));
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));
    _init();
  }

  void _init() async {
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.speech());
    // Listen to errors during playback.
    context.read<PlayState>().audioPlayer.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      print('A stream error occurred: $e');
    });
  }

  @override
  Widget build(BuildContext context) {
    Future<void> _init() async {
      // Inform the operating system of our app's audio attributes etc.
      // We pick a reasonable default for an app that plays speech.

      // Try to load audio from a source and catch any errors.
      try {
        await context.read<PlayState>().audioPlayer.setAudioSource(
            AudioSource.uri(Uri.parse(
                "https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3")));
      } catch (e) {
        print("Error loading audio source: $e");
      }
    }

    return const MaterialApp(
      home: MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var myClass = context.read<PlayState>().playing;
    return Scaffold(
        appBar: AppBar(title: const Text("Player")),
        body: Column(
          children: [const MusicList(), const Player()],
        ));
  }
}
