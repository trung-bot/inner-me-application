import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IMAudioHandler extends BaseAudioHandler {
  final _player = AudioPlayer();
  SharedPreferences? _prefs;

  IMAudioHandler() {
    _init();
    _notifyAudioHandlerAboutPlaybackEvents();
    _player.playerStateStream.listen((state) {
      // Map state to playbackState
      playbackState.add(
        playbackState.value.copyWith(
          playing: state.playing,
          processingState: mapProcessingState(state.processingState),
        ),
      );
    });
  }

  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();
    final lastTrack = _prefs?.getString('last_track') ?? '';
    final lastPosition = _prefs?.getInt('last_position') ?? 0;

    if (lastTrack.isNotEmpty) {
      await _player.setAsset(lastTrack);
      _player.seek(Duration(milliseconds: lastPosition));
    }

    _player.positionStream.listen((pos) {
      _prefs?.setInt('last_position', pos.inMilliseconds);
    });
  }

  Future<void> playSong(
    String assetPath,
    String? title,
    String? playlist,
  ) async {
    mediaItem.add(
      MediaItem(
        id: assetPath,
        album: playlist ?? 'My Album',
        title: title ?? 'Unknown',
      ),
    );

    await _player.setAsset(assetPath);
    _prefs?.setString('last_track', assetPath);

    play();
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> stop() async {
    await _player.stop();
    await _player.seek(Duration.zero);
  }

  void _notifyAudioHandlerAboutPlaybackEvents() {
    _player.playbackEventStream.listen((event) {
      final playing = _player.playing;
      playbackState.add(
        playbackState.value.copyWith(
          controls: [
            MediaControl.skipToPrevious,
            if (playing) MediaControl.pause else MediaControl.play,
            MediaControl.skipToNext,
            MediaControl.stop,
          ],
          systemActions: const {MediaAction.seek},
          androidCompactActionIndices: const [0, 1, 3],
          playing: playing,
          processingState: {
            ProcessingState.idle: AudioProcessingState.idle,
            ProcessingState.loading: AudioProcessingState.loading,
            ProcessingState.buffering: AudioProcessingState.buffering,
            ProcessingState.ready: AudioProcessingState.ready,
            ProcessingState.completed: AudioProcessingState.completed,
          }[_player.processingState]!,
        ),
      );
    });
  }

  Future<void> dispose() async {
    await _player.dispose();
  }

  AudioProcessingState mapProcessingState(ProcessingState state) {
    switch (state) {
      case ProcessingState.idle:
        return AudioProcessingState.idle;
      case ProcessingState.loading:
        return AudioProcessingState.loading;
      case ProcessingState.buffering:
        return AudioProcessingState.buffering;
      case ProcessingState.ready:
        return AudioProcessingState.ready;
      case ProcessingState.completed:
        return AudioProcessingState.completed;
    }
  }

  // Expose playerStateStream so UI can use it
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;

  Stream<Duration> get positionStream => _player.positionStream;

   Duration get duration => _player.duration ?? Duration.zero;
}
