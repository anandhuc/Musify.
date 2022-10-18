import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:musicplayer_firstproject/controller/audio_controller.dart';
import 'package:musicplayer_firstproject/database/box_instance.dart';
import 'package:musicplayer_firstproject/database/songs_adapter.dart';
import 'package:musicplayer_firstproject/screens/nowplaying/screen_nowplaying.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ScreenPlaylistSongs extends StatefulWidget {
  String titlePlaylist;
  ScreenPlaylistSongs({Key? key, required this.titlePlaylist})
      : super(key: key);

  @override
  State<ScreenPlaylistSongs> createState() => _ScreenPlaylistSongsState();
}

class _ScreenPlaylistSongsState extends State<ScreenPlaylistSongs> {
  final _box = Boxes.getInstance();
  final _audioController = AudioController();
  ValueNotifier<List<AllSongsModel>> allSongs =
      ValueNotifier(<AllSongsModel>[]);
  final list = ValueNotifier([]);
  List<Audio> songList = [];
  @override
  Widget build(BuildContext context) {
    List allList = _box.get("allSongs");
    allSongs.value = allList.cast<AllSongsModel>();
    list.value = _box.get(widget.titlePlaylist);

    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Theme.of(context).brightness == Brightness.light
                ? 'assets/hmscrn.jpeg'
                : 'assets/hmscr-dark.jpeg'), // <-- BACKGROUND IMAGE
            fit: BoxFit.cover,
          ), ), 
          child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Theme.of(context).brightness == Brightness.light? 
             Color.fromARGB(255  , 174, 169, 254) :Color.fromARGB(255, 74, 72, 110),
              
          title: Text(
            widget.titlePlaylist.toUpperCase(),
          ),
          actions: [
            IconButton(
                onPressed: () async {
                  return await Get.bottomSheet(addsong(context));
                },
                icon: Icon(Icons.add))
          ],
        ),
        body: allSongs.value.isNotEmpty?
        
        Padding(
            padding: const EdgeInsets.all(15.0),
            child: ValueListenableBuilder(
              valueListenable: list, 
              builder: (BuildContext context, List newPlalistSongs, _) {
                List newPlaylist = newPlalistSongs.toList();
                return Expanded(
                  child: ListView.separated(
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        onTap: () async {
                          songList =
                              _audioController.converterToAudio(newPlaylist);
                          await _audioController.openToPlayingScreen(
                              songList, index);
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ScreenNowPlaying(),
                          ));
                        },
                        tileColor: Color.fromARGB(145, 211, 207, 248),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        leading: Hero(
                          tag: index,
                          child: Container(
                            width: 50,
                            height: 50,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: QueryArtworkWidget(
                                id: newPlaylist[index].id,
                                type: ArtworkType.AUDIO,
                                nullArtworkWidget: Image(
                                  image: AssetImage('assets/music.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                        title: Text(
                          newPlaylist[index].title,
                          maxLines: 1,
                          style: TextStyle(fontSize: 20),
                        ),
                        subtitle: Text(
                          newPlaylist[index].artist,
                          style: TextStyle(fontSize: 15),
                          maxLines: 1,
                        ),
                        trailing: IconButton(
                            onPressed: () {
                              Get.defaultDialog(
                                  backgroundColor: Colors.transparent,
                                  title: " ",
                                  content: Container(
                                    width: 270,
                                    height: 200, 
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Color.fromARGB(255, 252, 220, 205),
                                            Color.fromARGB(500, 174, 169, 254)
                                          ],
                                        )),
                                    child: Center(
                                        child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 12,
                                        ),
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          child: Container(
                                            width: 60,
                                            height: 60,
                                            color: Color.fromARGB(
                                                255, 141, 148, 249),
                                            child: Icon(
                                              Icons.delete,
                                              size: 50,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),

                                        Text(
                                          '  Delete playlist ?',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                icon: Icon(
                                                  Icons.clear,
                                                  color: Colors.red,
                                                )),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            IconButton(
                                                onPressed: () async {
                                                  list.value.remove(
                                                      list.value[index]);
                                                  await _box.put(
                                                      widget.titlePlaylist,
                                                      list.value);
                                                  list.notifyListeners();

                                                  Navigator.of(context).pop();
                                                },
                                                icon: Icon(
                                                  Icons.done,
                                                  color: Colors.green,
                                                ))
                                          ],
                                        ),

                                      
                                      ],
                                    )),
                                  ));
                            },
                            icon: Icon(Icons.delete)),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider(
                        height: 10,
                        color: Colors.transparent,
                      );
                    },
                    itemCount: newPlaylist.length,
                  ),
                );
              },
            )):
            Padding(padding: EdgeInsets.all(8),
            child: Center(
              child: Text('No songs added yet',style: GoogleFonts.dancingScript(fontSize: 25),),
            ),)
      ),
    );
  }

  Widget addsong(BuildContext context) { 
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Container(
        decoration: BoxDecoration( 
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [ Theme.of(context).brightness == Brightness.light? 
            Color.fromARGB(255, 252, 220, 205):Color.fromARGB(255, 126, 99, 86),
            Theme.of(context).brightness == Brightness.light?


            Color.fromARGB(244, 154, 147, 249):
            Color.fromARGB(244, 86, 83, 141)
          ],
            ),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        child: ValueListenableBuilder(
          valueListenable: allSongs,
          builder: (BuildContext context, List allSongsList, _) {
            return ListView.separated(
                itemBuilder: (context, index) {
                  return songs(context, allSongsList, index);
                },
                separatorBuilder: (context, index) {
                  return Divider(
                    indent: 30,
                    endIndent: 30,
                  );
                },
                itemCount: allSongsList.length);
          },
        ),
      ),
    );
  }

  songs(BuildContext context, List newList, int index) {
    return ListTile(
      leading: Hero(
          tag: index,
          child: Container(
            height: 50,
            width: 50,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: QueryArtworkWidget(
                id: newList[index].id,
                type: ArtworkType.AUDIO,
                nullArtworkWidget: Image(
                  image: AssetImage('assets/music.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          )),
      title: Text(
        newList[index].title,
        maxLines: 1,
      ),
      subtitle: Text(newList[index].artist.toString()),
      trailing: ValueListenableBuilder(
        valueListenable: list,
        builder: (BuildContext context, List playlistSongs, _) {
          return list.value
                  .where((element) => element.id == allSongs.value[index].id)
                  .isEmpty
              ? IconButton(
                  onPressed: () async {
                    list.value.add(newList[index]);
                    await _box.put(widget.titlePlaylist, list.value);
                    list.notifyListeners();
                  },
                  icon: Icon(Icons.add))
              : IconButton(
                  onPressed: () async {
                    list.value.removeWhere((element) =>
                        element.id.toString() ==
                        allSongs.value[index].id.toString());
                    await _box.put(widget.titlePlaylist, list.value);
                    list.notifyListeners();
                  },
                  icon: Icon(Icons.remove));
        },
      ),
    );
  }
}
