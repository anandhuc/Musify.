

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:get/get.dart';


import 'package:musicplayer_firstproject/controller/notifications.dart';

class AudioController extends GetxController{
  final _assetsAudioPlayer = AssetsAudioPlayer.withId("0");
  var notifi = NotificationUser.getNotifiStatus();
  Future<void> openToPlayingScreen(List<Audio> list, int index) async {
    notifi ??= true;

    await _assetsAudioPlayer.open(
      Playlist(audios: list, startIndex: index),
      showNotification: notifi,
      playInBackground: PlayInBackground.enabled,
      notificationSettings: NotificationSettings(
        playPauseEnabled: true,
        stopEnabled: false, 
      ),
      loopMode: LoopMode.playlist,
      
    );
  }

  List<Audio> converterToAudio(List list) {
    List<Audio> songList = [];
    for (var item in list) {
      songList.add(
        Audio.file(
          item.uri.toString(),
          metas: Metas(
            title: item.title,
            artist: item.artist,
            id: item.id.toString(),
          ),
        ),
      );
    }
    return songList;
  }
}
