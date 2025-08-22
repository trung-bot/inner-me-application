import 'package:audio_service/audio_service.dart';
import 'package:inner_me_application/core/services/audio/audio_handler.dart';

class AudioServiceSingleton {
  static IMAudioHandler? _instance;

  static Future<IMAudioHandler> init() async {
    _instance  = await AudioService.init(builder: () => IMAudioHandler(),
    config: const AudioServiceConfig(
       androidNotificationChannelId: 'com.example.app.channel.audio',
        androidNotificationChannelName: 'Audio playback',
        androidNotificationOngoing: true,
    ));
    return _instance!;
  }

  static IMAudioHandler get instance {
    if(_instance == null) {
      throw Exception("error");
    }
    return _instance!;
  }
}
