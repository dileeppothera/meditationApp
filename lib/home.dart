import 'dart:math';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  var _primaryColor = Colors.blue;
  var _secondaryColor = Colors.orange;
  var _thirdColor = Colors.blue[200];
  var _bgColor = Colors.white;
  double _height = 250;
  double _width = 250;
  Alignment _align = Alignment(0, -.8);
  AnimationController _controller;
  AnimationController _rotation;
  AnimationController _slide;

  AudioPlayer _player;
  AudioCache _cache;

  Duration position = new Duration();
  Duration length = new Duration();

  Widget slider() {
    return Slider(
      activeColor: _secondaryColor,
      inactiveColor: _bgColor,
      value: position.inSeconds.toDouble(),
      max: length.inSeconds.toDouble(),
      onChanged: (value) {
        seekToSec(value.toInt());
      },
    );
  }

  void seekToSec(int v) {
    Duration newPos = Duration(seconds: v);
    _player.seek(newPos);
  }

  @override
  void initState() {
    _player = AudioPlayer();
    _cache = AudioCache(fixedPlayer: _player);

    _player.durationHandler = (d) {
      setState(() {
        length = d;
      });
    };

    _player.positionHandler = (p) {
      setState(() {
        position = p;
      });
    };
    _cache.load('images/med.mp3');

    _slide = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..repeat();

    _rotation = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 15000),
    );
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
      lowerBound: 0,
      upperBound: 6,
    );
    _rotation.repeat();
    _controller.repeat(reverse: true);
    _controller.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  IconData iconData = Icons.play_arrow;
  bool isPlaying = false;

  @override
  void dispose() {
    _slide.dispose();
    _controller.dispose();
    _rotation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _bgColor,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {},
          color: _primaryColor,
        ),
        title: Text(
          "FORGIVENESS",
          style: TextStyle(color: _primaryColor),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(
                iconData,
                color: _primaryColor,
              ),
              onPressed: () {
                if (!isPlaying) {
                  iconData = Icons.pause;
                  _cache.play('images/soda.mp3');
                  isPlaying = true;
                  print(position.inMinutes.toString());
                } else {
                  isPlaying = false;
                  iconData = Icons.play_arrow;
                  _player.pause();
                }
              })
        ],
      ),
      body: Container(
        child: Stack(
          children: [
            Container(
              color: _bgColor,
              child: CustomPaint(
                size: Size(MediaQuery.of(context).size.width,
                    MediaQuery.of(context).size.height - 80),
                painter: CurvePainter(),
              ),
            ),
            Align(
              alignment: _align,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _primaryColor,
                ),
              ),
            ),
            Align(
              alignment: Alignment(0, -.84),
              child: Container(
                width: 270,
                height: 270,
                child: AnimatedBuilder(
                  animation: _rotation.view,
                  builder: (context, child) {
                    return Transform.rotate(
                        angle: _rotation.value * 2 * pi, child: child);
                  },
                  child: DottedBorder(
                    borderType: BorderType.Circle,
                    padding: EdgeInsets.all(2),
                    color: _thirdColor,
                    strokeWidth: 10,
                    dashPattern: [200],
                    child: Container(
                      width: _width + 60,
                      height: _height + 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: _align,
              child: Container(
                margin: EdgeInsets.only(top: _controller.value),
                child: Image(
                  image: AssetImage("assets/images/yoga.png"),
                ),
                height: _height - 30,
                width: _width - 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(180),
                  // color: Colors.blue,
                ),
              ),
            ),
            Align(
              alignment: Alignment(0.0, 0.7),
              child: Text(
                position.inMinutes.toString() +
                    ":" +
                    (position.inSeconds.toDouble() -
                            (position.inMinutes.toDouble() * 60))
                        .toInt()
                        .toString(),
                style: TextStyle(
                    color: _bgColor, fontSize: 90, fontWeight: FontWeight.w100),
              ),
            ),
            Align(
              alignment: Alignment(0, 1),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 100,
                color: _primaryColor,
              ),
            ),
            Align(
              alignment: Alignment(-0.75, 0.91),
              child: Text(
                position.inMinutes.toString() +
                    ":" +
                    (position.inSeconds.toDouble() -
                            (position.inMinutes.toDouble() * 60))
                        .toInt()
                        .toString(),
                style: TextStyle(
                  color: _bgColor,
                ),
              ),
            ),
            Align(
              alignment: Alignment(0.75, 0.91),
              child: Text(
                length.inMinutes.toString() +
                    ":" +
                    (length.inSeconds.toDouble() -
                            (length.inMinutes.toDouble() * 60))
                        .toInt()
                        .toString(),
                style: TextStyle(
                  color: _bgColor,
                ),
              ),
            ),
            Positioned(left: 20, right: 20, bottom: 40, child: slider())
          ],
        ),
      ),
    );
  }
}

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.blue;
    paint.style = PaintingStyle.fill;

    var path = Path();

    path.moveTo(0, size.height * 0.53);
    path.quadraticBezierTo(size.width * 0.1, size.height * 0.49,
        size.width * 0.19, size.height * 0.56);
    path.quadraticBezierTo(size.width * 0.28, size.height * 0.63,
        size.width * 0.4, size.height * 0.6);
    path.quadraticBezierTo(size.width * 0.56, size.height * 0.55,
        size.width * 0.7, size.height * 0.62);
    path.quadraticBezierTo(
        size.width * 0.85, size.height * 0.7, size.width, size.height * 0.58);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
