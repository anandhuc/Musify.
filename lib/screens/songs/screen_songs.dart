import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:musicplayer_firstproject/controller/all%20songs/list_all_songs.dart';
import 'package:musicplayer_firstproject/controller/audio_controller.dart';
import 'package:musicplayer_firstproject/database/box_instance.dart';
import 'package:musicplayer_firstproject/database/songs_adapter.dart';
import 'package:musicplayer_firstproject/screens/nowplaying/screen_nowplaying.dart';
import 'package:musicplayer_firstproject/screens/playlist/songs_add_to%20playlist.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ScreenSongs extends StatefulWidget {
  const ScreenSongs({Key? key}) : super(key: key);

  @override
  State<ScreenSongs> createState() => _ScreenSongsState();
}

class _ScreenSongsState extends State<ScreenSongs> {
  final AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer.withId("0");
  final OnAudioQuery onAudioQuery = OnAudioQuery();

  final allSongsController = AllSongsController();
  final _audioController = AudioController();
  final box = Boxes.getInstance();
  List<Audio> songList = [];
  final allSongs = ValueNotifier(<AllSongsModel>[]);
  final favorites = ValueNotifier([]);
  var isLoading = ValueNotifier(true);
  final _allSongsController = Get.put(AllSongsController());
  final recent = ValueNotifier([]);  List<AllSongsModel> allSongslist = [];
  @override
  Widget build(BuildContext context) {
    List allList = box.get("allSongs");
    allSongslist = allList.cast<AllSongsModel>();
    isLoading.value = false;
    List _keys = box.keys.toList();
    if (_keys.where((element) => element == "allSongs").isNotEmpty) {
      List list = box.get("allSongs");
      allSongs.value = list.cast<AllSongsModel>();
    }
    if (_keys.where((element) => element == "fav").isNotEmpty) {
      favorites.value = box.get("fav");
    }
    if (_keys.where((element) => element == "recent").isNotEmpty) {  
      recent.value = box.get("recent");
    }

    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: GetBuilder<AllSongsController>(
                id: "home",
                builder: (_) {
                  return ListView.separated(
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return listtile(
                            context, _allSongsController.hiveList, index);
                      },
                      separatorBuilder: ((context, index) => SizedBox(
                            height: 10,
                          )),
                      itemCount: _allSongsController.hiveList.length);
                })));
  }

  Widget listtile(
    BuildContext context,
    List<AllSongsModel> newList,
    int index,
  ) {
    return ListTile(
      tileColor: Color.fromARGB(80, 245, 246, 247),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      leading: Hero(
        tag: index,
        child: ClipRRect(
          child: Container(
            width: 50,
            height: 50,
            child: QueryArtworkWidget(
              id: newList[index].id,
              type: ArtworkType.AUDIO,
              nullArtworkWidget: Image(
                image: AssetImage("assets/music.png"),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
      ),
      title: Text(
        newList[index].title,
        maxLines: 1,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
      ),
      subtitle: Text(
        newList[index].artist.toString(),
        style: TextStyle(
          fontSize: 15,
        ),
        maxLines: 1,
      ),
      onTap: () async {
        //  go to now playing
        try {
          songList = _audioController.converterToAudio(newList);
          await _audioController.openToPlayingScreen(songList, index);
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => ScreenNowPlaying()),
          );
        } catch (err) {
          await Get.defaultDialog(
              titleStyle: TextStyle(color: Colors.black),
              backgroundColor: Color.fromARGB(255, 174, 169, 254),
              content: Container(
                child: Text(
                  'Songs not found',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              cancel: TextButton(
                  onPressed: () {
                    Get.back<ScreenSongs>();
                  },
                  child: Text('OK', style: TextStyle(color: Colors.black))));
        }

        List onePlaylist = box.get("recent"); 
        
        if (onePlaylist
            .where((element) => 
                element.id.toString() == newList[index].id.toString())
            .isEmpty) {   
          recent.value.add(newList[index]);
          await box.put("recent", recent.value);  
        }  
      },
      onLongPress: () {
        bottomSheet(index, newList);
      },
    );
  }

  bottomSheet(index, List<AllSongsModel> newList) {
    showModalBottomSheet<void>(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext context) {
          return Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Color.fromARGB(255, 174, 169, 254)
                      : Color.fromARGB(255, 74, 72, 110),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15))),
              height: 80,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ValueListenableBuilder(
                        valueListenable: favorites,
                        builder: (context, List<dynamic> newHive, _) {
                          return favorites.value
                                  .where((element) =>
                                      element.id.toString() ==
                                      newList[index].id.toString())
                                  .isEmpty
                              ? Column(
                                  children: [
                                    SizedBox(
                                      height: 15,
                                    ),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Container(
                                        width: 40,
                                        height: 40,
                                        color: Theme.of(context).brightness ==
                                                Brightness.light
                                            ? Color.fromARGB(255, 252, 252, 252)
                                            : Color.fromARGB(
                                                255, 111, 109, 149),
                                        child: Center(
                                          child: IconButton(
                                            icon: Icon(
                                                Icons.favorite_border_outlined),
                                            onPressed: () async {
                                              favorites.value
                                                  .add(newList[index]);
                                              await box.put(
                                                  "fav", favorites.value);
                                              favorites.notifyListeners();
                                              Navigator.of(context).pop();

                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    ' Added to favorites',
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  duration:
                                                      Duration(seconds: 2),
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  width: 120,
                                                  padding: EdgeInsets.all(10),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text('Add to favorites')
                                  ],
                                )
                              : Column(
                                  children: [
                                    SizedBox(
                                      height: 15,
                                    ),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Container(
                                        color: Theme.of(context).brightness ==
                                                Brightness.light
                                            ? Color.fromARGB(255, 252, 252, 252)
                                            : Color.fromARGB(
                                                255, 111, 109, 149),
                                        width: 40,
                                        height: 40,
                                        child: Center(
                                          child: IconButton(
                                            onPressed: () async {
                                              favorites.value.removeWhere(
                                                  (element) =>
                                                      element.id.toString() ==
                                                      newList[index]
                                                          .id
                                                          .toString());
                                              await box.put(
                                                  "fav", favorites.value);
                                              favorites.notifyListeners();
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    'Removed from favorites',
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  duration:
                                                      Duration(seconds: 2),
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  width: 150,
                                                  padding: EdgeInsets.all(10),
                                                ),
                                              );
                                              Navigator.of(context).pop();
                                            },
                                            icon: Icon(Icons.favorite,
                                                color: Colors.red),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text('Remove from favorites')
                                  ],
                                );
                        }),
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Color.fromARGB(255, 252, 252, 252)
                                    : Color.fromARGB(255, 111, 109, 149),
                            width: 40,
                            height: 40,
                            child: Center(
                              child: IconButton(
                                onPressed: () {
                                  Get.bottomSheet(
                                      ScreenSongsAddToPlaylist(index: index));
                                },
                                icon: Icon(Icons.playlist_add),
                              ),
                            ),
                          ),
                        ),
                        Text('Add to playlist')
                      ],
                    )
                  ]));
        });
  }
}
               
                 
               
                
  
  
  





// ListView.separated(
//           physics: BouncingScrollPhysics(),
//           itemBuilder: (BuildContext context,int index) {
//             return ListTile(
            
//                tileColor: Color.fromARGB(80, 245, 246, 247),
//               shape:
//                   RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//               leading: Hero(
//                 tag: index,
//                 child: CircleAvatar(
//                   child: QueryArtworkWidget(
//                     id: newList[index].id,
//                   ),
//                   // backgroundColor: Color.fromARGB(108, 118, 117, 117),
//                   radius: 25,
//                 ),
//               ),
//               title: Text(
//                 'Song Name ',
//                 style: TextStyle(fontSize: 20 ,color: Color.fromARGB(255, 10, 10, 10) ),
//               ),
//               subtitle: Text('Artist ', style: TextStyle(fontSize: 15,color: Color.fromARGB(255, 5, 5, 5)  )),
//               onTap: () {
//                 //  go to now playing
//               },
//               onLongPress: () {
//                 bottomSheet();
//               },
//             );
//           },
//           separatorBuilder: (context, index) {
//             return Divider(
//               height: 5 ,
//               color: Colors.transparent ,
//             );
//           },
//           itemCount: 10,
//         );
