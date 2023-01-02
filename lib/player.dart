import 'package:flutter/material.dart';
import 'package:flutter_player/seeker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

import 'state.dart';

class Player extends StatefulWidget {
  const Player({Key? key}) : super(key: key);

  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  // bool isPlaying = false;
  @override
  Widget build(BuildContext context) {
    // final playingStream = context.read<PlayState>().audioPlayer.playingStream;
    // playingStream.listen((event) {
    //   if (!mounted) return;
    //   setState(() {
    //     isPlaying = event;
    //   });
    // });
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
      color: Colors.greenAccent,
      child: StreamBuilder(
        stream: context.read<PlayState>().audioPlayer.playingStream,
        builder: (context, snapshot) {
          final statePlaying = snapshot.data;
          return StreamBuilder<SequenceState?>(
              stream: context.read<PlayState>().audioPlayer.sequenceStateStream,
              builder: (context, snapshotSequence) {
                final stateSequence = snapshotSequence.data;
                return Container(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Column(
                      children: [
                        Text(
                          stateSequence?.currentSource?.tag.title ?? "",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                            stateSequence?.currentSource?.tag.displaySubtitle ??
                                ""),
                        SizedBox(height: 20),
                        const Seeker(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            InkWell(
                                onTap: _onPrev,
                                child: const Icon(
                                  Icons.skip_previous,
                                  size: 40,
                                )),
                            InkWell(
                                onTap: _onPlay,
                                child: Icon(
                                  statePlaying == true
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                  size: 50,
                                )),
                            InkWell(
                                onTap: _onNext,
                                child: const Icon(
                                  Icons.skip_next,
                                  size: 40,
                                ))
                          ],
                        ),
                      ],
                    ));
              });
        },
      ),
    );
  }
}
