import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubeVideoContent extends StatefulWidget {
  final String url;

  const YoutubeVideoContent({Key key, this.url}) : super(key: key);

  @override
  _YoutubeVideoContentState createState() => _YoutubeVideoContentState();
}

class _YoutubeVideoContentState extends State<YoutubeVideoContent> {
  String get _url => widget.url;

  YoutubePlayerController _youtubePlayerController;

  @override
  void initState() {
    super.initState();
    String id = RegExp(
            r"(?:youtube\.com\/\S*(?:(?:\/e(?:mbed))?\/|watch\?(?:\S*?&?v\=))|youtu\.be\/)([a-zA-Z0-9_-]{6,11})")
        .firstMatch(_url)
        .group(1);
    _youtubePlayerController = YoutubePlayerController(
      initialVideoId: id,
      flags: YoutubePlayerFlags(
        enableCaption: false,
        autoPlay: false,
        controlsVisibleAtStart: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayer(
      controller: _youtubePlayerController,
      // progressIndicatorColor: redditOrange,
      // progressColors: ProgressBarColors(
      //   playedColor: redditOrange,
      //   bufferedColor: blueColor,
      // ),
    );
  }

  @override
  void dispose() {
    _youtubePlayerController.dispose();
    super.dispose();
  }
}
