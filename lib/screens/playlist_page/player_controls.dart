import 'package:flutter/material.dart';
import 'package:inner_me_application/core/services/audio/audio_handler.dart';
import 'package:inner_me_application/screens/playlist_page/volume_controls.dart';
import 'package:just_audio/just_audio.dart';

class PlayerControls extends StatelessWidget {
   final IMAudioHandler player;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  const PlayerControls({
    super.key,
    required this.player,
    required this.onPrev,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0B0E11),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Slider
          StreamBuilder<Duration>(
            stream: player.positionStream,
            builder: (context, snapshot) {
              final pos = snapshot.data ?? Duration.zero;
              final dur = player.duration ?? Duration.zero;

              return Slider(
                min: 0,
                max: dur.inMilliseconds.toDouble().clamp(1, double.infinity),
                value: pos.inMilliseconds.toDouble().clamp(
                      0,
                      dur.inMilliseconds.toDouble().clamp(1, double.infinity),
                    ),
                onChanged: (val) =>
                    player.seek(Duration(milliseconds: val.round())),
                activeColor: Colors.blueAccent,
                inactiveColor: Colors.white24,
              );
            },
          ),

          // Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.skip_previous),
                color: Colors.white70,
                iconSize: 36,
                onPressed: onPrev,
              ),
              StreamBuilder<PlayerState>(
                stream: player.playerStateStream,
                builder: (context, snapshot) {
                  final playing = snapshot.data?.playing ?? false;
                  return IconButton(
                    iconSize: 56,
                    icon: Icon(
                      playing
                          ? Icons.pause_circle_filled
                          : Icons.play_circle_fill,
                    ),
                    color: Colors.white,
                    onPressed: () {
                      if (playing) {
                        player.pause();
                      } else {
                        player.play();
                      }
                    },
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.skip_next),
                color: Colors.white70,
                iconSize: 36,
                onPressed: onNext,
              ),
            ],
          ),

              VolumeControls()

        ],
      ),
    );
  }
}
