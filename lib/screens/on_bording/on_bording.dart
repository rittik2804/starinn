import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listar_flutter_pro/app_container.dart';
import 'package:listar_flutter_pro/configs/config.dart';
import 'package:video_player/video_player.dart';

class OnBordingScreen extends StatefulWidget {
  VideoPlayerController videoPlayerController;
  OnBordingScreen(this.videoPlayerController);

  @override
  State<OnBordingScreen> createState() => _OnBordingScreenState();
}

class _OnBordingScreenState extends State<OnBordingScreen> {
  // ChewieController? chewieController;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    // _controller = VideoPlayerController.asset(Images.splashVideo);

    widget.videoPlayerController.setLooping(true);
    //  widget.videoPlayerController.initialize().then((_) => setState(() {}));
    widget.videoPlayerController.play();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    widget.videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Stack(
        children: [
          Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: VideoPlayer(widget.videoPlayerController)),
          Positioned(
              top: MediaQuery.of(context).size.height * 0.17,
              left: 0,
              right: 0,
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  Image.asset(
                    Images.walkthrouLogo,
                    width: MediaQuery.of(context).size.width * 0.8,
                  ),
                  // Spacer(),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.42,
                  ),
                  Text(
                    "Enjoy your\nvacations with us",
                    style: Theme.of(context)
                        .textTheme
                        .headlineLarge!
                        .copyWith(color: Colors.white, fontSize: 32),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AppContainer(),
                          ),
                          (route) => false);
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Ink(
                      height: 50,
                      width: MediaQuery.of(context).size.width * 0.9,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(12)),
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Explore",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Theme.of(context).cardColor,
                                  fontSize: 20,
                                )),
                            Spacer(),
                            Image.asset(
                              Images.aerro,
                              height: 10,
                            )
                          ]),
                    ),
                  )
                ],
              ))
        ],
      )),
    );
  }
}
