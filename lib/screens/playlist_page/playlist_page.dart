import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inner_me_application/core/services/audio/audio_service_singleton.dart';
import 'package:just_audio/just_audio.dart';

class PlaylistPage extends StatefulWidget {
  const PlaylistPage({super.key});

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  late AudioPlayer _player;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool _isPlaying = false;
  final audioHandler = AudioServiceSingleton.instance;


  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    _player = AudioPlayer();
    _player.setAsset('assets/sounds/town.mp3').then((v) {
    });

     _player.durationStream.listen((d) {
      if (d != null) setState(() => _duration = d);
    });

    _player.positionStream.listen((p) {
      setState(() => _position = p);
    });

    _player.playerStateStream.listen((PlayerState state) {
      setState(() {
        state.processingState;
        _isPlaying = state.playing;
      });
    });
  }

  onPlay() async {
    
    _player.play();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  String _formatTime(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Assets Audio")),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('background.png'), fit: BoxFit.fill)
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Thanh seek
              Slider(
                min: 0,
                max: _duration.inSeconds.toDouble(),
                value: _position.inSeconds.toDouble().clamp(
                  0,
                  _duration.inSeconds.toDouble(),
                ),
                onChanged: (value) async {
                  final position = Duration(seconds: value.toInt());
                  await _player.seek(position);
                },
              ),
              // Thời gian
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_formatTime(_position)),
                  Text(_formatTime(_duration)),
                ],
              ),
              const SizedBox(height: 30),
              // Nút Play / Pause
              IconButton(
                icon: Icon(_isPlaying ? Icons.pause_circle : Icons.play_circle),
                iconSize: 64,
                onPressed: () {
                  if (_isPlaying) {
                    audioHandler.pause();
                  } else {
                    audioHandler.play();
                  }
                },
              ),
        
              FilledButton(
                child: Text('Back to Home'),
                onPressed: () {
                  context.go('/home');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }


}



