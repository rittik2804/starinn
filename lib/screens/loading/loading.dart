import 'dart:math';

import 'package:flutter/material.dart';
import 'package:listar_flutter_pro/configs/config.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() {
    return _SplashScreenState();
  }
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  bool up = true;
  AnimationController? _controller;
  Tween<Offset> _tween = Tween<Offset>(
    begin: Offset(0, -1),
    end: Offset.zero,
  );

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    _controller!.forward();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Animation<Offset> _animation = _tween.animate(CurvedAnimation(
      parent: _controller!,
      curve: Curves.easeInOut,
    ));
    _controller!.forward();

    final animation = Tween(begin: Offset(-2, 0), end: Offset(0, 0)).animate(
        CurvedAnimation(
            curve: const Interval(0, 1, curve: Curves.easeIn),
            parent: _controller!));

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(Images.splashImage), fit: BoxFit.cover),
        ),
        alignment: Alignment.topCenter,
        child: AnimatedBuilder(
            animation: animation,

            // padding: EdgeInsets.all(10.0),
            // duration: Duration(milliseconds: 250), // Animation speed
            // transform: Transform.translate(
            //   offset: Offset(0, up ? -100 : 0), // Change -100 for the y offset
            // ).transform,
            builder: (context, child) => Transform.translate(
                  // offset: _animation.value,
                  offset: Offset(
                      0,
                      _controller!.value *
                          MediaQuery.of(context).size.height *
                          0.30),
                  child: Image.asset(Images.splashLogo,
                      // height: 100,
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width * 0.5),
                )),
        // child: OpacityAnimatedWidget.tween(
        //   enabled: true,
        //   // .displayMyWidget, //update this boolean to forward/reverse the animation
        //   opacityEnabled: 1, //define start value
        //   opacityDisabled: 0, //a
        //   duration: Duration(seconds: 5),
        //   child: Image.asset(Images.logo, height: 100, width: 100),
        // ),
      ),

      // Stack(
      //   alignment: Alignment.center,
      //   children: <Widget>[
      //     Center(
      //       child: Column(
      //         crossAxisAlignment: CrossAxisAlignment.center,
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         mainAxisSize: MainAxisSize.min,
      //         children: <Widget>[
      //           Image.asset(Images.logo, width: 120, height: 120),
      //         ],
      //       ),
      //     ),
      //     const Padding(
      //       padding: EdgeInsets.only(top: 300),
      //       child: SizedBox(
      //         width: 26,
      //         height: 26,
      //         child: CircularProgressIndicator(strokeWidth: 2),
      //       ),
      //     )
      //   ],
      // ),
    );
  }
}
