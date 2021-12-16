import 'package:flutter/material.dart';
import 'package:flutter_player/seeker.dart';
import 'package:provider/provider.dart';

import 'state.dart';

class Player extends StatefulWidget {
  const Player({Key? key}) : super(key: key);

  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  bool isPlaying = false;
  @override
  Widget build(BuildContext context) {
    final playingStream = context.read<PlayState>().audioPlayer.playingStream;
    playingStream.listen((event) {
      setState(() {
        isPlaying = event;
      });
    });
    // context.read<PlayState>().audioPlayer.playingStream.listen((event) {
    //   print(event);
    // });
    void _onPrev() {
      context.read<PlayState>().audioPlayer.seekToPrevious();
    }

    void _onPlay() async {
      // if (context.read<PlayState>().audioPlayer.playing) {
      await context.read<PlayState>().audioPlayer.play();
      // } else {
      await context.read<PlayState>().audioPlayer.pause();
      // }
      // .play(context.read<PlayState>().currentAudio, false);
    }

    void _onNext() {
      context.read<PlayState>().audioPlayer.seekToNext();
    }

    return Container(
      color: Colors.white,
      height: 100,
      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Column(
        children: [
          Seeker(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                  onTap: _onPrev,
                  child: Container(
                      color: Colors.white.withOpacity(
                          context.read<PlayState>().hasPrev ? 1.0 : 0.5),
                      child: Icon(Icons.skip_previous))),
              InkWell(
                  onTap: _onPlay,
                  child:
                      Icon(isPlaying == true ? Icons.pause : Icons.play_arrow)),
              InkWell(
                  onTap: _onNext,
                  child: Container(
                      color: Colors.white.withOpacity(
                          context.read<PlayState>().hasNext ? 1.0 : 0.5),
                      child: Icon(Icons.skip_next)))
            ],
          ),
        ],
      ),
    );
  }
}
