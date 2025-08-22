import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:inner_me_application/screens/playlist_page/playlist_page.dart';
import 'package:inner_me_application/screens/homepage/do_not_disturb.dart';
import 'package:inner_me_application/screens/homepage/hompage.dart';
import 'package:inner_me_application/screens/play_audio.dart';
import 'package:inner_me_application/screens/test/slide-text.dart';

RouterConfig<Object> routerConfig = GoRouter(
  initialLocation: '/home',
  routes: [
     GoRoute(path: '/home', name: 'home', builder: (context, state) => Homepage()),
     GoRoute(path: '/sturb', name: 'sturb', builder: (context, state) => DoNotDisturb()),
     GoRoute(path: '/audio', name: 'audio', builder: (context, state) => AudioPlayerScreen(audioAsset: 'assets/town.mp3')),
     GoRoute(path: '/playlist', name: 'audio2', builder: (context, state) => PlaylistPage()),
     GoRoute(path: '/slide', name: 'slide', builder: (context, state) => SlideTextAnimatedPage()),


  ]
);