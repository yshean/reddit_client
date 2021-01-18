import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:reddit_client/models/post.dart';
import 'package:video_player/video_player.dart';

class VideoContent extends StatefulWidget {
  final Post post;

  const VideoContent({Key key, this.post}) : super(key: key);

  @override
  _VideoContentState createState() => _VideoContentState();
}

class _VideoContentState extends State<VideoContent> {
  Post get _post => widget.post;

  VideoPlayerController _playerController;
  ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _playerController = VideoPlayerController.network(_post.url.toString());
    _playerController.initialize();
    _chewieController = ChewieController(
      videoPlayerController: _playerController,
      aspectRatio: _playerController.value.aspectRatio,
      allowedScreenSleep: false,
      errorBuilder: (context, error) => Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.error,
            // color: redditOrange,
          ),
          Text(
            error,
            // style: TextStyle(color: lightGreyColor),
          ),
        ],
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Chewie(
      controller: _chewieController,
    );
  }

  @override
  void dispose() {
    _playerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }
}
