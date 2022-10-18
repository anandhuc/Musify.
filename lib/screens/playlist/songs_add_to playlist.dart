import 'dart:ui';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:musicplayer_firstproject/database/box_instance.dart';
import 'package:musicplayer_firstproject/database/songs_adapter.dart';

class ScreenSongsAddToPlaylist extends StatefulWidget {
  int index;
  ScreenSongsAddToPlaylist({Key? key, required this.index}) : super(key: key);

  @override
  State<ScreenSongsAddToPlaylist> createState() =>
      _ScreenSongsAddToPlaylistState();
}

class _ScreenSongsAddToPlaylistState extends State<ScreenSongsAddToPlaylist> {
  final playlistControler = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final _box = Boxes.getInstance();
  final playlist = ValueNotifier([]);
  List<AllSongsModel> allSongslist = [];
  List<AllSongsModel> playList = [];

  Widget build(BuildContext context) {
    List allList = _box.get("allSongs");
    allSongslist = allList.cast<AllSongsModel>();
    final allkeys = _box.keys.toList();
    allkeys.remove("fav");
    allkeys.remove("allSongs");
    allkeys.remove("recent"); 
    playlist.value = allkeys;

    return Padding(
      padding: EdgeInsets.only(left: 5 ,right: 5) ,
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        decoration:  BoxDecoration(
             gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [ 
           
           
             Theme.of(context).brightness == Brightness.light? 
            Color.fromARGB(255, 252, 220, 205):Color.fromARGB(255, 126, 99, 86),
            Theme.of(context).brightness == Brightness.light?


             Color.fromARGB(500, 174, 169, 254):
            Color.fromARGB(244, 86, 83, 141)
          ],
        ), 
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              ClipRRect(borderRadius: BorderRadius.circular(20),
                child: Container(
                  color: Color.fromARGB(255, 248, 231, 223) ,
                  child: ListTile(
                    
                    leading: Container(
                      height: 50,
                      width: 50,
                      child: Center(
                        child: Icon(Icons.playlist_add),
                      ),
                    ),
                    title: Text("Create Playlist"),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) => showdiogbanner(context));
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ValueListenableBuilder(
                valueListenable: playlist,
                builder: (BuildContext context, List newPlaylist, _) {
                  return Expanded(
                      child: ListView.separated(
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: Icon(Icons.library_music_outlined),
                              title: Text(newPlaylist[index]),
                              onTap: () async {
                                List onePlaylist = _box.get(newPlaylist[index]);
                                if (onePlaylist
                                    .where((element) =>
                                        element.id.toString() ==
                                        allSongslist[widget.index]
                                            .id
                                            .toString())
                                    .isEmpty) {
                                  onePlaylist.add(allSongslist[widget.index]);

                                  await _box.put(
                                      playlist.value[index], onePlaylist);
                                  Get.back();
                                  await snackBar(
                                      allSongslist[widget.index].title,
                                      "Song added to playlist ${newPlaylist[index]}");
                                } else {
                                  await snackBar(
                                      allSongslist[widget.index].title,
                                      "Song allready exists");
                                }
                              },
                            );
                          },
                          separatorBuilder: (context, index) {
                            return Divider(
                              indent: 15 ,
                              endIndent: 15,
                            
                              color: Color.fromARGB(255, 150, 150, 150) ,
                            ); 
                          },
                          itemCount: newPlaylist.length));
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget showdiogbanner(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 15,
        sigmaY: 15,
      ),
      child: Dialog(
        backgroundColor: Colors.transparent ,
        child: Container(
          decoration: BoxDecoration(
               gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [ 
             Theme.of(context).brightness == Brightness.light? 
            Color.fromARGB(255, 252, 220, 205):Color.fromARGB(255, 126, 99, 86),
            Theme.of(context).brightness == Brightness.light?


             Color.fromARGB(500, 174, 169, 254):
            Color.fromARGB(244, 86, 83, 141)
         ],
        ), 
               borderRadius: BorderRadius.circular(15  )),
          width: 300,
          height: 200,
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Create Playlist",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25 ,color: Colors.white ),
                ),
                SizedBox(
                  height: 10,
                ),

                //form file ========================

                Form(
                    key: formKey,
                    child: Container(
                       height: 50,
                      
                      child: TextFormField(
                        
                        cursorHeight: 20,
                        controller: playlistControler,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(15 ),
                           borderSide: BorderSide(color: Colors.white ,width: 2  )
                          ),
                          border: OutlineInputBorder(
                            
                            borderRadius: BorderRadius.circular(15 ),
                            
                          ), 
                            filled: true,
                            // suffix: Padding(
                            //   padding: const EdgeInsets.only(top:10.0, ),  
                            //   child: IconButton(
                            //       onPressed: () {
                            //         playlistControler.clear();
                            //       },
                            //       icon: Icon(Icons.clear)),
                            // ),
                            fillColor: Color.fromARGB(244, 234, 234, 235), 
                            hintText: "Playlist Name...",
                            hintStyle: TextStyle(fontSize: 20)),
                        validator: (value) {
                          List keys = _box.keys.toList();
                          if (value!.isEmpty) {
                            return "Requried*";
                          }
                          if (keys
                              .where((element) => element == value)
                              .isNotEmpty) {
                            return "this name is already exists";
                          }
                        },
                      ),
                    )),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                        onPressed: () {
                          playlistControler.clear();
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancel',style: TextStyle(fontSize: 20,color: Colors.white ),)),
                    TextButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            String playListName = playlistControler.text;
                            _box.put(playListName, playList);
                            playlistControler.clear();
                            Navigator.of(context).pop();
                          }
                        },
                        child: Text('Create',style: TextStyle(fontSize: 20,color: Colors.white ),)) 
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  snackBar(String title, String message) {
    Get.snackbar(title, message,
        backgroundColor: Colors.white, duration: Duration(seconds: 3));
  }
}
