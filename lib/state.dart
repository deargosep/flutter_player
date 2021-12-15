import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:convert';
import 'list.dart';

class FactorySingleton {
  static final FactorySingleton _instance = FactorySingleton._internal();

  factory FactorySingleton() {
    return _instance;
  }

  FactorySingleton._internal();
}

class PlayState with ChangeNotifier {
  String _currentAudio = "";
  String _currentTitle = "";
  int _lastPosition = 0;
  var audioPlayer = AudioPlayer();
  late ConcatenatingAudioSource _playlist;
  bool get hasNext => audioPlayer.hasNext;
  bool get hasPrev => audioPlayer.hasPrevious;
  bool get playing => audioPlayer.playerState.playing;
  String get currentAudio => _currentAudio;
  String get currentTitle => _currentTitle;
  int get lastPosition => _lastPosition;

  // final List<IndexedAudioSource> sequence;
  // final int currentIndex;
  // final List<int> shuffleIndices;
  // final bool shuffleModeEnabled;
  // final LoopMode loopMode;
  //
  // IndexedAudioSource? get currentSource =>

  PlayState() {
    _setInitialPlaylist();
  }

  List<Map<String, String>> get tracks => [
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
        }
      ];

  void play(String assetOrUrl, bool? newPlay) async {
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
  }

  void _setInitialPlaylist() async {
    _playlist = ConcatenatingAudioSource(
        children: tracks.map((el) {
      return AudioSource.uri(Uri.parse(el["assetOrUrl"]!), tag: el["title"]!);
    }).toList());
    audioPlayer.sequenceStream.listen((event) {
      print(audioPlayer.sequence?.first.tag);
      print(audioPlayer.sequenceState?.effectiveSequence.first.sequence);
      _currentTitle = audioPlayer.sequence?.first.tag ?? "";
    });
    // Timer(Duration(seconds: 4), () {
    // print(audioPlayer.sequenceState?.currentSource!);
    // });
    // print(tracks.map((el) {
    //   return AudioSource.uri(Uri.parse(el["assetOrUrl"]!), tag: el["title"]!);
    // }).toList()[0]);
    // for (var i = 0; i < tracks.length; i++) {
    //   print(AudioSource.uri(Uri.parse(tracks[i]["assetOrUrl"]!),
    //           tag: tracks[i]["title"]!)
    //       .tag);
    // }
    // _playlist.addAll();

    await audioPlayer.setAudioSource(_playlist);
  }
}
