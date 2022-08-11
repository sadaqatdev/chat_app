import 'package:better_player/better_player.dart';
import 'package:chat_app/models/message.dart';
import 'package:flutter/material.dart';

class VideoPlayerPage extends StatefulWidget {
  const VideoPlayerPage({Key? key, required this.message}) : super(key: key);
  final Message message;
  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  BetterPlayerController? _betterPlayerController;
  BetterPlayerDataSource? betterPlayerDataSource;
  @override
  initState() {
    super.initState();
    onotVideo();
  }

  onotVideo() {
    betterPlayerDataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      widget.message.message ?? '',
    );

    _betterPlayerController = BetterPlayerController(
        const BetterPlayerConfiguration(
          autoPlay: true,
          fit: BoxFit.contain,
          controlsConfiguration: BetterPlayerControlsConfiguration(
            enableOverflowMenu: false,
            enableSkips: false,
            controlBarColor: Color.fromRGBO(0, 0, 0, 0.5),
          ),
        ),
        betterPlayerDataSource: betterPlayerDataSource);

    _betterPlayerController?.setOverriddenAspectRatio(
        _betterPlayerController?.videoPlayerController?.value.aspectRatio ?? 1);

    _betterPlayerController?.addEventsListener(
      (p0) {
        setState(() {});
      },
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: _betterPlayerController == null
            ? const CircularProgressIndicator()
            : AspectRatio(
                aspectRatio: _betterPlayerController!
                    .videoPlayerController!.value.aspectRatio,
                child: BetterPlayer(
                  controller: _betterPlayerController!,
                ),
              ),
      ),
    ));
  }
}
