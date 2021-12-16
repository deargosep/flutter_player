import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:provider/provider.dart';
import 'package:just_audio/just_audio.dart';
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
              context.read<PlayState>().add(ClippingAudioSource(
                  child: AudioSource.uri(Uri.parse(urlController.text)),
                  tag: MediaItem(
                      id: urlController.text,
                      title: titleController.text,
                      displayTitle: titleController.text,
                      displaySubtitle: authorController.text)));
              // context.read<PlayState>().tracks.add({
              //   "assetOrUrl": urlController.text,
              //   "title": titleController.text,
              //   "author": authorController.text,
              // });
              _dismissDialog();
              _dismissDialog();
            }

            return AlertDialog(
              title: Text('Add a track'),
              content: Form(
                  child: SizedBox(
                height: 180,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(labelText: 'URL'),
                      controller: urlController,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Title'),
                      controller: titleController,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Author'),
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
                    child: Text('Cancel')),
                TextButton(
                    onPressed: () {
                      _submit();
                    },
                    child: Text('Add')),
              ],
            );
          });
    }

    void _showAddDialog() {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Add a track'),
              content: Text("Want to add a track to your playlist?"),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      _dismissDialog();
                    },
                    child: Text('Cancel')),
                TextButton(
                  onPressed: () {
                    _dismissDialog();
                  },
                  child: Text('Add'),
                ),
                TextButton(
                  onPressed: () {
                    _showURLDialog();
                  },
                  child: Text('Add by URL'),
                )
              ],
            );
          });
    }

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
    return Expanded(
      child: StreamBuilder<SequenceState?>(
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
          }
          // )
          ),
    );
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
            widget.data[widget.index].tag.title!)
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
      // int? currentIndex = sequence?.currentIndex as int;
      await context.read<PlayState>().audioPlayer.pause();
      await context
          .read<PlayState>()
          .audioPlayer
          .seek(Duration.zero, index: widget.index);
      // print(sequence?.currentSource?.tag);
      print("index:${widget.index}");
      print(
          "currentIndex: ${context.read<PlayState>().audioPlayer.sequenceState?.currentIndex}");
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
