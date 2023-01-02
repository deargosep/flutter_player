import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_player/player.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_player/state.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:we_slide/we_slide.dart';
import 'state.dart';

class PlayerScreen extends StatelessWidget {
  final bool isOpened;
  PlayerScreen({Key? key, required this.isOpened}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: WidgetsBinding.instance?.window.physicalSize.height as double,
      color: Colors.greenAccent,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.expand_more),
            Spacer(),
            ArtworkCarousel(
              isOpened: isOpened,
            ),
            Spacer(),
            Player(),
            Spacer()
          ],
        ),
      ),
    );
  }
}

class ArtworkCarousel extends StatefulWidget {
  final bool isOpened;
  ArtworkCarousel({Key? key, required this.isOpened}) : super(key: key);

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
          if (snapshot.hasData) {
            final state = snapshot.data;
            final sequence = state?.sequence ?? [];
            final index = state?.currentIndex ?? 0;
            // carouselController.animateToPage(index);
            dynamic _onPageChanged(index, reason) {
              context
                  .read<PlayState>()
                  .audioPlayer
                  .seek(Duration.zero, index: index);
              context.read<PlayState>().audioPlayer.play();
            }

            // if (!widget.isOpened) {
            return CarouselSlider.builder(
                carouselController: carouselController,
                itemCount: sequence.length,
                options: CarouselOptions(
                  height: MediaQuery.of(context).size.height / 2,
                  initialPage: index,
                  onPageChanged: _onPageChanged,
                ),
                itemBuilder: (BuildContext context, index, idx) {
                  return const ArtworkBox();
                });
          } else {
            return Container();
          }
          // } else {
          //   return Container();
          // }
        });
  }
}

class ArtworkBox extends StatelessWidget {
  const ArtworkBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Image.asset(
        "assets/images/album_artwork.png",
        height: MediaQuery.of(context).size.height / 2,
        width: MediaQuery.of(context).size.height / 2,
        fit: BoxFit.cover,
      ),
    );
  }
}
