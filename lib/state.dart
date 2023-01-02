import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

class FactorySingleton {
  static final FactorySingleton _instance = FactorySingleton._internal();

  factory FactorySingleton() {
    return _instance;
  }

  FactorySingleton._internal();
}

class PlayState with ChangeNotifier {
  String _currentAudio = "";
  // Stream _loaded;
  final String _currentTitle = "";
  final int _lastPosition = 0;
  late ConcatenatingAudioSource _playlist;
  bool _slider = false;
  var audioPlayer = AudioPlayer();
  ConcatenatingAudioSource get playlist => _playlist;
  bool get hasNext => audioPlayer.hasNext;
  bool get hasPrev => audioPlayer.hasPrevious;
  // bool get playing => audioPlayer.playerState.playing;
  String get currentAudio => _currentAudio;
  String get currentTitle => _currentTitle;
  int get lastPosition => _lastPosition;
  bool get slider => _slider;
  set slider(bool val) => _slider = val;
  // bool get loaded => _loaded;
  StreamController _loadedController = new StreamController.broadcast();
  Stream get loaded => _loadedController.stream;
  final List _tracks = [
    {
      "title": "THANK YOU MY TWILIGHT",
      "author": "flcl",
      "assetOrUrl":
          "https://deargosep.github.io/mediastorage/flcl%20progressive%20thank%20you%20my%20twilight.m4a"
    },
    {
      "title": "basic space",
      "author": "xx",
      "assetOrUrl":
          "https://dl4s1.galamp3.com/aHR0cDovL2YubXAzcG9pc2submV0L21wMy8wMDEvNzk1LzEyNi8xNzk1MTI2Lm1wMz90aXRsZT1UaGUreHgrLStCYXNpYytTcGFjZSslMjhnYWxhbXAzLmNvbSUyOS5tcDM="
    },
    {
      "title": "white christmas",
      "author": "dandelion hands",
      "assetOrUrl":
          "https://deargosep.github.io/mediastorage/white_christmas.mp3"
    }
  ];
  // List _tracks = [];

  void _init() {
    _setInitialPlaylist();
    audioPlayer.setLoopMode(LoopMode.all);
    notifyListeners();
  }

  get init => _init;

  // PlayState() {
  //   }

  List get tracks => _tracks;

  /*void play(String assetOrUrl, bool? newPlay) async {
    if (assetOrUrl[0] == "/") {
      if (assetOrUrl == _currentAudio) {
        audioPlayer.play();
      } else {
        await audioPlayer.setAsset(assetOrUrl);
        audioPlayer.play();
      }
    } else {
      if (assetOrUrl == _currentAudio) {
        audioPlayer.play();
      } else {
        await audioPlayer.setUrl(assetOrUrl);
        audioPlayer.play();
      }
    }
    _currentAudio = assetOrUrl;
    if (newPlay!) {
      await audioPlayer.pause();
      audioPlayer.play();
    } else if (audioPlayer.playerState.playing) {
      audioPlayer.pause();
    } else {
      // await audioPlayer.seek(Duration(seconds: _lastPosition));
      audioPlayer.play();
    }
    notifyListeners();
  }*/

  void add(object) async {
    _playlist.add(object);
    // _setPlaylist();
    notifyListeners();
  }

  void remove(index) async {
    await _playlist.removeAt(index);
    // _setPlaylist();
    notifyListeners();
  }

  void _setInitialPlaylist() async {
    // _loaded = false;
    _loadedController.add(false);
    // _tracks = await _readJson();
    _playlist = ConcatenatingAudioSource(
        children: tracks.map((el) {
      return ClippingAudioSource(
          child: AudioSource.uri(Uri.parse(el["assetOrUrl"]!)),
          tag: MediaItem(
              id: el["assetOrUrl"]!,
              title: el["title"]!,
              displayTitle: el["title"]!,
              displaySubtitle: el["author"]!));
    }).toList());

    await audioPlayer.setAudioSource(_playlist, preload: true);
    _loadedController.add(true);
    notifyListeners();
  }
}
