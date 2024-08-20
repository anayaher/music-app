import 'package:client/core/providers/current_song_notifier.dart';
import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/utils.dart';
import 'package:client/core/widgets/loader.dart';
import 'package:client/features/home/viewmodel/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SongsPage extends ConsumerStatefulWidget {
  const SongsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SongsPageState();
}

class _SongsPageState extends ConsumerState<SongsPage> {
  @override
  Widget build(BuildContext context) {
    final localSongs =
        ref.watch(homeViewmodelProvider.notifier).getLocalSongs();
    final currentSong = ref.watch(currentSongNotifierProvider);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      decoration: currentSong == null
          ? null
          : BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  hexToColor(
                    currentSong.hex_code,
                  ),
                  Pallete.transparentColor
                ],
                stops: const [0.0, 0.2],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 36),
            child: SizedBox(
              height: 280,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: localSongs.length,
                itemBuilder: (context, index) {
                  final songd = localSongs[index];
                  return GestureDetector(
                    onTap: () {
                      ref
                          .read(currentSongNotifierProvider.notifier)
                          .updateSong(songd);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: Pallete.borderColor,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 56,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(
                                      songd.thumbnail_url,
                                    ),
                                    fit: BoxFit.cover),
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Flexible(
                            child: Text(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              songd.song_name,
                              style: const TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w700),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              'Latest Today',
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.w700),
            ),
          ),
          ref.watch(getAllSongsProvider).when(data: (songs) {
            return SizedBox(
              height: 260,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: songs.length,
                itemBuilder: (context, index) {
                  final song = songs[index];

                  return GestureDetector(
                    onTap: () {
                      ref
                          .read(currentSongNotifierProvider.notifier)
                          .updateSong(song);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 180,
                            height: 180,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(
                                  song.thumbnail_url,
                                ),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(7),
                            ),
                          ),
                          const SizedBox(height: 5),
                          SizedBox(
                            width: 180,
                            child: Text(
                              song.song_name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                overflow: TextOverflow.ellipsis,
                              ),
                              maxLines: 1,
                            ),
                          ),
                          SizedBox(
                            width: 180,
                            child: Text(
                              song.artist,
                              style: const TextStyle(
                                color: Pallete.subtitleText,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                overflow: TextOverflow.ellipsis,
                              ),
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }, error: (error, stackTrace) {
            return Center(
              child: Text(error.toString()),
            );
          }, loading: () {
            return const Loader();
          })
        ],
      ),
    );
  }
}
