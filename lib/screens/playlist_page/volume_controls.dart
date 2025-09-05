import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_volume_controller/flutter_volume_controller.dart';

class VolumeControls extends StatefulWidget {
  const VolumeControls({super.key});

  @override
  State<VolumeControls> createState() => _VolumeControlsState();
}

class _VolumeControlsState extends State<VolumeControls> {
  double _volume = 0.5;      // current system volume
  double _sliderValue = 0.5; // slider UI value
  bool _isMuted = false;
  Timer? _debounce;
  double _lastNonMuteVolume = 0.5; // để lưu volume trước khi mute

  @override
  void initState() {
    super.initState();

    // Lấy giá trị volume ban đầu
    FlutterVolumeController.getVolume().then((value) {
      if (!mounted) return;
      setState(() {
        _volume = value!;
        _sliderValue = value;
        _isMuted = value == 0.0;
        _lastNonMuteVolume = value > 0 ? value : 0.5;
      });
    });

    // Listener realtime
    FlutterVolumeController.addListener(_onSystemVolumeChanged);
  }

  @override
  void dispose() {
    FlutterVolumeController.removeListener();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSystemVolumeChanged(double volume) {
    if (!mounted) return;

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 50), () {
      setState(() {
        _volume = volume;
        _sliderValue = volume;
        _isMuted = volume == 0.0;
        if (!_isMuted) _lastNonMuteVolume = volume;
      });
    });
  }

  void _onSliderChanged(double value) {
    setState(() {
      _sliderValue = value;
      _isMuted = value == 0.0;
      if (!_isMuted) _lastNonMuteVolume = value;
    });

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 50), () {
      FlutterVolumeController.setVolume(value);
    });
  }

  void _toggleMute() {
    double targetVolume;
    if (_isMuted) {
      // Unmute: trả lại volume trước khi mute
      targetVolume = _lastNonMuteVolume > 0 ? _lastNonMuteVolume : 0.5;
    } else {
      // Mute
      targetVolume = 0.0;
    }

    setState(() {
      _sliderValue = targetVolume;
      _volume = targetVolume;
      _isMuted = !_isMuted;
    });

    FlutterVolumeController.setVolume(targetVolume);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            IconButton(
              icon: Icon(
                _isMuted ? Icons.volume_off : Icons.volume_up,
                color: Colors.white,
                size: 20,
              ),
              onPressed: _toggleMute,
            ),
            Expanded(
              child: Slider(
                value: _sliderValue,
                min: 0.0,
                max: 1.0,
                divisions: 100,
                activeColor: Colors.blueAccent,
                inactiveColor: Colors.grey,
                onChanged: _onSliderChanged,
              ),
            ),
          ],
        ),
       
      ],
    );
  }
}
