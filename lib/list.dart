import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'state.dart';

// class Track {
//   String title = '';
//   String author = '';
//   String assetOrUrl = '';
//   // void init() {
//   //   this.title = title;
//   //   this.author = author;
//   //   this.assetOrUrl = assetOrUrl;
//   // }
//
//   Track(
//       {required String title,
//       required String author,
//       required String assetOrUrl});
// }

class MusicList extends StatefulWidget {
  const MusicList({Key? key}) : super(key: key);

  @override
  State<MusicList> createState() => _MusicListState();
}

class _MusicListState extends State<MusicList> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
          itemCount: context.read<PlayState>().tracks.length,
          itemBuilder: (BuildContext, int index) {
            return Track(index: index);
          }),
    );
  }
}

class Track extends StatefulWidget {
  final int index;
  const Track({Key? key, required this.index}) : super(key: key);

  @override
  _TrackState createState() => _TrackState();
}

class _TrackState extends State<Track> {
  var isPlaying = false;
  @override
  Widget build(BuildContext context) {
    final playingStream = context.read<PlayState>().audioPlayer.playingStream;
    playingStream.listen((event) {
      setState(() {
        if (context.read<PlayState>().tracks[widget.index]["assetOrUrl"]! ==
                context.read<PlayState>().currentAudio &&
            event)
          isPlaying = true;
        else
          isPlaying = false;
      });
    });
    return Card(
        child: InkWell(
      onTap: () {
        context.read<PlayState>().play(
              context.read<PlayState>().tracks[widget.index]["assetOrUrl"]!,
              true,
            );
      },
      child: Container(
          padding: const EdgeInsets.all(30.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                      context.read<PlayState>().tracks[widget.index]["title"]!),
                  Text(context.read<PlayState>().tracks[widget.index]
                      ["author"]!),
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
              isPlaying
                  ? const Icon(Icons.pause)
                  : const Icon(Icons.play_arrow),
            ],
          )),
    ));
  }
}
