import 'package:client/core/providers/current_song_notifier.dart';
import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/widgets/loader.dart';
import 'package:client/features/home/view/pages/upload_songs.dart';
import 'package:client/features/home/viewmodel/home_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LibraryPage extends ConsumerStatefulWidget {
  const LibraryPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LibraryPageState();
}

class _LibraryPageState extends ConsumerState<LibraryPage> {
  @override
  Widget build(BuildContext context) {
    return ref.watch(getFavSongsProvider).when(
      data: (data) {
        return SafeArea(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  'Favourites',
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.w700),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: data.length + 1,
                  itemBuilder: (context, index) {
                    if (index == data.length) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const UploadSongPage(),
                              ));
                        },
                        child: const ListTile(
                          leading: CircleAvatar(
                            child: Icon(CupertinoIcons.plus),
                          ),
                          title: Text(
                            "Upload New Song",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w700),
                          ),
                        ),
                      );
                    }
                    final song = data[index];
                    return ListTile(
                      onTap: () {
                        ref
                            .read(currentSongNotifierProvider.notifier)
                            .updateSong(song);
                      },
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          song.thumbnail_url,
                        ),
                        radius: 35,
                        backgroundColor: Pallete.backgroundColor,
                      ),
                      title: Text(
                        song.song_name,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w700),
                      ),
                      subtitle: Text(song.artist,
                          style: const TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w600)),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
      error: (error, stackTrace) {
        return Center(
          child: Text(error.toString()),
        );
      },
      loading: () {
        return const Loader();
      },
    );
    return Container();
  }
}
