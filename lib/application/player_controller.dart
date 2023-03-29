import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

import '../domain/model/music_model.dart';

class PlayerController extends GetxController {
  final player = AudioPlayer();
  bool isPlaying = false;
  bool isVolume = true;
  Duration? duration;
  RxInt selectIndex = 0.obs;
  bool loading = false;

  getMusics({required MusicModel model, required int index}) async {
    selectIndex.value = index;
    final playlist = ConcatenatingAudioSource(
      shuffleOrder: DefaultShuffleOrder(),
      children: [
        for (int i = 0; i < (model.data?.length ?? 0); i++)
          AudioSource.uri(Uri.parse(model.data?[i].preview ?? "")),
      ],
    );

    await player.setAudioSource(playlist, initialIndex: index);
    update();
  }

  pause() {
    player.pause();
    isPlaying = false;
    update();
  }

  play() {
    player.play();
    isPlaying = true;
    update();
  }

  setVolume() {
    isVolume ? player.setVolume(0) : player.setVolume(1);
    isVolume = !isVolume;
    update();
  }

  setSpeed(double speed) {
    player.setSpeed(speed);
  }

  removeMusic() {
    player.dispose();
  }
}
