import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:just_audio/just_audio.dart';
import 'state.dart';
import 'package:flutter/foundation.dart';

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
    void _onReorder(currIndex, newIndex) {
      if (currIndex < newIndex) newIndex--;
      context.read<PlayState>().playlist.move(currIndex, newIndex);
    }

    // return Scaffold(
    //   floatingActionButton: FloatingActionButton(
    //     onPressed: () {
    //       _showAddDialog();
    //     },
    //     child: Icon(Icons.add),
    //   ),
    return StreamBuilder(
        stream: context.read<PlayState>().loaded,
        builder: (context, snapshotL) {
          return StreamBuilder<SequenceState?>(
              stream: context.read<PlayState>().audioPlayer.sequenceStateStream,
              builder: (context, snapshot) {
                final state = snapshot.data;
                final sequence = state?.sequence ?? [];
                // print(sequence[2]);
                return ReorderableListView(
                    onReorder: _onReorder,
                    children: <Widget>[
                      for (var i = 0; i < sequence.length; i++)
                        Track(
                          index: i,
                          data: sequence,
                          key: ValueKey(sequence[i].tag.id),
                        )
                      // Dismissible(key: ValueKey(sequence[i]), child: Text("${i}"))
                    ]);
              });
        });
  }
}

class Track extends StatefulWidget {
  final int index;
  final List data;

  const Track({Key? key, required this.index, required this.data})
      : super(key: key);

  @override
  _TrackState createState() => _TrackState();
}

class _TrackState extends State<Track> {
  bool isPlaying = false;
  @override
  Widget build(BuildContext context) {
    var sequence = context.read<PlayState>().audioPlayer.sequenceState;
    final playingStream = context.read<PlayState>().audioPlayer.playingStream;
    playingStream.listen((event) {
      // print(sequence?.currentSource?.tag);
      setState(() {
        if (sequence?.currentSource?.tag.title! ==
            widget.data[widget.index].tag.title!) {
          isPlaying = true;
        } else {
          isPlaying = false;
        }
      });
    });
    void _onTap() async {
      // context.read<PlayState>().play(
      //   context.read<PlayState>().tracks[widget.index]["assetOrUrl"]!,
      //   true,
      // );
      // int? currentIndex = sequence?.currentIndex as int;
      await context.read<PlayState>().audioPlayer.pause();
      await context
          .read<PlayState>()
          .audioPlayer
          .seek(Duration.zero, index: widget.index);
      // print(sequence?.currentSource?.tag);
      if (kDebugMode) {
        print("index:${widget.index}");
      }
      if (kDebugMode) {
        print(
            "currentIndex: ${context.read<PlayState>().audioPlayer.sequenceState?.currentIndex}");
      }
      // print(
      // "currentSource: ${context.read<PlayState>().audioPlayer.sequenceState?.currentSource?.tag}");
      context.read<PlayState>().audioPlayer.play();
    }

    void _onDismiss(direction) {
      context.read<PlayState>().remove(widget.index);
    }

    // print(context.read<PlayState>().audioPlayer.sequenceState?.currentIndex);

    return Dismissible(
      onDismissed: _onDismiss,
      key: widget.key!,
      child: Card(
        key: widget.key,
        child: InkWell(
          onTap: _onTap,
          child: Container(
              padding: const EdgeInsets.all(30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(widget.data[widget.index].tag.title!),
                      Text(widget.data[widget.index].tag.displaySubtitle!),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                  isPlaying ? const Icon(Icons.play_arrow) : Container(),
                ],
              )),
        ),
      ),
    );
  }
}
