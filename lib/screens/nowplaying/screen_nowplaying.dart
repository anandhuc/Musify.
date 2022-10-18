import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:musicplayer_firstproject/controller/all%20songs/list_all_songs.dart';
import 'package:musicplayer_firstproject/controller/audio_controller.dart';
import 'package:musicplayer_firstproject/database/box_instance.dart';
import 'package:musicplayer_firstproject/database/songs_adapter.dart';
import 'package:musicplayer_firstproject/screens/playlist/songs_add_to%20playlist.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ScreenNowPlaying extends StatefulWidget {
  const ScreenNowPlaying({Key? key}) : super(key: key);

  @override
  State<ScreenNowPlaying> createState() => _ScreenNowPlayingState();
}

class _ScreenNowPlayingState extends State<ScreenNowPlaying> {
  AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer.withId("0");
  var musicList = [];
  double deviceheight = 0;
  double devicewidth = 0;
  Audio? audio;
  bool isLopping = false;

  final _box = Boxes.getInstance();
  List<AllSongsModel> allSongs = [];
  final favourites = ValueNotifier([]);

  @override
  Widget build(BuildContext context) {
    final keys = _box.keys.toList();
    if (keys.where((element) => element == "allSongs").isNotEmpty) {
      List list = _box.get("allSongs");
      allSongs = list.cast<AllSongsModel>();
    }
    if (keys.where((element) => element == "fav").isNotEmpty) {
      favourites.value = _box.get("fav");
    }

    deviceheight = MediaQuery.of(context).size.height;
    devicewidth = MediaQuery.of(context).size.width;

    return Stack(children: [
      Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Theme.of(context).brightness == Brightness.light
                ? 'assets/hmscrn.jpeg'
                : 'assets/hmscr-dark.jpeg'), // <-- BACKGROUND IMAGE
            fit: BoxFit.cover,
          ),
        ),
      ),
      Scaffold(
        appBar: AppBar(
          title: Text('Now Playing'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          toolbarHeight: 70,
        ),
        backgroundColor: Colors.transparent,
        body: SafeArea(
            maintainBottomViewPadding: true,
            child: Container(
              width: devicewidth,
              height: deviceheight,
             
              child: buildPage(),
            )),
      ),
    ]);
  }

  Widget buildPage() {
    return Padding(
      padding: EdgeInsets.only(left: 8, right: 8),
      child: Column(
        children: [
          assetsAudioPlayer.builderCurrent(builder: (context, nowPlay) {
            return ClipRRect(
              child: Card(
                color: Colors.transparent,
                elevation: 15,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)),
                  height: deviceheight * 0.4,
                  width: devicewidth * 0.8,
                  child: QueryArtworkWidget(
                    artworkBorder: BorderRadius.circular(15),
                    id: int.parse(nowPlay.audio.audio.metas.id.toString()),
                    type: ArtworkType.AUDIO,
                    nullArtworkWidget: Container(
                      decoration: BoxDecoration(),
                      child: Image(
                        image: AssetImage("assets/music.png"),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
          SizedBox(height: 15),
          assetsAudioPlayer.builderRealtimePlayingInfos(
              builder: (context, realtimeplayer) {
            return Container(
              width: devicewidth * 0.8,
              height: deviceheight * 0.06,
              child: Center(
                child: Text(
                  realtimeplayer.current!.audio.audio.metas.title.toString(),
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }),
          SizedBox(
            height: deviceheight * 0.01,
          ),
          assetsAudioPlayer.builderRealtimePlayingInfos(
              builder: (context, realtimePlaying) {
            return Container(
              width: devicewidth * 0.8,
              height: deviceheight * 0.02,
              // color: Colors.amber,
              child: Center(
                child: Text(
                  realtimePlaying.current!.audio.audio.metas.artist.toString(),
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
                ),
              ),
            );
          }),
          SizedBox(
            height: deviceheight * 0.02,
          ),
          SizedBox(
            height: deviceheight * 0.02,
          ),
          assetsAudioPlayer.builderRealtimePlayingInfos(
              builder: (context, realtimePlaying) {
            return Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ValueListenableBuilder(
                      valueListenable: favourites,
                      builder: (BuildContext context,
                          List<dynamic> newFavourites, _) {
                        return favourites.value
                                .where((element) =>
                                    element.id.toString() ==
                                    realtimePlaying
                                        .current!.audio.audio.metas.id)
                                .isEmpty
                            ? IconButton(
                                icon: Icon(Icons.favorite),
                                onPressed: () async {
                                  var id = realtimePlaying
                                      .current!.audio.audio.metas.id;
                                  var indx = allSongs.indexWhere(
                                      (element) => element.id.toString() == id);
                                  favourites.value.add(allSongs[indx]);
                                  favourites.notifyListeners();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Added to favourites',
                                        textAlign: TextAlign.center,
                                      ),
                                      duration: Duration(seconds: 1),
                                      behavior: SnackBarBehavior.floating,
                                      width: 135,
                                      padding: EdgeInsets.all(10),
                                    ),
                                  );
                                })
                            : IconButton(
                                icon: Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                ),
                                onPressed: () async {
                                  var id = realtimePlaying
                                      .current!.audio.audio.metas.id;
                                  var indx = allSongs.indexWhere(
                                      (element) => element.id.toString() == id);

                                  favourites.value.removeWhere(
                                      (element) => element.id.toString() == id);
                                  await _box.put("fav", favourites.value);
                                  favourites.notifyListeners();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text(
                                        'Removed from favourites',
                                        textAlign: TextAlign.center,
                                      ),
                                      duration: Duration(seconds: 1),
                                      behavior: SnackBarBehavior.floating,
                                      width: 160,
                                      padding: EdgeInsets.all(10),
                                    ),
                                  );
                                },
                              );
                      }),
                  SizedBox(width: 80),
                  IconButton(
                      onPressed: () {
                        var id = realtimePlaying.current!.audio.audio.metas.id;
                        var indx = allSongs.indexWhere(
                            (element) => element.id.toString() == id);
                        Get.bottomSheet(ScreenSongsAddToPlaylist(index: indx));
                      },
                      icon: Icon(Icons.playlist_add))
                ],
              ),
            );
          }),
          SizedBox(height: deviceheight * 0.02),
          Container(
              width: devicewidth * 0.9,
              height: devicewidth * 0.03,
              child: assetsAudioPlayer.builderRealtimePlayingInfos(
                builder: (context, realtimePlaying) {
                  return slideBar(realtimePlaying);
                },
              )),
          SizedBox(
            height: deviceheight * 0.02,
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PlayerBuilder.currentPosition(
                  player: assetsAudioPlayer,
                  builder: (context, duration) {
                    var songTime = getTimeString(duration.inMilliseconds);
                    return Text(songTime);
                  },
                ),
                SizedBox(width: devicewidth * 0.7),
                assetsAudioPlayer.builderRealtimePlayingInfos(
                    builder: (context, realtimePlaying) {
                  return Text(
                    getTimeString(realtimePlaying.duration.inMilliseconds),
                   
                  );
                })
              ],
            ),
          ),
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween ,
              children: [
                Container(
                  child: assetsAudioPlayer.isShuffling.value
                      ? IconButton(
                          onPressed: () {
                            setState(() {
                              assetsAudioPlayer.toggleShuffle();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Shaffle off',
                                    textAlign: TextAlign.center,
                                  ),
                                  duration: Duration(seconds: 1),
                                  behavior: SnackBarBehavior.floating,
                                  width: 90,
                                  padding: EdgeInsets.all(10),
                                ),
                              );
                            });
                          },
                          icon: Icon(Icons.shuffle_on_outlined))
                      : IconButton(
                          onPressed: () {
                            setState(() {
                              assetsAudioPlayer.toggleShuffle();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Shaffle on',
                                    textAlign: TextAlign.center,
                                  ),
                                  duration: Duration(seconds: 1),
                                  behavior: SnackBarBehavior.floating,
                                  width: 90,
                                  padding: EdgeInsets.all(10),
                                ),
                              );
                            });
                          },
                          icon: Icon(Icons.shuffle)),
                ),

                Center(
                  child: IconButton(
                    onPressed: () async {
                      await previousSong();
                    },
                    icon: Icon(
                      Icons.skip_previous_rounded,
                      size: 50,
                    ),
                    padding: EdgeInsets.all(0),
                  ),
                ),
                SizedBox(width: 20),
                Container(
                  decoration: BoxDecoration(
                      color:Theme.of(context).brightness==Brightness.light?
                       Color.fromARGB(255, 171, 163, 252): Color.fromARGB(255, 86, 83, 129),
                      borderRadius: BorderRadius.circular(50)),
                  width: 80,
                  height: 80,
                  child: Center(
                    child: assetsAudioPlayer.builderIsPlaying(
                      builder: (context, isPlaying) {
                        return isPlaying
                            ? IconButton(
                                onPressed: () async {
                                  await assetsAudioPlayer.playOrPause();
                                },
                                icon: Icon(
                                  Icons.pause_sharp,
                                  size: 50,
                                ),
                                padding: EdgeInsets.all(0),
                              )
                            : IconButton(
                                onPressed: () async {
                                  await assetsAudioPlayer.playOrPause();
                                },
                                icon: Icon(
                                  Icons.play_arrow,
                                  size: 50,
                                ),
                                padding: EdgeInsets.all(0),
                              );
                      },
                    ),
                  ),
                ),
                
                Container(
                  width: 80,
                  height: 80,
                  child: Center(
                    child: IconButton(
                      onPressed: () async {
                        await nextSong();
                      },
                      icon: Icon(
                        Icons.skip_next,
                        size: 50,
                      ),
                      padding: EdgeInsets.all(0),
                    ),
                  ),
                ),
                Container (  
                  child: IconButton(
                      onPressed: () {
                        if (!isLopping) {
                          isLopping = true;
                          assetsAudioPlayer.setLoopMode(LoopMode.single);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(' Repeat on',
                                  textAlign: TextAlign.center),
                              duration: Duration(seconds: 1),
                              behavior: SnackBarBehavior.floating,
                              width: 90,
                              padding: EdgeInsets.all(10),
                            ),
                          );
                        } else {
                          isLopping = false;
                          assetsAudioPlayer.setLoopMode(LoopMode.playlist);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Repeat off',
                                textAlign: TextAlign.center,
                              ),
                              duration: Duration(seconds: 1),
                              behavior: SnackBarBehavior.floating,
                              width: 90,
                              padding: EdgeInsets.all(10),
                            ),
                          );
                        }
                      },
                      icon: Icon(Icons.repeat)),
                )
             
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget slideBar(RealtimePlayingInfos realtimeplayer) {
    return GetBuilder<AllSongsController>(
      init: AllSongsController(),
      initState: (_) {},
      builder: (_) {
        return SliderTheme(
            data: SliderThemeData(
              trackHeight: 5,
              thumbShape: SliderComponentShape.noThumb,
            ),
            child: Slider(
              value: realtimeplayer.currentPosition.inSeconds.toDouble(),
              max: realtimeplayer.duration.inSeconds.toDouble(),
              onChanged: (value) {
                Get.find<AllSongsController>().seekSongTime(value);
              },
              activeColor: Theme.of(context).brightness==Brightness.light?
                       Color.fromARGB(255, 171, 163, 252): Color.fromARGB(255, 86, 83, 129),
                       
              inactiveColor: Colors.grey,
            ));
      },
    );
  }

  //to convert the time into song time.
  String getTimeString(int milliseconds) {
    if (milliseconds == null) milliseconds = 0;
    String minutes =
        '${(milliseconds / 60000).floor() < 10 ? 0 : ''}${(milliseconds / 60000).floor()}';
    String seconds =
        '${(milliseconds / 1000).floor() % 60 < 10 ? 0 : ''}${(milliseconds / 1000).floor() % 60}';
    return '$minutes:$seconds';
  }

  previousSong() async {
    await assetsAudioPlayer.previous();
  }

  nextSong() async {
    await assetsAudioPlayer.next();
  }
}

