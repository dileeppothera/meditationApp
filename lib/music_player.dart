import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class MusicPlayer extends StatefulWidget {
  @override
  _MusicPlayerState createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  bool isPlaying = false;
  IconData play_btn = Icons.play_arrow;

  AudioPlayer _player;
  AudioCache _cache;
  Duration position = new Duration();
  Duration musicLength = new Duration();

  Widget slider() {
    return Slider.adaptive(
      activeColor: Colors.blue,
      inactiveColor: Colors.grey,
      value: position.inSeconds.toDouble(),
      max: musicLength.inSeconds.toDouble(),
      onChanged: (value) {
        seekToSec(value.toInt());
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _cache = AudioCache(fixedPlayer: _player);

    // ignore: deprecated_member_use
    _player.durationHandler = (d) {
      setState(() {
        musicLength = d;
      });
    };
    // ignore: deprecated_member_use
    _player.positionHandler = (p) {
      setState(() {
        position = p;
      });
    };
    _cache.load('images/med.mp3');
  }

  void seekToSec(int val) {
    Duration newPos = Duration(seconds: val);
    _player.seek(newPos);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Music Player",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 2,
            width: MediaQuery.of(context).size.width,
            color: Colors.blue,
            child: Center(
              child: Text(
                "Music name",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 200,
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                slider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        icon: Icon(Icons.skip_previous), onPressed: () {}),
                    IconButton(
                      icon: Icon(play_btn),
                      onPressed: () {
                        if (!isPlaying) {
                          setState(() {
                            _cache.play('images/med.mp3');
                            play_btn = Icons.pause;
                            isPlaying = true;
                          });
                        } else {
                          setState(() {
                            _player.pause();
                            play_btn = Icons.play_arrow;
                            isPlaying = false;
                          });
                        }
                      },
                      iconSize: 40,
                    ),
                    IconButton(icon: Icon(Icons.skip_next), onPressed: () {}),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
