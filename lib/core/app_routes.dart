import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:inner_me_application/screens/homepage/do_not_disturb.dart';
import 'package:inner_me_application/screens/homepage/hompage.dart';
import 'package:inner_me_application/screens/play_audio.dart';

RouterConfig<Object> routerConfig = GoRouter(
  initialLocation: '/home',
  routes: [
     GoRoute(path: '/home', name: 'home', builder: (context, state) => Homepage()),
     GoRoute(path: '/sturb', name: 'sturb', builder: (context, state) => DoNotDisturb()),
     GoRoute(path: '/audio', name: 'audio', builder: (context, state) => AudioPlayerScreen(audioAsset: 'assets/town.mp3')),

  ]
);