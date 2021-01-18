import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:reddit_client/models/post.dart';
import 'package:video_player/video_player.dart';
import 'package:video_provider/video_provider.dart';

class GifVideoContent extends StatefulWidget {
  final Post post;

  const GifVideoContent({Key key, this.post}) : super(key: key);

  @override
  _GifVideoContentState createState() => _GifVideoContentState();
}

class _GifVideoContentState extends State<GifVideoContent> {
  Post get _post => widget.post;

  VideoPlayerController _playerController;
  ChewieController _chewieController;
  Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    Uri videoUrl = VideoProvider.fromUri(_post.url).getVideos().first.uri;
    _playerController = VideoPlayerController.network(videoUrl.toString());
    _initializeVideoPlayerFuture = _playerController.initialize().then((_) {
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return AspectRatio(
            aspectRatio: _playerController.value.aspectRatio,
            child: Chewie(
              controller: _chewieController,
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  @override
  void dispose() {
    _playerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }
}
