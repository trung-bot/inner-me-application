import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:inner_me_application/core/model/audio_model.dart';
import 'package:inner_me_application/core/services/audio/audio_service_singleton.dart';
import 'package:inner_me_application/screens/playlist_page/player_controls.dart';
import 'package:inner_me_application/screens/playlist_page/rotate_disk.dart';
import 'package:just_audio/just_audio.dart';

class AssetsMusicPlayer extends StatefulWidget {
  const AssetsMusicPlayer({super.key});
  @override
  State<AssetsMusicPlayer> createState() => _AssetsMusicPlayerState();
}

class _AssetsMusicPlayerState extends State<AssetsMusicPlayer> {
  final handler = AudioServiceSingleton.instance;

  // Playlist loaded from JSON
  List<AssetsAudioDTO> _playlists = [];
  int _currentIndex = 0;
  @override
  void initState() {
    super.initState();
    _loadPlaylist();
  }

  // Load playlist from JSON file in assets
  Future<void> _loadPlaylist() async {
    final data = await rootBundle.loadString('assets/audio/tracks.json');
    final list = jsonDecode(data) as List;
    _playlists = list
        .map((e) => AssetsAudioDTO(e["title"].toString(), e["path"].toString()))
        .toList();

    // Load first track automatically if playlist not empty
    if (_playlists.isNotEmpty) {
      _loadTrack(0);
    }
    setState(() {});
  }

  void _loadTrack(int index) async {
    await handler.playSong(_playlists[index].path, _playlists[index].title, null);
    // await _player.setAsset(_playlists[index].path);
    setState(() => _currentIndex = index);
  }

  void _nextTrack() {
    int next = (_currentIndex + 1) % _playlists.length;
    _loadTrack(next);
    handler.play();
  }

  void _prevTrack() {
    int prev = (_currentIndex - 1 + _playlists.length) % _playlists.length;
    _loadTrack(prev);
    handler.play();
  }

  String _getTitle(String path) => path.split('/').last;

  @override
  void dispose() {
    handler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, size: 30,),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward, size: 30,),
                    onPressed: () {
                      context.go('/journal');
                    },
                  ),
                ],
              ),

              StreamBuilder<PlayerState>(
                stream: handler.playerStateStream,
                builder: (context, snapshot) {
                  final playing = snapshot.data?.playing;
                  return RotatingDisc(
                    isPlaying:
                        playing ?? false, // automatically rotates when playing
                    size: 200,
                  );
                },
              ),
              // Playlist
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 20, horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D1114),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListView.separated(
                    itemCount: _playlists.length,
                    separatorBuilder: (_, __) =>
                        const Divider(color: Colors.white12),
                    itemBuilder: (context, index) {
                      final title = _getTitle(_playlists[index].title);
                      final isCurrent = index == _currentIndex;
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: isCurrent
                              ? Colors.blueAccent
                              : Colors.white12,
                          child: Icon(
                            isCurrent ? Icons.music_note : Icons.audiotrack,
                            color: Colors.white70,
                          ),
                        ),
                        title: Text(
                          title,
                          style: TextStyle(
                            color: isCurrent ? Colors.white : Colors.white70,
                          ),
                        ),
                        onTap: () {
                          _loadTrack(index);
                          handler.play();
                        },
                      );
                    },
                  ),
                ),
              ),
              PlayerControls(
                onNext: _nextTrack,
                onPrev: _prevTrack,
                player: handler,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
