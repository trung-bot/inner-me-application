import 'dart:async';

import 'package:audio_session/audio_session.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:do_not_disturb/do_not_disturb.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inner_me_application/core/style.dart';
import 'dart:io';
import 'package:app_settings/app_settings.dart';

import 'package:just_audio/just_audio.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<Homepage> {
  final _dndPlugin = DoNotDisturbPlugin();
  final player = AudioPlayer();

  bool? isProbablyDnd;

  final imagList = [
    'assets/images/homepage/slide-1.png',
    'assets/images/homepage/slide-2.png',
    'assets/images/homepage/slide-3.png',
    'assets/images/homepage/slide-4.png',
  ];
  openDiary() {
    if (Platform.isAndroid) {
      _checkDndEnabled().then((isDndEnabled) {
        if (!isDndEnabled) {
          _checkNotificationPolicyAccessGranted().then((
            isNotificationPolicyAccessGranted,
          ) {
            if (!isNotificationPolicyAccessGranted) {
              _openNotificationPolicyAccessSettings();
            } else {
              openDND();
            }
          });
        } else {
          playMusic();
        }
      });
    } else if (Platform.isIOS) {
      _checkDndIOS().then((x) {
        if (isProbablyDnd != null) {
          if (!isProbablyDnd!) {
            AppSettings.openAppSettings();
          }
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    try {
      if (Platform.isIOS) {
            _initAudio();
          }
    } catch (e){
      print('e');
    }
    
  }

  Future<void> _initAudio() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());

    session.interruptionEventStream.listen((event) {
      if (event.begin) {
        setState(() {
          isProbablyDnd = true;
        });
      }
    });
  }

  Future<void> _checkDndIOS() async {
    setState(() {
      isProbablyDnd = null;
    });

    try {
      // File mp3 nhỏ để test (bạn thay bằng file local asset)
      await player.setAsset('assets/test_sound.mp3');
      await player.play();
      await Future.delayed(Duration(seconds: 2));
    } catch (e) {
      print(e);
    }

    if (isProbablyDnd == null) {
      setState(() {
        isProbablyDnd = false;
      });
    }
  }

  Future<bool> _checkDndEnabled() async {
    try {
      final bool isDndEnabled = await _dndPlugin.isDndEnabled();
      return isDndEnabled;
    } catch (e) {
      return false;
    }
  }

  openDND() {
    return showDialog(
      context: context,
      builder: (builder) {
        return HomeSlide(
          image: imagList[0],
          body: Column(
            children: [
              Text(
                'Inner Me',
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                  color: IMAppColor.appWhite,
                  fontSize: 30,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Hãy tập trung vào chính bạn ngay lúc này',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium!.copyWith(color: IMAppColor.appWhite),
              ),
              SizedBox(height: 10),

              FilledButton(
                onPressed: () {
                  toggleDndMode();
                  Timer.periodic(Duration(seconds: 1), (timer) {
                      playMusic();
                  });
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: IMAppColor.appGrey, width: 1),
                  ),
                  backgroundColor: IMAppColor.appWhite,
                  padding: EdgeInsets.zero,
                ),
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Text(
                    'Bật Chế Độ Tập Trung',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: IMAppColor.appBlack,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
             
            ],
          ),
        );
      },
    );
  }

  playMusic() {
    context.push('/audio');
  }

  toggleDndMode() async {
    await _checkNotificationPolicyAccessGranted();
    await Future.delayed(const Duration(milliseconds: 50));
    _checkNotificationPolicyAccessGranted().then((i) {
      if (i) {
        _setInterruptionFilter(InterruptionFilter.alarms);
      }
    });
  }

  Future<bool> _checkNotificationPolicyAccessGranted() async {
    try {
      final bool isNotificationPolicyAccessGranted = await _dndPlugin
          .isNotificationPolicyAccessGranted();
      return isNotificationPolicyAccessGranted;
    } catch (e) {
      return false;
    }
  }

  Future<void> _openNotificationPolicyAccessSettings() async {
    try {
      await _dndPlugin.openNotificationPolicyAccessSettings();
    } catch (e) {
      print('Error opening notification policy access settings: $e');
    }
  }

  Future<void> _setInterruptionFilter(InterruptionFilter filter) async {
    try {
      await _dndPlugin.setInterruptionFilter(filter);
      _checkDndEnabled();
    } catch (e) {
      print('Error setting interruption filter: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: CarouselSlider(
        options: CarouselOptions(
          height: height,
          viewportFraction: 1.0,
          enlargeCenterPage: false,
          enableInfiniteScroll: false,
          autoPlay: false,
        ),
        items: [
          HomeSlide(
            image: imagList[0],
            body: Column(
              children: [
                Text(
                  'Inner Me',
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                    color: IMAppColor.appWhite,
                    fontSize: 30,
                  ),
                ),
              ],
            ),
          ),
          HomeSlide(
            image: imagList[0],
            body: Column(
              children: [
                Text(
                  'Inner Me',
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                    color: IMAppColor.appWhite,
                    fontSize: 30,
                  ),
                ),

                SizedBox(height: 10),
                Text(
                  'Bạn có nghe thấy không?',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium!.copyWith(color: IMAppColor.appWhite),
                ),
                Text(
                  'Đã bao lâu rồi bạn chưa trò chuyện với chính mình...',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium!.copyWith(color: IMAppColor.appWhite),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          HomeSlide(
            image: imagList[0],
            body: Column(
              children: [
                Text(
                  'Inner Me',
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                    color: IMAppColor.appWhite,
                    fontSize: 30,
                  ),
                ),

                SizedBox(height: 10),
                Text(
                  'Chúng ta thường đi qua những ngày buồn mà chẳng kịp gọi tên cảm xúc.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium!.copyWith(color: IMAppColor.appWhite),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Những câu hỏi bị bỏ quên, những cảm xúc chưa từng được lắng nghe ...',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium!.copyWith(color: IMAppColor.appWhite),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          HomeSlide(
            image: imagList[0],
            body: Column(
              children: [
                Text(
                  'Inner Me',
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                    color: IMAppColor.appWhite,
                    fontSize: 30,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Bạn sẵn sàng chưa?',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium!.copyWith(color: IMAppColor.appWhite),
                ),
                Text(
                  'Chuyến phiêu lưu vào nội tâm đang chờ bạn mở trang đầu tiên',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium!.copyWith(color: IMAppColor.appWhite),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),

                FilledButton(
                  onPressed: openDiary,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: IMAppColor.appGrey, width: 1),
                    ),
                    backgroundColor: IMAppColor.appWhite,
                    padding: EdgeInsets.zero,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Text(
                      'Mở nhật ký',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: IMAppColor.appBlack,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                 FilledButton(
                onPressed: () {
                  context.go('/audio');
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: IMAppColor.appGrey, width: 1),
                  ),
                  backgroundColor: IMAppColor.appWhite,
                  padding: EdgeInsets.zero,
                ),
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Text(
                    'Phát nhạc',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: IMAppColor.appBlack,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HomeSlide extends StatelessWidget {
  final String image;
  final Widget body;
  const HomeSlide({required this.image, required this.body, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(image), fit: BoxFit.fill),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Center(child: body)],
      ),
    );
  }
}
