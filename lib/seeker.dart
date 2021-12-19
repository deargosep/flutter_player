import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'state.dart';

class Seeker extends StatefulWidget {
  const Seeker({Key? key}) : super(key: key);

  @override
  _SeekerState createState() => _SeekerState();
}

class _SeekerState extends State<Seeker> {
  var position;
  var duration;
  var buffered;
  @override
  Widget build(BuildContext context) {
    final positionStream = context.read<PlayState>().audioPlayer.positionStream;
    final durationStream = context.read<PlayState>().audioPlayer.durationStream;
    final bufferedStream =
        context.read<PlayState>().audioPlayer.bufferedPositionStream;
    positionStream.listen((event) {
      setState(() {
        position = event.inSeconds;
      });
    });
    durationStream.listen((event) {
      setState(() {
        duration = event?.inSeconds ?? 0;
      });
    });
    bufferedStream.listen((event) {
      setState(() {
        buffered = event.inSeconds;
      });
    });
    return Container(
        width: 300,
        child: ProgressBar(
          progress: Duration(seconds: position ?? 0),
          // context.read<PlayState>().audioPlayer.positionStream
          total: Duration(seconds: duration ?? 0),
          onSeek: (value) {
            if (context.read<PlayState>().audioPlayer.playing) {
              context
                  .read<PlayState>()
                  .audioPlayer
                  .seek(Duration(seconds: value.inSeconds));
            }
          },
          buffered: Duration(seconds: buffered ?? 0),
        ));
  }
}
