import 'package:audio_session/audio_session.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_player/player_screen.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:provider/provider.dart';
import 'package:we_slide/we_slide.dart';

import 'list.dart';
import 'player.dart';
import 'responsive.dart';
import 'state.dart';

Future<void> main() async {
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
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
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //   statusBarColor: Colors.black,
    // ));
    _init(context);
  }

  void _init(BuildContext context) async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());
    // Listen to errors during playback.
    // context.read<PlayState>().audioPlayer.playbackEventStream.listen((event) {},
    //     onError: (Object e, StackTrace stackTrace) {
    //   if (kDebugMode) {
    //     print('A stream error occurred: $e');
    //   }
    // });
    context.read<PlayState>().init();
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var _paths;
  String _fileName = "";
  final weSlideController = WeSlideController();
  // var _userAborted;
  void initState() {
    super.initState();
    context.read<PlayState>().slider = weSlideController.isOpened;
  }

  @override
  Widget build(BuildContext context) {
    // var myClass = context.read<PlayState>().playing;
    void _addTrack({uri, title, author}) {
//       if (bytes != null) {
//         MP3Instance mp3instance = new MP3Instance(bytes);
//
//         /// parseTagsSync() returns
//         // 'true' if successfully parsed
//         // 'false' if was unable to recognize tag so can't be parsed
//
//         if (mp3instance.parseTagsSync()) {
//           print(mp3instance.getMetaTags());
//         } else {
//           print('no parsing');
//         }
//
//         /// mp3instance.getMetaTags() returns Map<String, dynamic>
// // {
// //   "Title": "SongName",
// //   "Artist": "ArtistName",
// //   "Album": "AlbumName",
// //   "APIC": {
// //     "mime": "image/jpeg",
// //     "textEncoding": "0",
// //     "picType": "0",
// //     "description": "description",
// //     "base64": "AP/Y/+AAEEpGSUYAAQEBAE..."
// //   }
// // }
//
//       }
      context.read<PlayState>().add(ClippingAudioSource(
          child: AudioSource.uri(Uri.parse(uri)),
          tag: MediaItem(
            id: uri,
            title: title,
            displayTitle: title,
            displaySubtitle: author,
          )));
    }

    void _dismissDialog() {
      Navigator.pop(context);
    }

    void _showURLDialog() {
      TextEditingController urlController = TextEditingController(
          text:
              "https://dl4s1.radio.lol/aHR0cDovL2YubXAzcG9pc2submV0L21wMy8wMDIvMDE5LzkyMi8yMDE5OTIyLm1wMz90aXRsZT1kYW5kZWxpb24raGFuZHMrLStjYXJvbGluZSslMjhyYWRpby5sb2wlMjkubXAz");
      TextEditingController titleController =
          TextEditingController(text: "caroline");
      TextEditingController authorController =
          TextEditingController(text: "dandelion hands");
      showDialog(
          context: context,
          builder: (context) {
            void _submit() async {
              _addTrack(
                  title: titleController.text,
                  author: authorController.text,
                  uri: urlController.text);
              // context.read<PlayState>().tracks.add({
              //   "assetOrUrl": urlController.text,
              //   "title": titleController.text,
              //   "author": authorController.text,
              // });
              _dismissDialog();
              _dismissDialog();
            }

            return AlertDialog(
              title: const Text('Add a track'),
              content: Form(
                  child: SizedBox(
                height: 180,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'URL'),
                      controller: urlController,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Title'),
                      controller: titleController,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Author'),
                      controller: authorController,
                    )
                  ],
                ),
              )),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      _dismissDialog();
                    },
                    child: const Text('Cancel')),
                TextButton(
                    onPressed: () {
                      _submit();
                    },
                    child: const Text('Add')),
              ],
            );
          });
    }

    void _pickFiles() async {
      try {
        _paths = (await FilePicker.platform.pickFiles(
          type: FileType.audio,
        ))
            ?.files;
        // print(_paths[0].path);
      } on PlatformException catch (e) {
        if (kDebugMode) {
          print('Unsupported operation' + e.toString());
        }
      } catch (e) {
        if (kDebugMode) {
          print(e.toString());
        }
      }
      if (!mounted) return;
      setState(() {
        _fileName =
            _paths != null ? _paths!.map((e) => e.name).toString() : '...';
        // _userAborted = _paths == null;
      });
    }

    void _add() async {
      _pickFiles();
      var values = _fileName.split("-");
      // var bytes = File(_paths ?? .path).readAsBytesSync();
      if (kDebugMode) {
        print(values);
      }
      _addTrack(
        title: values[0],
        author: values.length > 1 ? values[1] : "",
        uri: _paths[0].path,
      );
      _dismissDialog();
      // var fileP = FilePick();
      // var result = fileP.pickFile();
      // result
    }

    void _showAddDialog() {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Add a track'),
              content: const Text("Want to add a track to your playlist?"),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      _dismissDialog();
                    },
                    child: const Text('Cancel')),
                TextButton(
                  onPressed: _add,
                  child: const Text('Add'),
                ),
                TextButton(
                  onPressed: () {
                    _showURLDialog();
                  },
                  child: const Text('Add by URL'),
                )
              ],
            );
          });
    }

    return Scaffold(
      body: WeSlide(
          controller: weSlideController,
          panelMaxSize: MediaQuery.of(context).size.height,
          panelMinSize: Responsive().getResponsiveValue(
              forShortScreen: MediaQuery.of(context).size.height / 4,
              // forLargeScreen:
              //     (WidgetsBinding.instance?.window.physicalSize.height ?? 0) /
              //         19,
              // forMediumScreen:
              //     (WidgetsBinding.instance?.window.physicalSize.height ?? 0) /
              //         8,
              forMobLandScapeMode: MediaQuery.of(context).size.height / 2,
              context: context),
          // (WidgetsBinding.instance?.window.physicalSize.height ?? 0) / 15,
          backgroundColor: Colors.white24,
          panel: PlayerScreen(isOpened: weSlideController.isOpened),
          panelHeader: Container(
            color: Colors.greenAccent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.expand_less),
                const Player(),
              ],
            ),
          ),
          body: Scaffold(
              floatingActionButton: Padding(
                padding: const EdgeInsets.only(top: 200.0),
                child: FloatingActionButton(
                  onPressed: () {
                    _showAddDialog();
                  },
                  child: const Icon(Icons.add),
                ),
              ),
              appBar: AppBar(title: const Text("Player")),
              body: const MusicList())
          // ),
          ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('_paths', _paths));
    properties.add(DiagnosticsProperty('_paths', _paths));
  }
}
