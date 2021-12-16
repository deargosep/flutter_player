import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_player/player.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_player/state.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'state.dart';

class PlayerScreen extends StatelessWidget {
  // const ({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: WidgetsBinding.instance?.window.physicalSize.height as double,
      color: Colors.greenAccent,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [ArtworkCarousel(), Player()],
        ),
      ),
    );
  }
}

class ArtworkCarousel extends StatefulWidget {
  const ArtworkCarousel({Key? key}) : super(key: key);

  @override
  _ArtworkCarouselState createState() => _ArtworkCarouselState();
}

class _ArtworkCarouselState extends State<ArtworkCarousel> {
  final carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SequenceState?>(
        stream: context.read<PlayState>().audioPlayer.sequenceStateStream,
        builder: (context, snapshot) {
          final state = snapshot.data;
          final sequence = state?.sequence ?? [];
          carouselController.animateToPage(state?.currentIndex ?? 0);
          dynamic _onPageChanged(index, reason) {
            context
                .read<PlayState>()
                .audioPlayer
                .seek(Duration.zero, index: index);
            context.read<PlayState>().audioPlayer.play();
          }

          return Column(
            children: [
              CarouselSlider.builder(
                  carouselController: carouselController,
                  itemCount: sequence.length,
                  options: CarouselOptions(
                      height: 600, onPageChanged: _onPageChanged),
                  itemBuilder: (BuildContext context, index, idx) {
                    return ArtworkBox();
                  }),
              Text(state?.currentSource?.tag.title ?? ""),
              Text(state?.currentSource?.tag.displaySubtitle ?? "")
            ],
          );
        });
  }
}

class ArtworkBox extends StatelessWidget {
  const ArtworkBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset("assets/images/album_artwork.png");
    ;
  }
}
