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
    void _dismissDialog() {
      Navigator.pop(context);
    }

    void _showMaterialDialog() {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Add a track'),
              content: Column(
                children: [Text("Want to add a track to your playlist?")],
              ),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      _dismissDialog();
                    },
                    child: Text('No')),
                TextButton(
                  onPressed: () {
                    print('HelloWorld!');
                    _dismissDialog();
                  },
                  child: Text('Yes'),
                ),
                TextButton(
                  onPressed: () {
                    _dismissDialog();
                  },
                  child: Text('Add by URL'),
                )
              ],
            );
          });
    }

    return Expanded(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showMaterialDialog();
          },
          child: Icon(Icons.add),
        ),
        body: ListView.builder(
            itemCount: context.read<PlayState>().tracks.length,
            itemBuilder: (BuildContext, int index) {
              return Track(index: index);
            }),
      ),
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
  bool isPlaying = false;
  @override
  Widget build(BuildContext context) {
    var sequence = context.read<PlayState>().audioPlayer.sequenceState;
    final playingStream = context.read<PlayState>().audioPlayer.playingStream;
    playingStream.listen((event) {
      setState(() {
        if (sequence?.currentSource?.tag.id! ==
            context.read<PlayState>().tracks[widget.index]["assetOrUrl"]!)
          isPlaying = true;
        else
          isPlaying = false;
      });
    });
    void _onTap() async {
      // context.read<PlayState>().play(
      //   context.read<PlayState>().tracks[widget.index]["assetOrUrl"]!,
      //   true,
      // );
      // print("index:${widget.index}");
      // print(
      //     "currentIndex: ${context.read<PlayState>().audioPlayer.sequenceState?.currentIndex}");
      int? currentIndex = sequence?.currentIndex as int;
      context.read<PlayState>().audioPlayer.pause();
      await context
          .read<PlayState>()
          .audioPlayer
          .seek(Duration.zero, index: widget.index);
      // print(sequence?.currentSource?.tag);
      context.read<PlayState>().audioPlayer.play();
    }

    // print(context.read<PlayState>().audioPlayer.sequenceState?.currentIndex);

    return Card(
        child: InkWell(
      onTap: _onTap,
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
              isPlaying ? const Icon(Icons.play_arrow) : Container(),
            ],
          )),
    ));
  }
}
