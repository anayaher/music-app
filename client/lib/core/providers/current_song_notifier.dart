import 'package:client/features/home/models/songModel.dart';
import 'package:client/features/home/repository/home_local_repository.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:just_audio/just_audio.dart';

part 'current_song_notifier.g.dart';

@riverpod
class CurrentSongNotifier extends _$CurrentSongNotifier {
  late HomeLocalRepository _homeLocalRepository;
  bool isPlaying = false;
  AudioPlayer? audioPlayer;
  @override
  Songmodel? build() {
    _homeLocalRepository = ref.watch(homeLocalRepositoryProvider);
    return null;
  }

  void playAndPause() {
    if (isPlaying == true) {
      audioPlayer!.stop();
    } else {
      audioPlayer!.play();
    }
    isPlaying = !isPlaying;
    state = state?.copyWith(hex_code: state?.hex_code);
  }

  void updateSong(Songmodel song) async {
    await audioPlayer?.stop();
    audioPlayer = AudioPlayer();
    final as = AudioSource.uri(Uri.parse(song.song_url),
        tag: MediaItem(
            id: song.id,
            title: song.song_name,
            artist: song.artist,
            artUri: Uri.parse(song.thumbnail_url)));

    await audioPlayer!.setAudioSource(as);

    _homeLocalRepository.uploadSongs(song);

    audioPlayer!.play();

    state = song;
    isPlaying = true;
  }
}
