import 'package:client/core/providers/current_song_notifier.dart';
import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/utils.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MusicPlayer extends ConsumerStatefulWidget {
  const MusicPlayer({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends ConsumerState<MusicPlayer> {
  @override
  Widget build(BuildContext context) {
    final CurrentSongNotifier = ref.watch(currentSongNotifierProvider);
    final songNoti = ref.watch(currentSongNotifierProvider.notifier);
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
            hexToColor(CurrentSongNotifier!.hex_code),
            const Color(0xff121212)
          ])),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Scaffold(
        backgroundColor: Pallete.transparentColor,
        appBar: AppBar(
          backgroundColor: Pallete.transparentColor,
          leading: Transform.translate(
            offset: const Offset(-15, 0),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Image.asset('assets/images/pull-down-arrow.png'),
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Hero(
                    tag: 'music-image',
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                  CurrentSongNotifier!.thumbnail_url))),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              CurrentSongNotifier.song_name,
                              style: const TextStyle(
                                  color: Pallete.whiteColor,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700),
                            ),
                            Text(
                              CurrentSongNotifier.artist,
                              style: const TextStyle(
                                  color: Pallete.subtitleText,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                        const Expanded(child: SizedBox()),
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              CupertinoIcons.heart,
                              color: Pallete.whiteColor,
                            ))
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Column(children: [
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                            overlayShape: SliderComponentShape.noOverlay,
                            thumbColor: Pallete.whiteColor,
                            trackHeight: 4,
                            activeTrackColor: Pallete.whiteColor,
                            inactiveTrackColor:
                                Pallete.whiteColor.withOpacity(0.117)),
                        child: Slider(
                          value: 0.5,
                          onChanged: (value) {},
                        ),
                      )
                    ]),
                    const Row(
                      children: [
                        Text(
                          "0:5",
                          style: TextStyle(
                              color: Pallete.subtitleText,
                              fontSize: 13,
                              fontWeight: FontWeight.w300),
                        ),
                        Expanded(child: SizedBox()),
                        Text(
                          "4:00",
                          style: TextStyle(
                              color: Pallete.subtitleText,
                              fontSize: 13,
                              fontWeight: FontWeight.w300),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Image.asset(
                            'assets/images/shuffle.png',
                            color: Pallete.whiteColor,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Image.asset(
                            'assets/images/previus-song.png',
                            color: Pallete.whiteColor,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            songNoti.playAndPause();
                          },
                          icon: Icon(
                            songNoti.isPlaying
                                ? CupertinoIcons.pause_circle_fill
                                : CupertinoIcons.play_circle_fill,
                            color: Pallete.whiteColor,
                          ),
                          iconSize: 80,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Image.asset(
                            'assets/images/next-song.png',
                            color: Pallete.whiteColor,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Image.asset(
                            'assets/images/repeat.png',
                            color: Pallete.whiteColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child:
                              Image.asset('assets/images/connect-device.png'),
                        ),
                        const Expanded(child: SizedBox()),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Image.asset('assets/images/playlist.png'),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
